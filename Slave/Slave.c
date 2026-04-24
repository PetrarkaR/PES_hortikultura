
// definicija ulaznih pinova
#define PinManualBtn   PORTB.F0   // Taster za manuelno pokretanje/zaustavljanje

// RA0 = analogni ulaz za senzor protoka (potenciometar na ploci)

// definicija izlaznih pinova
#define PinPump        PORTA.F2   // Pumpa (1=ukljucena)
#define PinAlarm       PORTA.F3   // Zvucni alarm
#define PinStatusLED   PORTA.F4   // LED - sistem ukljucen

#define DR             PORTC.F5   // RS485 smer (1=transmit, 0=receive)

// Lcd pinout settings
sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC2_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;

// Pin direction
sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

// globalne promenljive
unsigned char SLAVE_ID = 0x00;

// stanja sistema
bit SystemOn = 1;
bit WateringActive = 0;
bit AlarmActive = 0;
bit ManualMode = 0;
bit FlowOK = 0;

// RTC - BCD cifre
unsigned char Sec_X1 = 0x00;
unsigned char Sec_X10 = 0x00;
unsigned char Min_X1 = 0x00;
unsigned char Min_X10 = 0x00;
unsigned char Hour_X1 = 0x00;
unsigned char Hour_X10 = 0x00;

// privremene za prijem RTC
unsigned char Tmp_Sec_X1 = 0x00;
unsigned char Tmp_Sec_X10 = 0x00;
unsigned char Tmp_Min_X1 = 0x00;
unsigned char Tmp_Min_X10 = 0x00;
unsigned char Tmp_Hour_X1 = 0x00;
unsigned char Tmp_Hour_X10 = 0x00;

// pakovane BCD vrednosti
unsigned char Seconds = 0x00;
unsigned char Minutes = 0x00;
unsigned char Hours = 0x00;

// parametri programa rada (primaju se od Mastera, zadaje ih CRS)
unsigned char ProgStartHour = 6;
unsigned char ProgStartMin = 0;
unsigned char ProgDurationH = 0;
unsigned char ProgDurationL = 60;

// privremene za prijem programa
unsigned char Tmp_ProgStartHour = 0x00;
unsigned char Tmp_ProgStartMin = 0x00;
unsigned char Tmp_ProgDurationH = 0x00;
unsigned char Tmp_ProgDurationL = 0x00;

// preostalo vreme zalivanja
unsigned char RemainingH = 0x00;
unsigned char RemainingL = 0x00;

// senzor protoka - analogno ocitavanje (ADC na RA0, 8-bit, 0-255)
unsigned char FlowValue = 0x00;
unsigned char FlowMin = 20;
unsigned char FlowMax = 230;

// privremene za prijem granica protoka
unsigned char Tmp_FlowMin = 0x00;
unsigned char Tmp_FlowMax = 0x00;

// pomocna za LCD prikaz (16-bit sekunde)
unsigned int TmpDisplay = 0;

// komunikacija
unsigned char ch = 0x00;
unsigned char Command = 0x00;
unsigned char BytesToReceive = 0x00;
unsigned char Counter2 = 0x00;
unsigned char BAJT1 = 0x00;
unsigned char BAJT2 = 0x00;

// flagovi
bit CallFlag = 0;
bit RTCSetupFlag = 0;
bit ProgSetupFlag = 0;
bit FlowSetupFlag = 0;
bit FlagDisp = 0;

// brojaci i debounce
unsigned char Counter = 0x00;

bit TMP_Btn2 = 0;
bit TMP_Btn1 = 0;

