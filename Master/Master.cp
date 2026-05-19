#line 1 "C:/Users/Student 1/Documents/PES/Archive/Master/Master.c"
#line 1 "c:/users/student 1/documents/pes/archive/master/../commons/config.h"
#line 9 "C:/Users/Student 1/Documents/PES/Archive/Master/Master.c"
typedef struct {
 unsigned canCloseTCP : 1;
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

unsigned char i, brojac, SLAVE_ID, ByteID, ch, Flag1, FlagRTC;
unsigned char seconds, minutes, hours;
unsigned char buffer[150];
unsigned char no_ch;

unsigned char Cmd[16];
unsigned char Comm[16];
unsigned char Hour[16];
unsigned char Min[16];
unsigned char Sec[16];
unsigned char Status1[16];
unsigned char updateLCDFlag;
unsigned char btnCnt;
unsigned char cntDisp;
unsigned char showProgram;
unsigned char showStatus;
unsigned char showCnt;
unsigned char incCnt;

struct Mode Program[16];

struct Garden Garden[16];

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
 ByteID = 0x00;
 Flag1 = 0x00;
 FlagRTC = 0x00;
 updateLCDFlag = 0x00;
 btnCnt = 0x00;
 cntDisp=0x00;

 SLAVE_ID = 0x0F;
 for (i = 0; i < 16; i++) {
 Comm[i] = 0x00;
 Hour[i] = 0x00;
 Min[i] = 0x00;
 Sec[i] = 0x00;
 Status1[i]=0x00;
 Program[i].startHour = 0x00;
 Program[i].startMin = 0x00;
 Program[i].durationsH = 0x00;
 Program[i].durationsL = 0x00;
 Garden[i].modeID = 0x00;
 Garden[i].gardenSend = 0x00;

 }
}

