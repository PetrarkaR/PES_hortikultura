
#define SPI_Ethernet_HALFDUPLEX 0
#define SPI_Ethernet_FULLDUPLEX 1
#define DR PORTA.F5
#include "../commons/config.h"

unsigned char i, brojac, SLAVE_ID, OBB, ch, Flag1, Flag2, Flag3;
unsigned char seconds, minutes, hours;
// nizovi za svaki slejv
unsigned char Cmd[16];
unsigned char Mode[16]; // 16 modova za zalivanje
unsigned char Hour[16]; /*Podaci o vremenu  */
unsigned char Min[16];
unsigned char Sec[16];
unsigned char SWAMByte;
// Lcd pinout settings //LCD je vezan za PORTB
sbit LCD_RS at RC0_bit;
sbit LCD_RW at RC1_bit;
sbit LCD_EN at RC2_bit;
// DATABUS LCD na RB portove
sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;
// Pin direction
sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_RW_Direction at TRISC1_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;

void init_variables() {
  br_ch = 0x00;
  OBB = 0x00;
  Flag1 = 0x00;
  Flag2 = 0x00;
  Flag3 = 0x00;
  brojac = 0x00;
  SLAVE_ID = 0x0F;
  SWAMByte = 0x00;
  for (i = 0; i < 16; i++) {
    Operation[i] = 0x00;
    Comm[i] = 0x00;
    Cmd[i] = 0x00;
    Cat[i] = 0x00;
    Hour[i] = 0x00;
    Min[i] = 0x00;
    Sec[i] = 0x00;
  }
}

void init() {

  PIR1 = 0b00000000; // flegovi prijema preko UART-a
  PIE1 = 0b00100001; // dozvola prekida za UART, RCIE, TMR1IE
  // PIE1.TMR1IE = 1;
  // PIE1.RC1IE=1;

  T1CON = 0b10110000; // konfiguracija za tajmer1
  T1CON.TMR1ON = 1;
  /*16-bit operation
   preskaler 1:8
   25MH T0=40ns
   40ns*4*8=1.28us
   25ms=25000us=1.28*19531=  B5B3 */
  TMR1L = 0xB5;
  TMR1H = 0xB3;

  INTCON = 0b01000000; // periferijski interapt
  INTCON.GIE = 1;      // globalna dozvola prekida

  // svi pinovi na portu A su izlazi (vidi na semi)
  TRISA = 0x00;
  // obrati paznju, postoje tasteri na portovima RB0 - RB3, to su digitalni
  // ulazi
  TRISB = 0x0F; // ostali pinovi PORTB su izlazi
  TRISC = 0xD0; // 0b11010000; // ovo je OK

  PORTA = 0x00;
  PORTB = 0x00;
  PORTC = 0x00;

  ADCON0 = 0x00; // iskljucujemo A/D konverziju
  ADCON1 = 0x0F; // svi digitalni
  // PORTA.F0=0;

  UART1_Init(UART_BAUD_RATE);

  // konfigurisemo brzinu od 19200 i dodatne bitove za serijski prenos
  TXSTA.TXEN = 1;
  RCSTA.SPEN = 1;
  RCSTA.CREN = 1;

  Lcd_Init();
  Lcd_Cmd(_LCD_CURSOR_OFF);
  UpdateLCD();
}

void transmit(unsigned char DATA8b) {
  TXREG = DATA8b;
  while (!TXSTA.TRMT)
    ;
}

void interrupt() {
  if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1)) {
    // prekid tajmera 1 -  na svakih 25ms PIE1.TMR1IE = 1;
    PIR1.TMR1IF = 0;
    if (brojac == 0x04) { // na svakih 125ms prozivka slejvova
      brojac = 0x00;
    } else {
      brojac++;
    }
    TMR1L = 0xB5;
    TMR1H = 0xB3; // reset tajmera
  }

  if ((PIE1.RCIE) && (PIR1.RCIF)) { // UART RECIEVE FROM SLAVE
    unsigned char ch;
    PIR1.RCIF = 0; // Recieve flag na 0
    ch = RCREG;    // prima se bajt preko UART-a
    switch (OBB) {
    case 0:
      if ((ch & 0xE0) == STATUS_CODE) {
        OBB = 0x01;
      }
      break;
    case 1:
      SWAMByte = ch;
      OBB = 0x00;
      break;
    default:
      OBB = 0x00;
      break;
    }
  }
}
// TODO Dodaj funkciju za funkcije zalivanja

void main(void) {

  unsigned char ByteX = 0x00;

  init();
  init_variables();

  while (1) {
  }
}
