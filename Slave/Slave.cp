#line 1 "C:/Users/Student 1/Documents/PES/Archive/Slave/Slave.c"
#line 1 "c:/users/student 1/documents/pes/archive/slave/../commons/config.h"
#line 21 "C:/Users/Student 1/Documents/PES/Archive/Slave/Slave.c"
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



unsigned char SLAVE_ID = 0x00;



bit SystemOn;

bit WateringActive;

bit AlarmActive;

bit ManualMode;

bit FlowOK;



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



unsigned char Seconds = 0x00;

unsigned char Minutes = 0x00;

unsigned char Hours = 0x00;



unsigned char ProgStartHour = 6;

unsigned char ProgStartMin = 0;

unsigned char ProgDurationH = 0;

unsigned char ProgDurationL = 60;

unsigned char ProgramMode = 0x00;



unsigned char Tmp_ProgStartHour = 0x00;

unsigned char Tmp_ProgStartMin = 0x00;

unsigned char Tmp_ProgDurationH = 0x00;

unsigned char Tmp_ProgDurationL = 0x00;

unsigned char Tmp_ProgramMode = 0x00;



unsigned char RemainingH = 0x00;

unsigned char RemainingL = 0x00;



unsigned char FlowValue = 0x00;

unsigned char FlowMin = 20;

unsigned char FlowMax = 60;



unsigned char Tmp_FlowMin = 0x00;

unsigned char Tmp_FlowMax = 0x00;



unsigned char ch = 0x00;

unsigned char Command = 0x00;

unsigned char BytesToReceive = 0x00;

unsigned char Counter2 = 0x00;

unsigned char BAJT1 = 0x00;

unsigned char BAJT2 = 0x00;

unsigned char ControlByte = 0x00;



bit CallFlag ;

bit RTCSetupFlag ;

bit ProgSetupFlag;

bit FlowSetupFlag;

bit GardenSetupFlag;

bit FlagDisp ;



unsigned char Counter = 0x00;

bit TMP_Btn2 ;

bit TMP_Btn1 ;



unsigned char X1;

unsigned char X10;

void init();

void transmit(unsigned char DATA8b);

void IncrementTime();

void DecodeTime();

void ConvertTime(unsigned char val);

unsigned char ReadADC();

void ProcessInputs();

void UpdateLCD();

void Message_StoM();

void SendStatus();

unsigned char HexDigit(unsigned char val);

void LcdByteHex(unsigned char row, unsigned char col, unsigned char val);

void LcdByteDec2(unsigned char row, unsigned char col, unsigned char val);

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

unsigned char ReadADC()

{

 ADCON0.GO_DONE = 1;

 while (ADCON0.GO_DONE)

 ;

 return ADRESH;
}

void ProcessInputs()

{



 TMP_Btn2 = TMP_Btn1;

 if ( PORTB.F0  == 1)

 TMP_Btn1 = 1;

 else

 TMP_Btn1 = 0;

 if ((TMP_Btn2 == 0) && (TMP_Btn1 == 1))

 {

 if (SystemOn == 1)

 {

 if (WateringActive == 1)

 {

 WateringActive = 0;

 ManualMode = 0;

 RemainingH = 0;

 RemainingL = 0;

  PORTA.F2  = 0;

 AlarmActive = 0;

  PORTA.F3  = 0;

 }

 else

 {

 WateringActive = 1;

 ManualMode = 1;

 RemainingH = ProgDurationH;

 RemainingL = ProgDurationL;

  PORTA.F2  = 1;
 }
 }
 }



 FlowValue = ReadADC();



 if (WateringActive == 1)

 {

 if ((FlowValue < FlowMin) || (FlowValue > FlowMax))

 {

 AlarmActive = 1;

  PORTA.F3  = 1;

 FlowOK = 0;

 }

 else

 {

 AlarmActive = 0;

  PORTA.F3  = 0;

 FlowOK = 1;
 }

 }

 else

 {

 AlarmActive = 0;

  PORTA.F3  = 0;

 FlowOK = 1;
 }



 SLAVE_ID = PORTD & 0x0F;



 if ((SystemOn == 1) && (WateringActive == 0))

 {

 if ((Hour_X10 * 10 + Hour_X1 == ProgStartHour) &&

 (Min_X10 * 10 + Min_X1 == ProgStartMin) &&

 (Sec_X10 == 0) && (Sec_X1 == 0))

 {

 WateringActive = 1;

 ManualMode = 0;

 RemainingH = ProgDurationH;

 RemainingL = ProgDurationL;

  PORTA.F2  = 1;
 }
 }



 if (WateringActive == 1)

 {

 if ((RemainingH == 0) && (RemainingL == 0))

 {

 WateringActive = 0;

 ManualMode = 0;

  PORTA.F2  = 0;

 AlarmActive = 0;

  PORTA.F3  = 0;

 }

 else

 {

 if (RemainingL > 0)

 RemainingL--;

 else

 {

 RemainingL = 0xFF;

 if (RemainingH > 0)

 RemainingH--;
 }
 }
 }



 if (SystemOn == 1)

  PORTA.F4  = 1;

 else

  PORTA.F4  = 0;
}

