#line 1 "I:/Predmeti/ProjektovanjeElektonskihSistema/Studenti/08_MarjanDjordjevic/Slejv/Program/Slave.c"
#line 15 "I:/Predmeti/ProjektovanjeElektonskihSistema/Studenti/08_MarjanDjordjevic/Slejv/Program/Slave.c"
unsigned char RAMP_ID = 0x00;
bit Operation;
bit Operation2;

bit RampOpen;
bit RampOpen2;

bit Event;
bit EXTRampOpen;
bit Error;
bit Sensor;

unsigned char Category = 0x00;


unsigned char BytesToReceive = 0x00;

unsigned char ch = 0x00;

unsigned char Command = 0x00;

unsigned char CommandModified = 0x00;

bit CallFlag;

bit RTCSetupFlag;

bit UpdateLCDFlag;

bit TMP_Taster2;
bit TMP_Taster1;

bit TMP_Sensor2;
bit TMP_Sensor1;

bit TMP_Error2;
bit TMP_Error1;

bit TMP_EXTRampOpen2;
bit TMP_EXTRampOpen1;

unsigned char Sec_X1 = 0x00;
unsigned char Sec_X10 = 0x00;
unsigned char Min_X1 = 0x00;
unsigned char Min_X10 = 0x00;
unsigned char Hour_X1 = 0x00;
unsigned char Hour_X10 = 0x00;

unsigned char Tmp_Sec_X1 = 0x00;
unsigned char Tmp_Sec_X10 = 0x00;
unsigned char Tmp_Min_X1 = 0x00;
unsigned char Tmp_Min_X10 = 0x00;
unsigned char Tmp_Hour_X1 = 0x00;
unsigned char Tmp_Hour_X10 = 0x00;

unsigned char Counter = 0x00;
unsigned char Counter2 = 0x00;

unsigned char Seconds = 0x00;
unsigned char Minutes = 0x00;
unsigned char Hours = 0x00;

unsigned char X1;
unsigned char X10;

void DecodeTime();
void ProcessInputs();
void IncrementTime();
void init();
void UpdateLCD();


sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC2_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;


sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

void init_variables()
{

 RAMP_ID = 0x00;
 Category = 0x00;
 Operation = 0;
 Event = 0;
 RampOpen = 0;
 EXTRampOpen = 0;
 Error = 0;
 Sensor = 0;
 Operation2 = 0;
 RampOpen2 = 0;

 TMP_Taster2 = 0;
 TMP_Taster1 = 0;

 TMP_Sensor2 = 0;
 TMP_Sensor1 = 0;

 TMP_Error2 = 0;
 TMP_Error1 = 0;

 TMP_EXTRampOpen2 = 0;
 TMP_EXTRampOpen1 = 0;
 BytesToReceive = 0x00;
 ch = 0x00;
 Command = 0x00;
 CommandModified = 0x00;
 Counter = 0x00;
 Counter2 = 0x00;
 CallFlag = 0;
 RTCSetupFlag = 0;
 UpdateLCDFlag = 0;
 Sec_X1 = 0x00;
 Sec_X10 = 0x00;
 Min_X1 = 0x00;
 Min_X10 = 0x00;
 Hour_X1 = 0x00;
 Hour_X10 = 0x00;
 Tmp_Sec_X1 = 0x00;
 Tmp_Sec_X10 = 0x00;
 Tmp_Min_X1 = 0x00;
 Tmp_Min_X10 = 0x00;
 Tmp_Hour_X1 = 0x00;
 Tmp_Hour_X10 = 0x00;

 Seconds = 0x00;
 Minutes = 0x00;
 Hours = 0x00;
}

void transmit(unsigned char DATA8b)
{

 TXREG = DATA8b;
 while (!TXSTA.TRMT)
 ;
}

void DecodeTime()
{
 Seconds = (Sec_X10 << 4) + Sec_X1;
 Minutes = (Min_X10 << 4) + Min_X1;
 Hours = (Hour_X10 << 4) + Hour_X1;
}

