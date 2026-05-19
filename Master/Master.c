
#define SPI_Ethernet_HALFDUPLEX 0
#define SPI_Ethernet_FULLDUPLEX 1
#define DR PORTA.F5
#define ButtonInc PORTB.F0
#define ButtonDec PORTB.F1
#include "../commons/config.h"
//==========GLOBAL VARIABLES============================
typedef struct {
  unsigned canCloseTCP : 1; // socket close flagg
  unsigned isBroadcast : 1;
} TEthPktFlags;
struct Mode {
  unsigned char startHour;
  unsigned char startMin;
  unsigned char durationsH;
  unsigned char durationsL;
};
struct Garden {
  unsigned char modeID;
  unsigned char gardenSend;
};
// svi delovi structa su iste velicine, tako da nemamo padding i podaci bi
// trebalo da se dobavljaju brze, posto su jedan do drugog
const unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: ";
const unsigned char httpMimeTypeHTML[] = "text/html\n\n";
const unsigned char httpMimeTypeScript[] = "text/plain\n\n";
unsigned char httpMethod[] = "GET /";

sfr sbit SPI_Ethernet_Rst at RA1_bit; // reset PIN
sfr sbit SPI_Ethernet_CS at RA0_bit;  // chip select PIN
sfr sbit SPI_Ethernet_Rst_Direction at TRISA1_bit;
sfr sbit SPI_Ethernet_CS_Direction at TRISA0_bit;

/*IP i MAC adrese */
// NIC
unsigned char myMacAddr[6] = MAC_ADDR;
unsigned char myIpAddr[4] = IP_ADDR;
unsigned char getRequest[20];
unsigned char dyna[31];
unsigned long httpCounter = 0;

