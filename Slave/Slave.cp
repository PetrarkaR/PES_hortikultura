#line 1 "C:/Users/Student 1/Documents/PES/Archive/Slave/Slave.c"
#line 1 "c:/users/student 1/documents/pes/archive/slave/../commons/config.h"
#line 19 "C:/Users/Student 1/Documents/PES/Archive/Slave/Slave.c"
unsigned char GARDEN_ID = 0x00;
unsigned char Tmp_time_left_high = 0x00;
unsigned char Tmp_time_left_low = 0x00;
unsigned char time_left_high = 0x00;
unsigned char time_left_low = 0x00;
unsigned char ProgStartHour = 0x00;
unsigned char ProgStartMin = 0x00;
unsigned int WateringSec = 0;
unsigned char Tmp_ProgStartHour = 0x00;
unsigned char Tmp_ProgStartMin = 0x00;
bit ProgramSetupFlag;


unsigned char ByteID = 0x00;

unsigned char ch = 0x00;

unsigned char Command = 0x00;

unsigned char CommandModified = 0x00;

bit CallFlag;

bit RTCSetupFlag;

bit UpdateLCDFlag;

bit TMP_Taster2;
bit TMP_Taster1;
bit TMP_Reset1;
bit TMP_Reset2;
bit ManualMode;
bit ResetEvent;
bit ManualEvent;
unsigned char program;

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
unsigned char cntManual = 0x00;
unsigned char cntReset = 0x00;

unsigned char Seconds = 0x00;
unsigned char Minutes = 0x00;
unsigned char Hours = 0x00;

unsigned char X1;
unsigned char X10;

unsigned char FlowValue = 0x00;
unsigned char FlowMin = 20;
unsigned char FlowMax = 60;

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

unsigned char ReadADC();

void init_variables()
{

 GARDEN_ID = 0x00;

 TMP_Taster2 = 0;
 TMP_Taster1 = 0;

 TMP_Reset2 = 0;
 TMP_Reset1 = 0;

 ByteID = 0x00;
 ch = 0x00;
 Command = 0x00;
 CommandModified = 0x00;
 Counter = 0x00;
 Counter2 = 0x00;
 cntManual = 0x00;
 cntReset = 0x00;
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


 time_left_high = 0x00;
 time_left_low = 0x00;
 WateringSec = 0;
 ManualMode = 0;
 ManualEvent = 0;
 ResetEvent = 0;
 ProgramSetupFlag = 0;
 ProgStartHour = 0x00;
 ProgStartMin = 0x00;
  PORTA.F2  = 1;
  PORTA.F3  = 0;
  PORTA.F4  = 0;
}

unsigned char ReadADC() {
 ADCON0.GO_DONE = 1;
 while (ADCON0.GO_DONE)
 ;
 return ADRESH;
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

 if (cntManual > 0) cntManual--;
 if ( PORTB.F0  == 0) TMP_Taster1 = 0;
 if ((cntManual == 0) && (TMP_Taster1 == 0) && ( PORTB.F0  == 1))
 {
 TMP_Taster1 = 1;
 cntManual =  10 ;
 if (ManualMode == 1) ManualMode = 0;
 else ManualMode = 1;
 ManualEvent = 1;
 }


 if (cntReset > 0) cntReset--;
 if ( PORTB.F2  == 0) TMP_Reset1 = 0;
 if ((cntReset == 0) && (TMP_Reset1 == 0) && ( PORTB.F2  == 1))
 {
 TMP_Reset1 = 1;
 cntReset =  10 ;
 ResetEvent = 1;
 }
}

unsigned char buildStatusByte()
{
 unsigned char status = 0x00;
 if ( PORTA.F2 ) status |=  0x80 ;
 if ( PORTA.F3 ) status |=  0x40 ;
 if ( PORTA.F4 ) status |=  0x20 ;
 if (ManualMode) status |=  0x10 ;
 return status;
}