void ProcessInputs()
{
 TMP_Taster2 = TMP_Taster1;
 if ( PORTB.F0  == 1)
 TMP_Taster1 = 1;
 else
 TMP_Taster1 = 0;
 if ((TMP_Taster2 == 1) && (TMP_Taster1 == 1))
 {
 Event = 1;
  PORTA.F4  = 1;
 }

 TMP_Sensor2 = TMP_Sensor1;
 if ( PORTB.F1  == 1)
 TMP_Sensor1 = 1;
 else
 TMP_Sensor1 = 0;
 if ((TMP_Sensor2 == 1) && (TMP_Sensor1 == 1))
 RampOpen = 0;

 TMP_Error2 = TMP_Error1;
 if ( PORTB.F4  == 1)
 TMP_Error1 = 1;
 else
 TMP_Error1 = 0;
 if ((TMP_Error2 == 1) && (TMP_Error1 == 1))
 Error = 1;
 else if ((TMP_Error2 == 0) && (TMP_Error1 == 0))
 Error = 0;

 TMP_EXTRampOpen2 = TMP_EXTRampOpen1;
 if ( PORTB.F5  == 1)
 TMP_EXTRampOpen1 = 1;
 else
 TMP_EXTRampOpen1 = 0;

 if ((TMP_EXTRampOpen2 == 1) && (TMP_EXTRampOpen1 == 1))
 EXTRampOpen = 1;
 else if ((TMP_EXTRampOpen2 == 0) && (TMP_EXTRampOpen1 == 0))
 EXTRampOpen = 0;

 if (PORTD.F2 == 1)
 if (PORTD.F3 == 1)
 Category = 0x03;
 else
 Category = 0x02;
 else if (PORTD.F3 == 1)
 Category = 0x01;
 else
 Category = 0x00;
}

void main()
{
 init();
 init_variables();
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF);
 UpdateLCD();

 while (1)
 {

 RampOpen2 = RampOpen | EXTRampOpen;
 if (Error == 1)
 Operation2 = 0;
 else
 Operation2 = Operation;
  PORTA.F2  = Operation2;
  PORTA.F3  = RampOpen2;
 if (UpdateLCDFlag == 1)
 {
 UpdateLCDFlag = 0;
 UpdateLCD();
 }

 if ((BytesToReceive > 0) && (Counter2 == 0))
 {
 BytesToReceive = 0;
 }
 if (CallFlag == 1)
 {
 if ((Command & 0x10) == 0x10)
 Operation = 1;
 else
 Operation = 0;
 if (Error == 1)
 {

  PORTC.F5  = 1;
 if (Operation == 0x01)
 CommandModified = 0b00010000 | RAMP_ID;
 else
 CommandModified = 0b00000000 | RAMP_ID;
 transmit(CommandModified);
  PORTC.F5  = 0;
 }
 else if (Event == 0)
 {


  PORTC.F5  = 1;
 if (Operation == 1)
 CommandModified = 0b00110000 | RAMP_ID;
 else
 CommandModified = 0b00100000 | RAMP_ID;
 transmit(CommandModified);
  PORTC.F5  = 0;
 }
 else
 {




 if (Operation == 1)
 {
  PORTC.F5  = 1;
 CommandModified = 0b01010000 | RAMP_ID;
 transmit(CommandModified);
 transmit(Seconds);
 transmit(Minutes);
 transmit(Hours);
 transmit(Category);
  PORTC.F5  = 0;
 Event = 0;
  PORTA.F4  = 0;
 RampOpen = 1;
 }
 }
 CallFlag = 0;
 }
 if (RTCSetupFlag == 1)
 {
 Sec_X1 = Tmp_Sec_X1;
 Sec_X10 = Tmp_Sec_X10;
 Min_X1 = Tmp_Min_X1;
 Min_X10 = Tmp_Min_X10;
 Hour_X1 = Tmp_Hour_X1;
 Hour_X10 = Tmp_Hour_X10;
  PORTC.F5  = 1;
 if (Operation == 1)
 CommandModified = 0b01110000 | RAMP_ID;
 else
 CommandModified = 0b01100000 | RAMP_ID;
 transmit(CommandModified);
 RTCSetupFlag = 0;
  PORTC.F5  = 0;
 }
 }
}

void IncrementTime()
{
 if (Sec_X1 >= 9)
 {
 Sec_X1 = 0;
 if (Sec_X10 >= 5)
 {
 Sec_X10 = 0;

 if (Min_X1 >= 9)
 {
 Min_X1 = 0;
 if (Min_X10 >= 5)
 {
 Min_X10 = 0;

 if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3)))
 {
 Hour_X1 = 0;
 if (Hour_X10 == 2)
 {
 Hour_X10 = 0;
 }
 else
 Hour_X10++;
 }
 else
 Hour_X1++;

 }
 else
 Min_X10++;
 }
 else
 Min_X1++;

 }
 else
 Sec_X10++;
 }
 else
 Sec_X1++;
}