unsigned char i, brojac, SLAVE_ID, ByteID, ch, Flag1, FlagRTC, FlagPoll;
unsigned char seconds, minutes, hours;
unsigned char buffer[150];
unsigned char no_ch;
// nizovi za svaki slejv
unsigned char Cmd[16];
unsigned char Comm[16]; // Slave Alive Byte
unsigned char Hour[16]; /*Podaci o vremenu  */
unsigned char Min[16];
unsigned char Sec[16];
unsigned char Status1[16]; // SWAM
unsigned char updateLCDFlag;
unsigned char btnCnt;
unsigned char cntDisp;
unsigned char showProgram;
unsigned char showStatus;
unsigned char showCnt;
unsigned char incCnt;
// Modovi za slejv //// PROGRAM /p |XX|HH|MM|SS|SS|
struct Mode Program[16];
// Garden /bXX|YY
struct Garden Garden[16]; // ovo saljem slejvu
//  Lcd pinout settings //LCD je vezan za PORTB
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
//==================INIT VARIABLES======================
void init_variables() {

  no_ch = 0x00;
  ByteID = 0x00;
  Flag1 = 0x00;
  FlagRTC = 0x00;
  FlagPoll = 0x00;
  updateLCDFlag = 0x00;
  btnCnt = 0x00;
  cntDisp = 0x00;
  // cnt = 0x00;
  SLAVE_ID = 0x0F;
  for (i = 0; i < 16; i++) {
    Comm[i] = 0x00;
    Hour[i] = 0x00;
    Min[i] = 0x00;
    Sec[i] = 0x00;
    Status1[i] = 0x00;
    Program[i].startHour = 0x00;
    Program[i].startMin = 0x00;
    Program[i].durationsH = 0x00;
    Program[i].durationsL = 0x00;
    Garden[i].modeID = 0x00;
    Garden[i].gardenSend = 0x00;
  }
}
//===========INIT REGISTERS=====================================
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
  SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,
                     _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
  SPI_Ethernet_Init(myMacAddr, myIpAddr, SPI_Ethernet_FULLDUPLEX);
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);
  // UpdateLCD();
}
//=========================ETHERNET===================================================
unsigned int putConstString(const char *s) {
  unsigned int cnt = 0;
  while (*s) {
    SPI_Ethernet_putByte(*s++);
    cnt++;
  }
  return (cnt);
}
unsigned int putString(char *s) {
  unsigned int cnt = 0;
  while (*s) {
    SPI_Ethernet_putByte(*s++);
    cnt++;
  }
  return (cnt);
}
void appendBuffer(char *p_ch) {
  while ((*p_ch) != 0x00) {
    buffer[no_ch] = *p_ch;
    no_ch++;
    p_ch++;
  }
}
void formBuffer() {
  unsigned char i = 0;
  unsigned char txt[4];
  unsigned char StatusByte = 0x00;
  no_ch = 0x00; // pozicioniranje na pocetak niza

  for (i = 0; i < 16; i++) {
    if (Comm[i] == 1) { // samo slejvovi koji su se odazvali
      appendBuffer("Basta:");
      ByteToStr(i, txt);
      appendBuffer(txt); // append broj baste
      appendBuffer(" ");

      StatusByte = Status1[i];
      // prosto testiranje SWAM nibbla koji slave salje na
      // master i ispisavnje statusa na master racunar
      if (!(StatusByte & STATUS_SYSTEM_BIT)) {
        appendBuffer("OFF\n\n");
      } else if (StatusByte & STATUS_WATER_BIT) {
        if (StatusByte & STATUS_MANUAL_BIT) {
          appendBuffer("Watering(Manual_Mode)\n\n");
          if (StatusByte & STATUS_ALARM_BIT) {
            appendBuffer("ALARM ON\n\n");
          }
        } else {
          appendBuffer("Watering(Automatic_Mode)\n\n");
          if (StatusByte & STATUS_ALARM_BIT) {
            appendBuffer("ALARM ON\n\n");
          }
        }
      }

      else {
        appendBuffer("IDLE\n\n");
      }
    }
  }
  buffer[no_ch] = 0x00;
  no_ch++; // kraj stringa
}
unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost,
                                  unsigned int remotePort,
                                  unsigned int destPort, unsigned int reqLength,
                                  TEthPktFlags *flags) {
  return 0;
}
unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost,
                                  unsigned int remotePort,
                                  unsigned int localPort,
                                  unsigned int reqLength, char *canCloseTCP) {
  unsigned int len = 0; // reply length
  unsigned int i;
  if (localPort != 80) {
    return 0;
  }
  PORTA.F4 = 1;
  for (i = 0; i < 16; i++) {
    getRequest[i] = SPI_Ethernet_getByte();
  }
  getRequest[i] = 0;

  if (memcmp(getRequest, httpMethod, 5)) {
    return 0;
  }
  if (getRequest[5] == 's') { // POLL
    FlagPoll = 1;
  }
  if (getRequest[5] == 'r') { // RTC
    // RTC setup
    FlagRTC = 0x01; // setovanje Flega za RTC
    // ASCII konverzija koja se vrsi pri dobijanju podatka 0=>030, ako
    // dobijemo broj 8 => 0x38 propustimo samo donji nibble maskom 0x0F i
    // dobijemo 0x08
    hours = (getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F);
    minutes = (getRequest[8] & 0x0F) * 10 + (getRequest[9] & 0x0F);
    seconds = (getRequest[10] & 0x0F) * 10 + (getRequest[11] & 0x0F);
  } else if (getRequest[5] == 'b') { // basta /bXX|YY /567
    Garden[(getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F)].modeID =
        (getRequest[8] & 0x0F) * 10 + (getRequest[9] & 0x0F);
    Garden[(getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F)].gardenSend =
        0x01;
  } else if (getRequest[5] == 'p') { // Program

    // Koristimo struct Program kako bi smo smanjili sansu pristupa
    // popgresnoj memoriji u nassem slucauju /pXXHHMMSSSS => idx =
    // XX => Program[XX].HH=ASCII(HH);
    unsigned char idx;
    idx = (getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F);
    Program[idx].startHour =
        (getRequest[8] & 0x0F) * 10 + (getRequest[9] & 0x0F);
    Program[idx].startMin =
        (getRequest[10] & 0x0F) * 10 + (getRequest[11] & 0x0F);
    Program[idx].durationsH =
        (getRequest[12] & 0x0F) * 10 + (getRequest[13] & 0x0F);
    Program[idx].durationsL =
        (getRequest[14] & 0x0F) * 10 + (getRequest[15] & 0x0F);
    // cuva program u memoriju
  }
  if (len == 0) {
    formBuffer();
    len = putConstString(httpHeader);
    len += putConstString(httpMimeTypeHTML);
    len += putString(buffer);
    for (i = 0; i < 16; i++) {
      Comm[i] = 0x00;
      Hour[i] = 0x00;
      Min[i] = 0x00;
      Sec[i] = 0x00;
    }
  }
  return len; // return to the library with the number of bytes to transmit
}