unsigned char toBcd(unsigned char val)
{
 unsigned char tens;
 tens = 0;
 while (val > 9) { val -= 10; tens++; }
 return (tens << 4) | val;
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


 if (ResetEvent == 1)
 {
 ResetEvent = 0;
  PORTA.F3  = 0;
  PORTA.F2  = 1;
  PORTA.F4  = 0;
 ManualMode = 0;
 ManualEvent = 0;
 WateringSec = 0;
 }


 if (ManualEvent == 1)
 {
 ManualEvent = 0;
 if (ManualMode == 1)
 {

 WateringSec = 180;
  PORTA.F3  = 1;
  PORTA.F2  = 1;
 }
 else
 {

 WateringSec = 0;
 }
 }

 if (UpdateLCDFlag == 1)
 {
 UpdateLCDFlag = 0;


 if (( PORTA.F3  == 0) &&
 (Seconds == 0x00) &&
 (Hours == ProgStartHour) &&
 (Minutes == ProgStartMin))
 {
 WateringSec = ((unsigned int)time_left_high << 8) | time_left_low;
  PORTA.F3  = 1;
  PORTA.F2  = 1;
 }


 if ( PORTA.F3  == 1)
 {
 if (WateringSec > 0) WateringSec--;
 if (WateringSec == 0)
 {
  PORTA.F3  = 0;
  PORTA.F2  = 1;
 ManualMode = 0;
 }
 }

 FlowValue = ReadADC();
 if ( PORTA.F3  == 1)
 {
 if ((FlowValue < FlowMin) || (FlowValue > FlowMax))
  PORTA.F4  = 1;
 else
  PORTA.F4  = 0;
 }
 else
 {
  PORTA.F4  = 0;
 }
 UpdateLCD();
 }

 if ((ByteID > 0) && (Counter2 == 0))
 {
 ByteID = 0;
 }
 if (CallFlag == 1)
 {

  PORTC.F5  = 1;
 transmit( 0x20  | GARDEN_ID);
 transmit(buildStatusByte());
  PORTC.F5  = 0;
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
 transmit( 0x20  | GARDEN_ID);
 transmit(buildStatusByte());
 RTCSetupFlag = 0;
  PORTC.F5  = 0;
 }
 if (ProgramSetupFlag == 1)
 {
 ProgStartHour = toBcd(Tmp_ProgStartHour);
 ProgStartMin = toBcd(Tmp_ProgStartMin);
 time_left_high = Tmp_time_left_high;
 time_left_low = Tmp_time_left_low;

  PORTC.F5  = 1;
 transmit( 0x20  | GARDEN_ID);
 transmit(buildStatusByte());
 ProgramSetupFlag = 0;
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
 GARDEN_ID = PORTD & 0x0F;
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

 if (ByteID == 0x00)
 {
 if(((ch & 0x0F)== GARDEN_ID) && ((ch&0xE0)==0xA0))
 {
 Command=ch;
 ByteID = 0x08;
 Counter2=4;
 }
 else if((ch&0xE0)==0x60){
 ByteID = 0x03;
 Counter2 = 3;
 }
 else if(((ch&0x0F)==GARDEN_ID)&& ((ch&0xE0)==0x20)){
 Command= ch;
 ByteID=0x00;
 }
 }
 else if (ByteID == 0x03)
 {
 ConvertTime(ch);
 Tmp_Hour_X1 = X1;
 Tmp_Hour_X10 = X10;
 ByteID = 0x02;
 }
 else if (ByteID == 0x02)
 {
 ConvertTime(ch);
 Tmp_Min_X1 = X1;
 Tmp_Min_X10 = X10;
 ByteID = 0x01;
 }
 else if (ByteID == 0x01)
 {
 ConvertTime(ch);
 Tmp_Sec_X1 = X1;
 Tmp_Sec_X10 = X10;
 ByteID = 0x00;
 RTCSetupFlag = 1;
 }

 else if (ByteID == 0x08)
 {
 Tmp_ProgStartHour = ch;
 ByteID = 0x07;
 }
 else if (ByteID == 0x07)
 {
 Tmp_ProgStartMin = ch;
 ByteID = 0x06;
 }
 else if (ByteID == 0x06)
 {
 Tmp_time_left_high = ch;
 ByteID = 0x05;
 }
 else if (ByteID == 0x05)
 {
 Tmp_time_left_low = ch;
 ByteID = 0x00;
 ProgramSetupFlag = 1;
 }
 }
}

void UpdateLCD()
{
 unsigned char buf[4];


 Lcd_Out(1, 1, "T ");
 Lcd_Chr(1, 3, Hour_X10 + '0');
 Lcd_Chr(1, 4, Hour_X1 + '0');
 Lcd_Chr(1, 5, ':');
 Lcd_Chr(1, 6, Min_X10 + '0');
 Lcd_Chr(1, 7, Min_X1 + '0');
 Lcd_Chr(1, 8, ':');
 Lcd_Chr(1, 9, Sec_X10 + '0');
 Lcd_Chr(1, 10, Sec_X1 + '0');
 Lcd_Out(1, 12, "F:");

 Lcd_Out(1, 14, FlowValue);


 Lcd_Out(2, 1, "S:");
 if ( PORTA.F2 ) Lcd_Chr(2, 3, '1'); else Lcd_Chr(2, 3, '0');
 Lcd_Out(2, 5, "W:");
 if ( PORTA.F3 ) Lcd_Chr(2, 7, '1'); else Lcd_Chr(2, 7, '0');
 Lcd_Out(2, 9, "A:");
 if ( PORTA.F4 ) Lcd_Chr(2, 11, '1'); else Lcd_Chr(2, 11, '0');
 Lcd_Out(2, 13, "M:");
 if (ManualMode) Lcd_Chr(2, 15, '1'); else Lcd_Chr(2, 15, '0');
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

 ADCON1 = 0b00001110;
 ADCON0 = 0b10000001;


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