// pomocne za ConvertTime
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
   // debounce manuelnog tastera - rastuca ivica (1s reakcija)
   TMP_Btn2 = TMP_Btn1;
   if (PinManualBtn == 1)
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
            PinPump = 0;
            AlarmActive = 0;
            PinAlarm = 0;
         }
         else
         {
            WateringActive = 1;
            ManualMode = 1;
            RemainingH = ProgDurationH;
            RemainingL = ProgDurationL;
            PinPump = 1;
         }
      }
   }

   // ocitavanje senzora protoka (ADC na RA0)
   FlowValue = ReadADC();

   // provera opsega protoka
   if (WateringActive == 1)
   {
      if ((FlowValue < FlowMin) || (FlowValue > FlowMax))
      {
         AlarmActive = 1;
         PinAlarm = 1;
         FlowOK = 0;
      }
      else
      {
         AlarmActive = 0;
         PinAlarm = 0;
         FlowOK = 1;
      }
   }
   else
   {
      AlarmActive = 0;
      PinAlarm = 0;
      FlowOK = 1;
   }

   // citanje Slave ID
   SLAVE_ID = PORTD & 0x0F;

   // automatsko pokretanje zalivanja
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
         PinPump = 1;
      }
   }

   // odbrojavanje preostalog vremena
   if (WateringActive == 1)
   {
      if ((RemainingH == 0) && (RemainingL == 0))
      {
         WateringActive = 0;
         ManualMode = 0;
         PinPump = 0;
         AlarmActive = 0;
         PinAlarm = 0;
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

   // status LED
   if (SystemOn == 1)
      PinStatusLED = 1;
   else
      PinStatusLED = 0;
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
      // timeout za visebajtni prijem
      if ((BytesToReceive > 0) && (Counter2 == 0))
         BytesToReceive = 0;

      // osvezavanje LCD-a
      if (FlagDisp == 1)
      {
         FlagDisp = 0;
         UpdateLCD();
      }

      // podesavanje sata
      if (RTCSetupFlag == 1)
      {
         RTCSetupFlag = 0;
         Sec_X1 = Tmp_Sec_X1;
         Sec_X10 = Tmp_Sec_X10;
         Min_X1 = Tmp_Min_X1;
         Min_X10 = Tmp_Min_X10;
         Hour_X1 = Tmp_Hour_X1;
         Hour_X10 = Tmp_Hour_X10;
         DR = 1;
         BAJT1 = 0xC0 | 0x20 | SLAVE_ID;
         transmit(BAJT1);
         DR = 0;
      }

      // podesavanje granica protoka
      if (FlowSetupFlag == 1)
      {
         FlowSetupFlag = 0;
         FlowMin = Tmp_FlowMin;
         FlowMax = Tmp_FlowMax;
         DR = 1;
         BAJT1 = 0x80 | SLAVE_ID;
         transmit(BAJT1);
         DR = 0;
      }

      // podesavanje programa
      if (ProgSetupFlag == 1)
      {
         ProgSetupFlag = 0;
         ProgStartHour = Tmp_ProgStartHour;
         ProgStartMin = Tmp_ProgStartMin;
         ProgDurationH = Tmp_ProgDurationH;
         ProgDurationL = Tmp_ProgDurationL;
         DR = 1;
         BAJT1 = 0xC0 | 0x10 | SLAVE_ID;
         transmit(BAJT1);
         DR = 0;
      }

      // odgovor na prozivku
      if (CallFlag == 1)
      {
         CallFlag = 0;
         Message_StoM();
         DR = 1;
         transmit(BAJT1);
         transmit(BAJT2);
         DR = 0;
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
         /////////
         if (Min_X1 >= 9)
         {
            Min_X1 = 0;
            if (Min_X10 >= 5)
            {
               Min_X10 = 0;
               /////////
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
               /////////
            }
            else
               Min_X10++;
         }
         else
            Min_X1++;
         /////////
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
   // prekid tajmera (svake 100ms)
   if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1))
   {
      PIR1.TMR1IF = 0;

      // brojac do 1s (10 x 100ms)
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

      // timeout za visebajtni prijem
      if (Counter2 > 0)
         Counter2--;
      else
         Counter2 = 0;

      TMR1H = 0x0B;
      TMR1L = 0xDC;
   }

   // serijski prijem (UART)
   //
   // Protokol Master -> Slave:
   //   001 (0x20) = prozivka, bit4=SystemOn
   //   011 (0x60) = podesavanje sata, +3 bajta
   //   100 (0x80) = podesavanje protoka, +2 bajta
   //   101 (0xA0) = podesavanje programa, +4 bajta
   //   110 (0xC0) = daljinsko pokretanje
   //   111 (0xE0) = daljinsko zaustavljanje
   //
   if ((PIE1.RCIE) && (PIR1.RCIF))
   {
      ch = RCREG;
      PIR1.RCIF = 0;

      if (BytesToReceive == 0x00)
      {
         if ((ch & 0x0F) == SLAVE_ID)
         {
            Command = ch;

            if ((ch & 0xE0) == 0x20)
            {
               if ((ch & 0x10) == 0x10)
                  SystemOn = 1;
               else
               {
                  SystemOn = 0;
                  WateringActive = 0;
                  PinPump = 0;
               }
               BytesToReceive = 0x00;
               CallFlag = 1;
            }
            else if ((ch & 0xE0) == 0x60)
            {
               BytesToReceive = 0x03;
               Counter2 = 3;
            }
            else if ((ch & 0xE0) == 0x80)
            {
               BytesToReceive = 0x02;
               Counter2 = 3;
            }
            else if ((ch & 0xE0) == 0xA0)
            {
               BytesToReceive = 0x04;
               Counter2 = 5;
            }
            else if ((ch & 0xE0) == 0xC0)
            {
               if ((SystemOn == 1) && (WateringActive == 0))
               {
                  WateringActive = 1;
                  ManualMode = 0;
                  RemainingH = ProgDurationH;
                  RemainingL = ProgDurationL;
                  PinPump = 1;
               }
            }
            else if ((ch & 0xE0) == 0xE0)
            {
               WateringActive = 0;
               ManualMode = 0;
               RemainingH = 0;
               RemainingL = 0;
               PinPump = 0;
               AlarmActive = 0;
               PinAlarm = 0;
            }
         }
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
         if ((Command & 0xE0) == 0x60)
         {
            BytesToReceive = 0x02;
            ch = ch - 0x30;
            if (ch > 59)
               ch = 59;
            ConvertTime(ch);
            Tmp_Sec_X1 = X1;
            Tmp_Sec_X10 = X10;
         }
         else if ((Command & 0xE0) == 0xA0)
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
         if ((Command & 0xE0) == 0x60)
         {
            BytesToReceive = 0x01;
            ch = ch - 0x30;
            if (ch > 59)
               ch = 59;
            ConvertTime(ch);
            Tmp_Min_X1 = X1;
            Tmp_Min_X10 = X10;
         }
         else if ((Command & 0xE0) == 0x80)
         {
            BytesToReceive = 0x01;
            Tmp_FlowMin = ch;
         }
         else if ((Command & 0xE0) == 0xA0)
         {
            BytesToReceive = 0x01;
            Tmp_ProgDurationH = ch;
         }
      }
      else if (BytesToReceive == 0x01)
      {
         if ((Command & 0xE0) == 0x60)
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
         else if ((Command & 0xE0) == 0x80)
         {
            BytesToReceive = 0x00;
            Tmp_FlowMax = ch;
            FlowSetupFlag = 1;
         }
         else if ((Command & 0xE0) == 0xA0)
         {
            BytesToReceive = 0x00;
            Tmp_ProgDurationL = ch;
            ProgSetupFlag = 1;
         }
      }
   }
}