void init() {

 PIR1 = 0b00000000;
 PIE1 = 0b00100001;



 T1CON = 0b10110000;
 T1CON.TMR1ON = 1;
#line 124 "C:/Users/Student 1/Documents/PES/Archive/Master/Master.c"
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
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

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
 appendBuffer("Basta:");
 ByteToStr(i, txt);
 appendBuffer(txt);
 appendBuffer(" ");

 StatusByte = Status1[i];


 if (!(StatusByte &  0x80 )) {
 appendBuffer("OFF\n\n");
 } else if (StatusByte &  0x40 ) {
 if (StatusByte &  0x10 ) {
 appendBuffer("Watering(Manual_Mode)\n\n");
 if (StatusByte &  0x20 ) {
 appendBuffer("ALARM ON\n\n");
 }
 } else {
 appendBuffer("Watering(Automatic_Mode)\n\n");
 if (StatusByte &  0x20 ) {
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
 no_ch++;
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
 unsigned int len = 0;
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
 if (getRequest[5] == 'r') {

 FlagRTC = 0x01;


 hours = (getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F);
 minutes = (getRequest[8] & 0x0F) * 10 + (getRequest[9] & 0x0F);
 seconds = (getRequest[10] & 0x0F) * 10 + (getRequest[11] & 0x0F);
 } else if (getRequest[5] == 'b') {
 Garden[(getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F)].modeID =
 (getRequest[8] & 0x0F) * 10 + (getRequest[9] & 0x0F);
 Garden[(getRequest[6] & 0x0F) * 10 + (getRequest[7] & 0x0F)].gardenSend =
 0x01;
 } else if (getRequest[5] == 'p') {




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

 if (( PORTB.F0  == 1) && btnCnt == 0) {
 btnCnt = 20;
 updateLCDFlag = 1;
 if (cntDisp >= 20) {
 cntDisp = 0;
 } else {
 cntDisp++;
 }
 } else if(btnCnt>0) {
 btnCnt--;
 }
 if (( PORTB.F1  == 1) && btnCnt == 0) {
 btnCnt = 20;
 updateLCDFlag = 1;
 if (cntDisp == 0) {
 cntDisp = 20;
 } else {
 cntDisp--;
 }
 } else if(btnCnt>0) {
 btnCnt--;
 }

 TMR1L = 0xB5;
 TMR1H = 0xB3;
 }

 if ((PIE1.RCIE) && (PIR1.RCIF)) {
 unsigned char ch;
 PIR1.RCIF = 0;
 ch = RCREG;

 switch (ByteID) {
 case  0x00 :
 break;
 case  0x02 :
 if ((ch &  0xE0 ) ==  0x20 ) {
 if ((ch &  0x0F ) == SLAVE_ID) {
 Comm[SLAVE_ID] = 1;
 ByteID =  0x01 ;
 } else {
 ByteID =  0x00 ;
 }
 } else {
 ByteID =  0x00 ;
 }
 break;
 case  0x01 :
 Status1[SLAVE_ID] = ch;
 ByteID =  0x00 ;
 break;
 default:
 ByteID =  0x00 ;
 break;
 }
 }
}

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
 }else{
 Lcd_Chr(2, 16 - i, '0');
 }
 }
}
void lcdDisplayProgram(struct Mode Program, unsigned char ID) {

 Lcd_Out(1, 1, "Prog: ");
 lcdDisplayUchar(1, 6, ID);
 Lcd_Out(1, 9, "   ");
 Lcd_Out(1, 12, "Totl");
 lcdDisplayUchar(2, 1, Program.startHour);
 Lcd_Chr(2, 3, ':');
 lcdDisplayUchar(2, 4, Program.startMin);
 Lcd_Out(2, 6, "  ");
 Lcd_Chr(2, 8, '/');
 lcdDisplayUchar(2, 10, Program.durationsH);
 lcdDisplayUchar(2, 13, Program.durationsL);
}
void updateLCD() {
 if (cntDisp <= 16) {
 lcdDisplayProgram(Program[cntDisp], cntDisp);
 } else if (cntDisp == 17) {
 Lcd_Out(1, 1, "Operation");
 Lcd_Out(1, 10, "      ");
 lcdDisplayBit( 0x80 );
 } else if (cntDisp == 18) {
 Lcd_Out(1, 1, "Watering");
 Lcd_Out(1, 9, "       ");
 lcdDisplayBit( 0x40 );
 } else if (cntDisp == 19) {
 Lcd_Out(1, 1, "Alarm");
 Lcd_Out(1, 6, "         ");
 lcdDisplayBit( 0x20 );
 } else if (cntDisp == 20) {
 Lcd_Out(1, 1, "Manual");
 Lcd_Out(1, 7, "         ");
 lcdDisplayBit( 0x10 );
 }
}

void main(void) {
 init();
 init_variables();

 while (1) {
 SPI_Ethernet_doPacket();


 if (Flag1 == 0x01) {
 Flag1 = 0x00;
 SLAVE_ID++;
 if (updateLCDFlag == 1) {
 updateLCDFlag = 0;

 updateLCD();
 }
  PORTA.F5  = 1;
 transmit( 0x20  | SLAVE_ID);
  PORTA.F5  = 0;
 ByteID =  0x02 ;
 if (SLAVE_ID == 0x10) {
 SLAVE_ID = 0x00;
 PORTA.F4 = 1;

 }
 if (Garden[SLAVE_ID].gardenSend == 0x01) {
  PORTA.F5  = 1;
 transmit( 0xA0  | SLAVE_ID);

 transmit(Program[Garden[SLAVE_ID].modeID].startHour);
 transmit(Program[Garden[SLAVE_ID].modeID].startMin);
 transmit(Program[Garden[SLAVE_ID].modeID].durationsH);
 transmit(Program[Garden[SLAVE_ID].modeID].durationsL);
  PORTA.F5  = 0;
 Garden[SLAVE_ID].gardenSend = 0x00;
 ByteID =  0x02 ;
 }
 }
 PORTA.F4 = 0;

 if (FlagRTC == 0x01) {
  PORTA.F5  = 1;
 transmit( 0x7F );

 transmit(hours);
 transmit(minutes);
 transmit(seconds);
  PORTA.F5  = 0;
 FlagRTC = 0x00;
 ByteID =  0x02 ;
 }


 }
}