void ConvertTime(unsigned char ch)
{
 X1 = ch;
 X10 = 0x00;
 while (X1 > 9)
 {
 X1 = X1 - 10;
 X10++;
 }
}

void interrupt()
{
 if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
 {

 PIR1.TMR1IF = 0;

 if (Counter == 9)
 {
 Counter = 0;
 IncrementTime();
 DecodeTime();
 UpdateLCDFlag = 1;
 }
 else
 Counter++;

 if (Counter2 > 0)
 Counter2--;
 else
 Counter2 = 0;

 ProcessInputs();

 TMR1H = 0x0B;
 TMR1L = 0xDC;
 }

 if ((PIE1.RCIE) && (PIR1.RCIF))
 {
 ch = RCREG;
 if (BytesToReceive == 0x00)
 {
 if ((ch & 0x0F) == RAMP_ID)
 {

 Command = ch;
 if ((ch & 0xE0) == 0x20)
 {

 BytesToReceive = 0x00;
 CallFlag = 1;
 }
 else if ((ch & 0xE0) == 0x60)
 {


 BytesToReceive = 0x03;
 Counter2 = 3;


 }
 }
 }
 else if (BytesToReceive == 0x03)
 {
 BytesToReceive = 0x02;
 ch = ch - 0x30;
 if (ch > 59)
 ch = 59;
 ConvertTime(ch);
 Tmp_Sec_X1 = X1;
 Tmp_Sec_X10 = X10;
 }
 else if (BytesToReceive == 0x02)
 {
 BytesToReceive = 0x01;
 ch = ch - 0x30;
 if (ch > 59)
 ch = 59;
 ConvertTime(ch);
 Tmp_Min_X1 = X1;
 Tmp_Min_X10 = X10;
 }
 else if (BytesToReceive == 0x01)
 {
 BytesToReceive = 0x00;
 ch = ch - 0x30;
 if (ch > 23)
 ch = 23;
 ConvertTime(ch);
 Tmp_Hour_X1 = X1;
 Tmp_Hour_X10 = X10;
 RTCSetupFlag = 1;
 }
 }
}

void UpdateLCD()
{
 Lcd_Out(1, 1, "Time:");
 Lcd_Chr(1, 6, (Hour_X10 + 0x30));
 Lcd_Chr(1, 7, (Hour_X1 + 0x30));
 Lcd_Chr(1, 8, ':');
 Lcd_Chr(1, 9, (Min_X10 + 0x30));
 Lcd_Chr(1, 10, (Min_X1 + 0x30));
 Lcd_Chr(1, 11, ':');
 Lcd_Chr(1, 12, (Sec_X10 + 0x30));
 Lcd_Chr(1, 13, (Sec_X1 + 0x30));
 if (Operation2 == 0x01)
 Lcd_Out(2, 1, "Operating");
 else if (Error == 0x01)
 Lcd_Out(2, 1, "Error    ");
 else
 Lcd_Out(2, 1, "         ");
 if (RampOpen2 == 0x01)
 Lcd_Out(2, 11, "Opened");
 else
 Lcd_Out(2, 11, "Closed");
}
void init()
{


 TRISA = 0x03;

 TRISB = 0x3F;
 TRISC = 0xC0;

 TRISD = 0x0F;

 PORTA = 0x00;
 PORTB = 0x00;
 PORTC = 0x00;

 ADCON0 = 0x00;
 ADCON1 = 0b00000110;

 INTCON = 0b11000000;
 PIE1 = 0b00000000;

 T1CON = 0b00110000;

 TMR1H = 0x0B;
 TMR1L = 0xDC;
 T1CON.TMR1ON = 1;







 PIR1.TMR1IF = 0;
 PIE1.TMR1IE = 1;

 Uart1_Init(19200);


 TXSTA.TXEN = 1;
 RCSTA.SPEN = 1;
 RCSTA.CREN = 1;
 PIE1.RCIE = 1;

 INTCON.GIE = 1;

}