void main()

{

 init();

 Lcd_Init();

 Lcd_Cmd(_LCD_CURSOR_OFF);

 Lcd_Cmd(_LCD_CLEAR);

 SLAVE_ID = PORTD & 0x0F;

 FlagDisp = 1;

 while (1)

 {



 if ((BytesToReceive > 0) && (Counter2 == 0))

 BytesToReceive = 0;



 if (FlagDisp == 1)

 {

 FlagDisp = 0;

 UpdateLCD();
 }



 if (RTCSetupFlag == 1)

 {

 RTCSetupFlag = 0;

 Sec_X1 = Tmp_Sec_X1;

 Sec_X10 = Tmp_Sec_X10;

 Min_X1 = Tmp_Min_X1;

 Min_X10 = Tmp_Min_X10;

 Hour_X1 = Tmp_Hour_X1;

 Hour_X10 = Tmp_Hour_X10;

 SendStatus();
 }



 if (FlowSetupFlag == 1)

 {

 FlowSetupFlag = 0;

 FlowMin = Tmp_FlowMin;

 FlowMax = Tmp_FlowMax;

 SendStatus();
 }



 if (ProgSetupFlag == 1)

 {

 ProgSetupFlag = 0;

 ProgramMode = Tmp_ProgramMode;

 ProgStartHour = Tmp_ProgStartHour;

 ProgStartMin = Tmp_ProgStartMin;

 ProgDurationH = Tmp_ProgDurationH;

 ProgDurationL = Tmp_ProgDurationL;

 SendStatus();
 }



 if (GardenSetupFlag == 1)

 {

 GardenSetupFlag = 0;

 ProgramMode = Tmp_ProgramMode;

 SendStatus();
 }



 if (CallFlag == 1)

 {

 CallFlag = 0;

 SendStatus();
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

unsigned char HexDigit(unsigned char val)

{

 val = val & 0x0F;

 if (val < 10)

 return val + '0';

 return val + 'A' - 10;
}

void LcdByteHex(unsigned char row, unsigned char col, unsigned char val)

{

 Lcd_Chr(row, col, HexDigit(val >> 4));

 Lcd_Chr(row, col + 1, HexDigit(val));
}

void LcdByteDec2(unsigned char row, unsigned char col, unsigned char val)

{

 unsigned char ones ;

 unsigned char tens = 0x00;
 ones = val ;
 while (ones > 9)

 {

 ones = ones - 10;

 tens++;
 }

 Lcd_Chr(row, col, tens + '0');

 Lcd_Chr(row, col + 1, ones + '0');
}

void interrupt()

{



 if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1))

 {

 PIR1.TMR1IF = 0;



 if (Counter == 9)

 {

 Counter = 0;

 IncrementTime();

 DecodeTime();

 ProcessInputs();

 FlagDisp = 1;

 }

 else

 Counter++;



 if (Counter2 > 0)

 Counter2--;

 else

 Counter2 = 0;

 TMR1H = 0x0B;

 TMR1L = 0xDC;
 }
#line 775 "C:/Users/Student 1/Documents/PES/Archive/Slave/Slave.c"
 if ((PIE1.RCIE) && (PIR1.RCIF))

 {

 ch = RCREG;

 PIR1.RCIF = 0;

 if (BytesToReceive == 0x00)

 {

 if ((ch &  0x0F ) == SLAVE_ID)

 {

 Command = ch;

 if ((ch &  0xE0 ) ==  0x20 )

 {

 BytesToReceive = 0x00;

 CallFlag = 1;

 }

 else if ((ch &  0xE0 ) ==  0x60 )

 {

 BytesToReceive =  3 ;

 Counter2 = 3;

 }

 else if ((ch &  0xE0 ) ==  0x80 )

 {

 BytesToReceive =  1 ;

 Counter2 = 3;

 }

 else if ((ch &  0xE0 ) ==  0xA0 )

 {

 BytesToReceive =  5 ;

 Counter2 = 5;

 }

 else if ((ch &  0xE0 ) ==  0xC0 )

 {

 BytesToReceive =  1 ;

 Counter2 = 3;
 }
 }

 }

 else if (BytesToReceive == 0x05)

 {

 BytesToReceive = 0x04;

 Tmp_ProgramMode = ch;

 }

 else if (BytesToReceive == 0x04)

 {

 BytesToReceive = 0x03;

 ch = ch - 0x30;

 if (ch > 23)

 ch = 23;

 Tmp_ProgStartHour = ch;

 }

 else if (BytesToReceive == 0x03)

 {

 if ((Command &  0xE0 ) ==  0x60 )

 {

 BytesToReceive = 0x02;

 ch = ch - 0x30;

 if (ch > 23)

 ch = 23;

 ConvertTime(ch);

 Tmp_Hour_X1 = X1;

 Tmp_Hour_X10 = X10;

 }

 else if ((Command &  0xE0 ) ==  0xA0 )

 {

 BytesToReceive = 0x02;

 ch = ch - 0x30;

 if (ch > 59)

 ch = 59;

 Tmp_ProgStartMin = ch;
 }

 }

 else if (BytesToReceive == 0x02)

 {

 if ((Command &  0xE0 ) ==  0x60 )

 {

 BytesToReceive = 0x01;

 ch = ch - 0x30;

 if (ch > 59)

 ch = 59;

 ConvertTime(ch);

 Tmp_Min_X1 = X1;

 Tmp_Min_X10 = X10;

 }

 else if ((Command &  0xE0 ) ==  0xA0 )

 {

 BytesToReceive = 0x01;

 Tmp_ProgDurationH = ch;
 }

 }

 else if (BytesToReceive == 0x01)

 {

 if ((Command &  0xE0 ) ==  0x60 )

 {

 BytesToReceive = 0x00;

 ch = ch - 0x30;

 if (ch > 59)

 ch = 59;

 ConvertTime(ch);

 Tmp_Sec_X1 = X1;

 Tmp_Sec_X10 = X10;

 RTCSetupFlag = 1;

 }

 else if ((Command &  0xE0 ) ==  0xA0 )

 {

 BytesToReceive = 0x00;

 Tmp_ProgDurationL = ch;

 ProgSetupFlag = 1;

 }

 else if ((Command &  0xE0 ) ==  0xC0 )

 {

 BytesToReceive = 0x00;

 ControlByte = ch;

 if (ControlByte == 0xFF) {
 SystemOn = 1;
 if (WateringActive == 0) {
 WateringActive = 1;
 ManualMode = 0;
 RemainingH = 0;
 RemainingL = 0xB4;
  PORTA.F2  = 1;
 }
 }
 else {
 SystemOn = 0;
 WateringActive = 0;
 ManualMode = 0;
 RemainingH = 0;
 RemainingL = 0;
  PORTA.F2  = 0;
 AlarmActive = 0;
  PORTA.F3  = 0;
 }
 CallFlag = 1;
 }

 else if ((Command &  0xE0 ) ==  0x80 )

 {

 BytesToReceive = 0x00;

 Tmp_ProgramMode = ch;

 GardenSetupFlag = 1;

 }
 }
 }
}

void UpdateLCD()

{

 unsigned char DispH = 0x00;

 unsigned char DispL = 0x00;



 Lcd_Chr(1, 1, Hour_X10 + '0');

 Lcd_Chr(1, 2, Hour_X1 + '0');

 Lcd_Chr(1, 3, ':');

 Lcd_Chr(1, 4, Min_X10 + '0');

 Lcd_Chr(1, 5, Min_X1 + '0');

 Lcd_Chr(1, 6, ':');

 Lcd_Chr(1, 7, Sec_X10 + '0');

 Lcd_Chr(1, 8, Sec_X1 + '0');



 Lcd_Chr(1, 9, ' ');

 Lcd_Chr(1, 10, ' ');

 LcdByteDec2(1, 11, ProgStartHour);

 Lcd_Chr(1, 13, ':');

 LcdByteDec2(1, 14, ProgStartMin);



 if (WateringActive == 1)

 Lcd_Chr(1, 16, 'P');

 else

 Lcd_Chr(1, 16, ' ');



 if (WateringActive == 1)

 {

 DispH = RemainingH;

 DispL = RemainingL;

 }

 else

 {

 DispH = ProgDurationH;

 DispL = ProgDurationL;
 }

 Lcd_Chr(2, 1, 'D');

 Lcd_Chr(2, 2, ':');

 LcdByteHex(2, 3, DispH);

 LcdByteHex(2, 5, DispL);

 Lcd_Chr(2, 7, ' ');

 Lcd_Chr(2, 8, 'F');

 Lcd_Chr(2, 9, ':');

 LcdByteHex(2, 10, FlowValue);

 Lcd_Out(2, 12, "    ");

 if (AlarmActive == 1)

 Lcd_Chr(2, 16, 'A');

 else

 Lcd_Chr(2, 16, ' ');
}

void Message_StoM()

{

 BAJT1 =  0x20  | SLAVE_ID;

 BAJT2 = 0x00;

 if (SystemOn == 1)

 BAJT2 = BAJT2 |  0x80 ;

 if (WateringActive == 1)

 BAJT2 = BAJT2 |  0x40 ;

 if (AlarmActive == 1)

 BAJT2 = BAJT2 |  0x20 ;

 if (ManualMode == 1)

 BAJT2 = BAJT2 |  0x10 ;
}

void SendStatus()

{

 Message_StoM();

  PORTC.F5  = 1;

 transmit(BAJT1);

 transmit(BAJT2);

  PORTC.F5  = 0;
}

void init()

{

 TRISA = 0x03;

 TRISB = 0xFF;

 TRISC = 0xC0;

 TRISD = 0x0F;

 TRISE = 0x00;

 PORTA = 0x00;

 PORTB = 0x00;

 PORTC = 0x00;

 PORTD = 0x00;

 PORTE = 0x00;

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

 Uart1_Init( 19200 );

 TXSTA.TXEN = 1;

 RCSTA.SPEN = 1;

 RCSTA.CREN = 1;

 PIE1.RCIE = 1;

 INTCON.GIE = 1;
}