void transmit(unsigned char DATA8b) {
  TXREG = DATA8b;
  while (!TXSTA.TRMT)
    ;
}
//=======================INTERRUPT===============================
void interrupt() {
  if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1)) {
    // prekid tajmera 1 -  na svakih 25ms PIE1.TMR1IE = 1;
    PIR1.TMR1IF = 0;
    if (brojac == 0x04) { // na svakih 125ms prozivka slejvova
      brojac = 0x00;
      Flag1 = 0x01;
    } else {
      brojac++;
    }
    // 25ms
    if ((ButtonInc == 1) && btnCnt == 0) {
      btnCnt = 20;
      updateLCDFlag = 1;
      if (cntDisp >= 20) {
        cntDisp = 0;
      } else {
        cntDisp++;
      }
    } else if (btnCnt > 0) {
      btnCnt--;
    }
    if ((ButtonDec == 1) && btnCnt == 0) {
      btnCnt = 20;
      updateLCDFlag = 1;
      if (cntDisp == 0) {
        cntDisp = 20;
      } else {
        cntDisp--;
      }
    } else if (btnCnt > 0) {
      btnCnt--;
    }

    TMR1L = 0xB5;
    TMR1H = 0xB3; /// reset tajmera
  }

  if ((PIE1.RCIE) && (PIR1.RCIF)) { // UART RECIEVE FROM SLAVE
    unsigned char ch;
    PIR1.RCIF = 0; // Recieve flag na 0
    ch = RCREG;    // prima se bajt preko UART-a

    switch (ByteID) {
    case BYTE_ID_IDLE:
      break;
    case BYTE_ID_CMD_BYTE:
      if ((ch & CMD_TYPE_MASK) == STATUS_CODE) {
        if ((ch & CMD_ID_MASK) == SLAVE_ID) {
          Comm[SLAVE_ID] = 1;
          ByteID = BYTE_ID_STATUS_BYTE;
        } else {
          ByteID = BYTE_ID_IDLE;
        }
      } else {
        ByteID = BYTE_ID_IDLE;
      }
      break;
    case BYTE_ID_STATUS_BYTE:
      Status1[SLAVE_ID] = ch; // SWAM0000
      ByteID = BYTE_ID_IDLE;
      break;
    default:
      ByteID = BYTE_ID_IDLE;
      break;
    }
  }
}
//=========LCD============================
void lcdDisplayUchar(unsigned char row, unsigned char col,
                     unsigned char value) {
  unsigned char ones;
  unsigned char tens;
  tens = 0x00;
  ones = value;
  while (ones > 9) {
    ones = ones - 10;
    tens++;
  }
  Lcd_Chr(row, col, tens + '0');
  Lcd_Chr(row, col + 1, ones + '0');
}
void lcdDisplayBit(unsigned char mask) {
  unsigned char i;
  for (i = 0; i <= 16; i++) {
    if ((Status1[i] & mask) == mask) {
      Lcd_Chr(2, 16 - i, '1');
    } else {
      Lcd_Chr(2, 16 - i, '0');
    }
  }
}
void lcdDisplayProgram(struct Mode Program, unsigned char ID) {
  // Lcd_Cmd(_LCD_CLEAR);
  Lcd_Out(1, 1, "Prog:");
  lcdDisplayUchar(1, 6, ID);
  Lcd_Out(1, 9, "    ");
  Lcd_Out(1, 13, "Totl"); // prvi red
  //=====drugi red=====
  lcdDisplayUchar(2, 1, Program.startHour);
  Lcd_Chr(2, 3, ':');
  lcdDisplayUchar(2, 4, Program.startMin);
  Lcd_Out(2, 6, "  ");
  Lcd_Chr(2, 8, '/');
  lcdDisplayUchar(2, 9, Program.durationsH);
  lcdDisplayUchar(2, 11, Program.durationsL);
  Lcd_Out(2, 13, "   ");
}
void updateLCD() {
  if (cntDisp <= 16) {
    lcdDisplayProgram(Program[cntDisp], cntDisp);
  } else if (cntDisp == 17) { // System
    Lcd_Out(1, 1, "Operation       ");
    lcdDisplayBit(STATUS_SYSTEM_BIT);
  } else if (cntDisp == 18) { // Watering
    Lcd_Out(1, 1, "Watering        ");
    lcdDisplayBit(STATUS_WATER_BIT);
  } else if (cntDisp == 19) { // Alarm
    Lcd_Out(1, 1, "Alarm           ");
    lcdDisplayBit(STATUS_ALARM_BIT);
  } else if (cntDisp == 20) { // Manual
    Lcd_Out(1, 1, "Manual          ");
    lcdDisplayBit(STATUS_MANUAL_BIT);
  }
}
//==================MAIN========================
void main(void) {
  init();
  init_variables();

  while (1) {
    SPI_Ethernet_doPacket();
    if (Flag1 == 0x01) { // 125ms
      Flag1 = 0x00;
      SLAVE_ID++; // sledeca basta
      if (FlagPoll) {
        FlagPoll = 0x00;
        DR = 1;
        transmit(STATUS_CODE | SLAVE_ID); // pitamo za status slejva
        DR = 0;
        ByteID = BYTE_ID_CMD_BYTE; // ocekujemo cmd_byte
      }
      if (SLAVE_ID == 0x10) { // svi slejovi pollovani
        SLAVE_ID = 0x00;
        PORTA.F4 = 1;
      }
      if (Garden[SLAVE_ID].gardenSend == 0x01) {
        DR = 1;
        transmit(MODE_CODE | SLAVE_ID); // prvi komandni bajt
        //// BrojBaste.BrojPrograma.Start 1Byte
        transmit(Program[Garden[SLAVE_ID].modeID].startHour);
        transmit(Program[Garden[SLAVE_ID].modeID].startMin);
        transmit(Program[Garden[SLAVE_ID].modeID].durationsH);
        transmit(Program[Garden[SLAVE_ID].modeID].durationsL);
        DR = 0;
        Garden[SLAVE_ID].gardenSend = 0x00;
        ByteID = BYTE_ID_CMD_BYTE;
      }
    }
    PORTA.F4 = 0;
    // saljemo RTC signal svim bastama, da bi smo izbegli kasnjenja
    if (FlagRTC == 0x01) {
      DR = 1;
      transmit(RTC_BROADCAST); // 0x1F
      // transmit(RTC_CODE|SLAVE_ID);
      transmit(hours);
      transmit(minutes);
      transmit(seconds);
      DR = 0;
      FlagRTC = 0x00;
      ByteID = BYTE_ID_CMD_BYTE;
    }
    if (updateLCDFlag == 1) {
      updateLCDFlag = 0;
      updateLCD();
    }
    // while(1)
  }
}