void UpdateLCD()
{
   // --- red 1: tekuce vreme ---
   Lcd_Chr(1, 1, Hour_X10 + '0');
   Lcd_Chr(1, 2, Hour_X1 + '0');
   Lcd_Chr(1, 3, ':');
   Lcd_Chr(1, 4, Min_X10 + '0');
   Lcd_Chr(1, 5, Min_X1 + '0');
   Lcd_Chr(1, 6, ':');
   Lcd_Chr(1, 7, Sec_X10 + '0');
   Lcd_Chr(1, 8, Sec_X1 + '0');

   // --- red 1: vreme pocetka programa ---
   Lcd_Chr(1, 9, ' ');
   Lcd_Chr(1, 10, ' ');
   Lcd_Chr(1, 11, (ProgStartHour / 10) + '0');
   Lcd_Chr(1, 12, (ProgStartHour % 10) + '0');
   Lcd_Chr(1, 13, ':');
   Lcd_Chr(1, 14, (ProgStartMin / 10) + '0');
   Lcd_Chr(1, 15, (ProgStartMin % 10) + '0');

   // --- red 1 pozicija 16: P ako pumpa radi ---
   if (WateringActive == 1)
      Lcd_Chr(1, 16, 'P');
   else
      Lcd_Chr(1, 16, ' ');

   // --- red 2: preostalo/trajanje u sekundama (4 cifre) ---
   if (WateringActive == 1)
      TmpDisplay = ((unsigned int)RemainingH << 8) | RemainingL;
   else
      TmpDisplay = ((unsigned int)ProgDurationH << 8) | ProgDurationL;

   Lcd_Chr(2, 1, (TmpDisplay / 1000) + '0');
   Lcd_Chr(2, 2, ((TmpDisplay / 100) % 10) + '0');
   Lcd_Chr(2, 3, ((TmpDisplay / 10) % 10) + '0');
   Lcd_Chr(2, 4, (TmpDisplay % 10) + '0');

   // --- red 2: protok ---
   Lcd_Chr(2, 5, ' ');
   Lcd_Chr(2, 6, 'F');
   Lcd_Chr(2, 7, ':');
   Lcd_Chr(2, 8, (FlowValue / 100) + '0');
   Lcd_Chr(2, 9, ((FlowValue / 10) % 10) + '0');
   Lcd_Chr(2, 10, (FlowValue % 10) + '0');

   // --- red 2: razmak i alarm ---
   Lcd_Out(2, 11, "     ");
   if (AlarmActive == 1)
      Lcd_Chr(2, 16, 'A');
   else
      Lcd_Chr(2, 16, ' ');
}
void Message_StoM()
{
   BAJT1 = 0xC0 | SLAVE_ID;
   if (SystemOn == 1)
      BAJT1 = BAJT1 | 0x20;
   if (WateringActive == 1)
      BAJT1 = BAJT1 | 0x10;

   BAJT2 = 0x00;
   if (AlarmActive == 1)
      BAJT2 = BAJT2 | 0x80;
   if (ManualMode == 1)
      BAJT2 = BAJT2 | 0x40;
   if (FlowOK == 1)
      BAJT2 = BAJT2 | 0x20;
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

   ADCON1 = 0b00001110;   // AN0 analogni, ostali digitalni, left justified
   ADCON0 = 0b10000001;   // Fosc/32, kanal AN0, ADC ukljucen

   INTCON = 0b11000000;
   PIE1 = 0b00000000;

   T1CON = 0b00110000;
   TMR1H = 0x0B;
   TMR1L = 0xDC;
   T1CON.TMR1ON = 1;

   // (10000h - 0BDCh) = F424h = 62500
   // 62500 x 8 x 4 x 50ns = 100ms

   PIR1.TMR1IF = 0;
   PIE1.TMR1IE = 1;

   Uart1_Init(19200);
   TXSTA.TXEN = 1;
   RCSTA.SPEN = 1;
   RCSTA.CREN = 1;
   PIE1.RCIE = 1;

   INTCON.GIE = 1;
}
