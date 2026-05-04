#line 1 "C:/Users/Student 1/Documents/PES/Archive/Master/Master.c"
#line 1 "c:/users/student 1/documents/pes/archive/master/../commons/config.h"
#line 7 "C:/Users/Student 1/Documents/PES/Archive/Master/Master.c"
typedef struct {
 unsigned canCloseTCP : 1;
 unsigned isBroadcast : 1;
} TEthPktFlags;

const unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: ";
const unsigned char httpMimeTypeHTML[] = "text/html\n\n";
const unsigned char httpMimeTypeScript[] = "text/plain\n\n";
 unsigned char httpMethod[] = "GET /";

sfr sbit SPI_Ethernet_Rst at RA1_bit;
sfr sbit SPI_Ethernet_CS at RA0_bit;
sfr sbit SPI_Ethernet_Rst_Direction at TRISA1_bit;
sfr sbit SPI_Ethernet_CS_Direction at TRISA0_bit;



 unsigned char myMacAddr[6] =  {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f} ;
 unsigned char myIpAddr[4] =  {10, 99, 12, 1} ;
unsigned char getRequest[20];
unsigned char dyna[31];
unsigned long httpCounter = 0;

unsigned char i, brojac, SLAVE_ID, OBB, ch, Flag1, Flag2, Flag3;
unsigned char seconds, minutes, hours;
unsigned char buffer[150];
unsigned char no_ch;


unsigned char Comm[16];
unsigned char Mode[16];
unsigned char Hour[16];
unsigned char Min[16];
unsigned char Sec[16];
unsigned char Status1[16];



unsigned char TargetMode = 0x00;
unsigned char ModeProgram = 0x00;
unsigned char ModeStartHour = 0x00;
unsigned char ModeStartMin = 0x00;
unsigned char ModeStartSecH = 0x00;
unsigned char ModeStartSecL = 0x00;
bit flagMode;

unsigned char TargetGarden = 0x00;
unsigned char TargetGardenProgram = 0x00;
bit flagGarden;

unsigned char TargetControl =0x00;
unsigned char ControlByte = 0x00;
bit flagControl;


sbit LCD_RS at RC0_bit;
sbit LCD_RW at RC1_bit;
sbit LCD_EN at RC2_bit;

sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;

sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_RW_Direction at TRISC1_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;

void init_variables() {
 no_ch = 0x00;
 OBB = 0x00;
 Flag1 = 0x00;
 Flag2 = 0x00;
 Flag3 = 0x00;

 SLAVE_ID = 0x0F;
 for (i = 0; i < 16; i++) {
 Mode[i] = 0x00;
 Comm[i] = 0x00;
 Hour[i] = 0x00;
 Min[i] = 0x00;
 Sec[i] = 0x00;
 }
}

void init() {

 PIR1 = 0b00000000;
 PIE1 = 0b00100001;



 T1CON = 0b10110000;
 T1CON.TMR1ON = 1;
#line 110 "C:/Users/Student 1/Documents/PES/Archive/Master/Master.c"
 TMR1L = 0xB5;
 TMR1H = 0xB3;

 INTCON = 0b01000000;
 INTCON.GIE = 1;


 TRISA = 0x00;


 TRISB = 0x0F;
 TRISC = 0xD0;

 PORTA = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;

 ADCON0 = 0x00;
 ADCON1 = 0x0F;


 UART1_Init( 19200 );


 TXSTA.TXEN = 1;
 RCSTA.SPEN = 1;
 RCSTA.CREN = 1;
 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,
 _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 SPI_Ethernet_Init(myMacAddr, myIpAddr,  1 );



}


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
 no_ch = 0x00;


 for (i = 0; i < 16; i++) {
 if (Comm[i] == 1) {
 appendBuffer("Basta: ");
 ByteToStr(i, txt);
 appendBuffer(txt);
 appendBuffer(" ");
 StatusByte = Status1[i];
 if (!(StatusByte &  0x80 )) {
 appendBuffer("OFF\n\n");
 } else if (StatusByte &  0x40 ) {
 if (StatusByte &  0x10 ) {
 appendBuffer("Watering(Manual_Mode)\n\n");
 } else {
 appendBuffer("Watering(Automatic_Mode)\n\n");
 }
 } else if (StatusByte &  0x20 ) {
 appendBuffer("ALARM ON\n\n");
 } else {
 appendBuffer("IDLE\n\n");
 }
 }
 }
 buffer[no_ch] = 0x00;
 no_ch++;
}
unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags){
 return 0;}
unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost,
 unsigned int remotePort,
 unsigned int localPort,
 unsigned int reqLength, char *canCloseTCP) {
 unsigned int len = 0;
 unsigned int i;

 if (localPort != 80) {
 return 0;
 }
 PORTA.F4 = 1;
 for (i = 0; i < 15; i++) {
 getRequest[i] = SPI_Ethernet_getByte();
 }
 getRequest[i] = 0;

 if (memcmp(getRequest, httpMethod, 5)) {
 return 0;
 }
 if (getRequest[5] == 'r') {

 Flag2 = 0x01;
 hours = getRequest[6];
 minutes = getRequest[7];
 seconds = getRequest[8];
 } else if (getRequest[5] == 'b') {
 flagGarden = 1;
 TargetGarden = getRequest[6];
 TargetGardenProgram = getRequest[7];
 } else if (getRequest[5] == 'p') {
 flagMode = 1;
 TargetMode = getRequest[6];
 ModeProgram = getRequest[7];
 ModeStartHour = getRequest[8];
 ModeStartMin = getRequest[9];
 ModeStartSecH = getRequest[10];
 ModeStartSecL = getRequest[11];
 } else if (getRequest[5] == 'c') {
 flagControl = 1;
 TargetControl = getRequest[6];
 ControlByte = getRequest[7];
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
 return len;
}

void transmit(unsigned char DATA8b) {
 TXREG = DATA8b;
 while (!TXSTA.TRMT)
 ;
}

void interrupt() {
 if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1)) {

 PIR1.TMR1IF = 0;
 if (brojac == 0x04) {
 brojac = 0x00;
 Flag1 = 0x01;
 } else {
 brojac++;
 }
 TMR1L = 0xB5;
 TMR1H = 0xB3;
 }

 if ((PIE1.RCIE) && (PIR1.RCIF)) {
 unsigned char ch;
 PIR1.RCIF = 0;
 ch = RCREG;

 switch (OBB) {
 case  0x00 :
 break;
 case  0x02 :
 if ((ch &  0xE0  ==  0x20 )) {
 if ((ch &  0x0F ) == SLAVE_ID) {
 Comm[SLAVE_ID] == 1;
 OBB =  0x01 ;
 } else {
 OBB =  0x00 ;
 }
 } else {
 OBB =  0x00 ;
 }
 break;
 case  0x01 :
 Status1[SLAVE_ID] = ch;
 OBB =  0x00 ;
 break;
 default:
 OBB =  0x00 ;
 break;
 }
 }
 }


 void main(void) {



 init();
 init_variables();

 while (1) {
 SPI_Ethernet_doPacket();
 if (FLag1 == 0x01) {
 Flag1 = 0x00;
 SLAVE_ID++;
 if (SLAVE_ID == 0x10) {
 SLAVE_ID = 0x00;
 PORTA.F4 = 1;
 if (Flag3 == 0x01) {
 Flag3 = 0x00;
 Flag2 = 0x00;
 } else if (Flag2 == 0x01) {
 Flag3 = 0x01;
 }
 }
 else {
 PORTA.F4 = 0;
 }





 if ((flagControl == 1) && (TargetControl == SLAVE_ID)) {
  PORTA.F5  = 1;
 transmit( 0xC0  | SLAVE_ID);
 transmit(ControlByte);
  PORTA.F5  = 0;
 flagControl = 0;
 OBB =  0x02 ;
 } else if (Flag3 == 0x01) {
  PORTA.F5  = 1;
 transmit( 0x60  | SLAVE_ID);
 transmit(hours);
 transmit(minutes);
 transmit(seconds);
  PORTA.F5  = 0;
 Flag3 = 0x00;
 OBB =  0x02 ;
 } else if ((flagMode == 1) && TargetMode == SLAVE_ID) {
  PORTA.F5  = 1;
 transmit( 0xA0  | SLAVE_ID);
 transmit(ModeProgram);
 transmit(ModeStartHour);
 transmit(ModeStartMin);
 transmit(ModeStartSecH);
 transmit(ModeStartSecL);
  PORTA.F5  = 0;
 OBB =  0x02 ;
 flagMode = 0;
 } else if ((flagGarden == 1) && TargetGarden == SLAVE_ID) {
  PORTA.F5  = 1;
 transmit( 0x80  | SLAVE_ID);
 transmit(TargetGardenProgram);
  PORTA.F5  = 0;
 OBB =  0x02 ;
 flagGarden = 0;
 } else {
  PORTA.F5  = 1;
 transmit( 0x20  | SLAVE_ID);
 OBB =  0x02 ;
 }
 }
 }
 }
