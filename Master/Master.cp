#line 1 "I:/Predmeti/ProjektovanjeElektonskihSistema/Studenti/08_MarjanDjordjevic/Program/Program/Master.c"




typedef struct
{
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

unsigned char myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f};

unsigned char myIpAddr[4] = {10, 99, 12, 1};

unsigned char getRequest[15];
unsigned char dyna[31];
unsigned long httpCounter = 0;

unsigned char i, brojac, RAMP_ID, Flag1, Flag2, Flag3, ch, OBB;
unsigned char niz[150];
unsigned char br_ch;
unsigned char seconds, minutes, hours;


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

unsigned char pom_ch, pom_des, pom_jed;
unsigned char pom_nula = 0x30;


unsigned char Operation[16];
unsigned char Comm[16];
unsigned char Cmd[16];
unsigned char Cat[16];
unsigned char Hour[16];
unsigned char Min[16];
unsigned char Sec[16];

unsigned int putConstString(const char *s)
{
 unsigned int ctr = 0;
 while (*s)
 {
 SPI_Ethernet_putByte(*s++);
 ctr++;
 }
 return (ctr);
}

unsigned int putString(char *s)
{
 unsigned int ctr = 0;
 while (*s)
 {
 SPI_Ethernet_putByte(*s++);
 ctr++;
 }
 return (ctr);
}

void dodajUNiz(char *p_ch)
{
 while ((*p_ch) != 0x00)
 {
 niz[br_ch] = *p_ch;
 br_ch++;
 p_ch++;
 }
}
void formirajNiz()
{

 unsigned char i = 0;
 char txt[4];
 br_ch = 0;

 for (i = 0; i < 16; i++)
 {
 if (Comm[i] == 1)
 {
 dodajUNiz("Ramp:");
 ByteToStr(i, txt);
 dodajUNiz(txt);
 switch (Cmd[i])
 {

 case 0:
 dodajUNiz(" IDLE \n\n");
 break;
 case 1:
 dodajUNiz(" VEHICLE ");
 break;
 case 2:
 dodajUNiz(" TIME SET \n\n");
 break;
 case 3:
 dodajUNiz(" NO CARDS \n\n");
 break;
 default:
 break;
 }
 if (Cmd[i] == 1)
 {
 pom_nula = 0x30;
 pom_ch = Hour[i];
 pom_des = (pom_ch >> 4) + pom_nula;
 pom_jed = (pom_ch & 0x0F) + pom_nula;
 niz[br_ch] = pom_des;
 br_ch++;
 niz[br_ch] = pom_jed;
 br_ch++;
 niz[br_ch] = ':';
 br_ch++;

 pom_ch = Min[i];
 pom_des = (pom_ch >> 4) + pom_nula;
 pom_jed = (pom_ch & 0x0F) + pom_nula;
 niz[br_ch] = pom_des;
 br_ch++;
 niz[br_ch] = pom_jed;
 br_ch++;
 niz[br_ch] = ':';
 br_ch++;

 pom_ch = Sec[i];
 pom_des = (pom_ch >> 4) + pom_nula;
 pom_jed = (pom_ch & 0x0F) + pom_nula;
 niz[br_ch] = pom_des;
 br_ch++;
 niz[br_ch] = pom_jed;
 br_ch++;
 niz[br_ch] = ' ';
 br_ch++;

 pom_ch = Cat[i];
 pom_des = 'K';
 pom_jed = (pom_ch & 0x0F) + pom_nula;
 niz[br_ch] = pom_des;
 br_ch++;
 niz[br_ch] = pom_jed;
 br_ch++;
 niz[br_ch] = '\n';
 br_ch++;
 niz[br_ch] = '\n';
 br_ch++;
 }
 }
 }
 niz[br_ch] = 0x00;
 br_ch++;
}

void interrupt()
{

 if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1))
 {

 PIE1.TMR1IE = 1;
 PIR1.TMR1IF = 0;
 if (brojac == 0x04)
 {
 brojac = 0x00;
 Flag1 = 0x01;
 }
 else
 {
 brojac++;
 }
 TMR1L = 0xB5;
 TMR1H = 0xB3;
 }

 if ((PIE1.RCIE) && (PIR1.RCIF))
 {
 unsigned char ch;
 PIR1.RCIF = 0;

 ch = RCREG;
 if (OBB != 0x00)
 {
 if (OBB == 0x05)
 {
 Comm[RAMP_ID] = 1;
 if ((ch & 0xE0) == 0x00)
 {
 OBB = 0x00;
 Cmd[RAMP_ID] = 3;
 }
 if ((ch & 0xE0) == 0x20)
 OBB = 0x00;
 if ((ch & 0xE0) == 0x40)
 {
 OBB = 0x04;
 Cmd[RAMP_ID] = 1;
 }
 if ((ch & 0xE0) == 0x60)
 {
 OBB = 0x00;
 Cmd[RAMP_ID] = 2;
 }
 }
 else
 {
 switch (OBB)
 {

 case 4:
 Sec[RAMP_ID] = ch;
 break;
 case 3:
 Min[RAMP_ID] = ch;
 break;
 case 2:
 Hour[RAMP_ID] = ch;
 break;
 case 1:
 Cat[RAMP_ID] = ch;
 break;
 default:
 break;
 }
 OBB--;
 }
 }
 }
}

void UpdateLCD()
{
 int i = 0;
 Lcd_Out(1, 1, "Operation    ");
 for (i = 0; i <= 15; i++)
 {
 if (Operation[i] == 1)
 Lcd_Chr(2, 16 - i, '1');
 else
 Lcd_Chr(2, 16 - i, '0');
 }
}

unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, char *canClose)
{

 unsigned int len = 0;
 unsigned int i;
 if (localPort != 80)
 return (0);
 PORTA.F4 = 1;

 for (i = 0; i < 10; i++)
 getRequest[i] = SPI_Ethernet_getByte();
 getRequest[i] = 0;

 if (memcmp(getRequest, httpMethod, 5))
 return (0);


 if (getRequest[5] == 's')
 {


 if (((getRequest[6] & 0xF0) == 0x30) && ((getRequest[7] & 0xF0) == 0x30) &&
 ((getRequest[8] & 0xF0) == 0x30) && ((getRequest[9] & 0xF0) == 0x30))
 {

 for (i = 0; i < 16; i++)
 Operation[i] = 0x00;

 if ((getRequest[6] & 0x08) == 0x08)
 Operation[15] = 0x01;
 if ((getRequest[6] & 0x04) == 0x04)
 Operation[14] = 0x01;
 if ((getRequest[6] & 0x02) == 0x02)
 Operation[13] = 0x01;
 if ((getRequest[6] & 0x01) == 0x01)
 Operation[12] = 0x01;
 if ((getRequest[7] & 0x08) == 0x08)
 Operation[11] = 0x01;
 if ((getRequest[7] & 0x04) == 0x04)
 Operation[10] = 0x01;
 if ((getRequest[7] & 0x02) == 0x02)
 Operation[9] = 0x01;
 if ((getRequest[7] & 0x01) == 0x01)
 Operation[8] = 0x01;
 if ((getRequest[8] & 0x08) == 0x08)
 Operation[7] = 0x01;
 if ((getRequest[8] & 0x04) == 0x04)
 Operation[6] = 0x01;
 if ((getRequest[8] & 0x02) == 0x02)
 Operation[5] = 0x01;
 if ((getRequest[8] & 0x01) == 0x01)
 Operation[4] = 0x01;
 if ((getRequest[9] & 0x08) == 0x08)
 Operation[3] = 0x01;
 if ((getRequest[9] & 0x04) == 0x04)
 Operation[2] = 0x01;
 if ((getRequest[9] & 0x02) == 0x02)
 Operation[1] = 0x01;
 if ((getRequest[9] & 0x01) == 0x01)
 Operation[0] = 0x01;

 }
 }
 if (getRequest[5] == 'r')
 {

 Flag2 = 0x01;

 seconds = getRequest[6];
 minutes = getRequest[7];
 hours = getRequest[8];
 }
 if (len == 0)
 {
 FormirajNiz();
 len = putConstString(httpHeader);
 len += putConstString(httpMimeTypeHTML);
 len += putString(niz);
 for (i = 0; i < 16; i++)
 {
 Comm[i] = 0x00;
 Cmd[i] = 0x00;
 Cat[i] = 0x00;
 Hour[i] = 0x00;
 Min[i] = 0x00;
 Sec[i] = 0x00;
 }
 }
 return (len);
}

unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort,
 unsigned int reqLength, TEthPktFlags *flags)

{
 return 0;
}
void init_variables()
{
 br_ch = 0x00;
 OBB = 0x00;
 Flag1 = 0x00;
 Flag2 = 0x00;
 Flag3 = 0x00;
 brojac = 0x00;
 RAMP_ID = 0x0F;
 for (i = 0; i < 150; i++)
 niz[i] = 0x00;
 for (i = 0; i < 16; i++)
 {
 Operation[i] = 0x00;
 Comm[i] = 0x00;
 Cmd[i] = 0x00;
 Cat[i] = 0x00;
 Hour[i] = 0x00;
 Min[i] = 0x00;
 Sec[i] = 0x00;
 }
}

void init()
{

 PIR1 = 0b00000000;
 PIE1 = 0b00100001;



 T1CON = 0b10110000;
 T1CON.TMR1ON = 1;





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


 UART1_Init(19200);

 TXSTA.TXEN = 1;
 RCSTA.SPEN = 1;
 RCSTA.CREN = 1;

 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 UpdateLCD();

 SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
 SPI_Ethernet_Init(myMacAddr, myIpAddr,  1 );
}

void transmit(unsigned char DATA8b)
{
 TXREG = DATA8b;
 while (!TXSTA.TRMT)
 ;
}

void main(void)
{

 unsigned char ByteX = 0x00;

 init();
 init_variables();

 while (1)
 {
 SPI_Ethernet_doPacket();
 if (Flag1 == 0x01)
 {
 Flag1 = 0x00;
 RAMP_ID++;
 if (RAMP_ID == 0x10)
 {
 RAMP_ID = 0x00;
 PORTA.F4 = 1;
 if (Flag3 == 0x01)
 {
 Flag3 = 0x00;
 Flag2 = 0x00;
 }


 else if (Flag2 == 0x01)
 Flag3 = 0x01;
 UpdateLCD();
 }
 else
 PORTA.F4 = 0;

 if (Flag3 == 0x00)
 {
  PORTA.F5  = 1;
 if (Operation[RAMP_ID] == 0x01)
 ByteX = 0x30 + RAMP_ID;
 else
 ByteX = 0x20 + RAMP_ID;
 transmit(ByteX);
  PORTA.F5  = 0;
 OBB = 0x05;

 }
 else
 {
  PORTA.F5  = 1;
 ByteX = 0x70 + RAMP_ID;
 transmit(ByteX);
 transmit(seconds);
 transmit(minutes);
 transmit(hours);
  PORTA.F5  = 0;
 OBB = 0x05;
 }
 }
 }
}
