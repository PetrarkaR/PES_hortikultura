//SLAVE program za kontrolisanje baste, koji se nalazi na mikrokontroleru PIC16F877A
// sve sto je vezano za rampe treba da se modifikuje da radi za BASTU.
// mikroC compiler.
// simple.
// definicija ulaznih pinova
#define PinTaster PORTB.F0
#define PinReset PORTB.F2

#define DEBOUNCE_TICKS 10

#define PinSystemOn PORTA.F2
#define PinWatering PORTA.F3
#define PinAlarm PORTA.F4

#define DR PORTC.F5

#include "../commons/config.h"

unsigned char GARDEN_ID = 0x00;
unsigned char Tmp_time_left_high = 0x00;
unsigned char Tmp_time_left_low  = 0x00;
unsigned char time_left_high     = 0x00;
unsigned char time_left_low      = 0x00;
unsigned char ProgStartHour      = 0x00;   
unsigned char ProgStartMin       = 0x00;
unsigned int  WateringSec        = 0;      

bit ProgramSetupFlag;

// ID broj rampe
unsigned char ByteID = 0x00;
// broj bajtova koji treba da se primi do dekodiranja
unsigned char ch = 0x00;
// primljeni bajt
unsigned char Command = 0x00;
// bajt komande koji se prima
unsigned char CommandModified = 0x00; // bajt koji se salje

bit CallFlag;
// oznaka da se stigao zahtev za prozivkom
bit RTCSetupFlag;
// oznaka da je stigao zahtev za podesavanjem vremena
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

unsigned char FlowValue = 0x00; // trenutno ocitavanje
unsigned char FlowMin = 20;     // minimalni dozvoljeni protok
unsigned char FlowMax = 60;     // maksimalni dozvoljeni protok

void DecodeTime();
void ProcessInputs();
void IncrementTime();
void init();
void UpdateLCD();

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

   // garden-related state
   time_left_high   = 0x00;
   time_left_low    = 0x00;
   WateringSec      = 0;
   ManualMode       = 0;
   ManualEvent      = 0;
   ResetEvent       = 0;
   ProgramSetupFlag = 0;
   ProgStartHour    = 0x00;
   ProgStartMin     = 0x00;
   PinSystemOn      = 1;
   PinWatering      = 0;
   PinAlarm         = 0;
}

unsigned char ReadADC() {
  ADCON0.GO_DONE = 1;    // pokreni konverziju
  while (ADCON0.GO_DONE) //
    ;
  return ADRESH;
}



void transmit(unsigned char DATA8b)
{

   TXREG = DATA8b;
  while (!TXSTA.TRMT) // cekaj dok se shift registar ne isprazni
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
   // Taster (PORTB.F0) - manual mode
   if (cntManual > 0) cntManual--;
   if (PinTaster == 0) TMP_Taster1 = 0;
   if ((cntManual == 0) && (TMP_Taster1 == 0) && (PinTaster == 1))
   {
      TMP_Taster1 = 1;
      cntManual = DEBOUNCE_TICKS;
      if (ManualMode == 1) ManualMode = 0;
      else                 ManualMode = 1;
      ManualEvent = 1;     // consumed by main
   }

   // Reset (PORTB.F2) - reset
   if (cntReset > 0) cntReset--;
   if (PinReset == 0) TMP_Reset1 = 0;
   if ((cntReset == 0) && (TMP_Reset1 == 0) && (PinReset == 1))
   {
      TMP_Reset1 = 1;
      cntReset = DEBOUNCE_TICKS;
      ResetEvent = 1;      // consumed by main
   }
}

unsigned char buildStatusByte()
{ //SWAM system, watering, alarm, manual -system on je samo za struju prakticno. 
   unsigned char status = 0x00;
   if (PinSystemOn) status |= STATUS_SYSTEM_BIT;
   if (PinWatering) status |= STATUS_WATER_BIT;
   if (PinAlarm)    status |= STATUS_ALARM_BIT;
   if (ManualMode)  status |= STATUS_MANUAL_BIT;
   return status;
}

//ezotericni kod za konverziju iz decimalnog u bcd
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
   Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
   UpdateLCD();

   while (1)
   {

      // --- Reset: full stop ---
      if (ResetEvent == 1)
      {
         ResetEvent  = 0;
         PinWatering = 0;
         PinSystemOn = 1;
         PinAlarm    = 0;
         ManualMode  = 0;
         ManualEvent = 0;
         WateringSec = 0;
      }

      // manual dugme , kao toggle radi
      if (ManualEvent == 1)
      {
         ManualEvent = 0;
         if (ManualMode == 1)
         {
            //zalivam  180s
            WateringSec = 180;
            PinWatering = 1;
            PinSystemOn = 1;
         }
         else
         {
            // gasi zalivanje, ali ne diraj program
            WateringSec = 0;
         }
      }

      if (UpdateLCDFlag == 1)
      {
         UpdateLCDFlag = 0;

         // Scheduled start: BCD compare, only at second 0 of the matching minute
         if ((PinWatering == 0) &&
             (Seconds == 0x00) &&
             (Hours   == ProgStartHour) &&
             (Minutes == ProgStartMin))
         {
            WateringSec = ((unsigned int)time_left_high << 8) | time_left_low;
            PinWatering = 1;
            PinSystemOn = 1;
         }

         // Countdown
         if (PinWatering == 1)
         {
            if (WateringSec > 0) WateringSec--;
            if (WateringSec == 0)
            {
               PinWatering = 0;
               PinSystemOn = 1;
               ManualMode  = 0;
            }
         }

         FlowValue = ReadADC();
         if (PinWatering == 1)
            {
               if ((FlowValue < FlowMin) || (FlowValue > FlowMax))
                  PinAlarm = 1;
               else
                  PinAlarm = 0;
            }
            else
            {
               PinAlarm = 0;
            }
         UpdateLCD();
      }

      if ((ByteID > 0) && (Counter2 == 0))
      {
         ByteID = 0;
      }
      if (CallFlag == 1)
      {
         // Poll response
         DR = 1;
         transmit(STATUS_CODE | GARDEN_ID);
         transmit(buildStatusByte());
         DR = 0;
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
         DR = 1;
         transmit(STATUS_CODE | GARDEN_ID);
         transmit(buildStatusByte());
         RTCSetupFlag = 0;
         DR = 0;
      }
      if (ProgramSetupFlag == 1)
      {
         ProgStartHour  = toBcd(Tmp_ProgStartHour);
         ProgStartMin   = toBcd(Tmp_ProgStartMin);
         time_left_high = Tmp_time_left_high;
         time_left_low  = Tmp_time_left_low;

         DR = 1;
         transmit(STATUS_CODE | GARDEN_ID);
         transmit(buildStatusByte());
         ProgramSetupFlag = 0;
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
   if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
   {
      // prekid tajmera na svakih 100ms
      PIR1.TMR1IF = 0; // brise se flag

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

      TMR1H = 0x0B; // startne vrednosti tajmera 1
      TMR1L = 0xDC;
   }

   if ((PIE1.RCIE) && (PIR1.RCIF))
   {
      ch = RCREG;
      if (ByteID == 0x00)
      {
         if ((ch & 0x0F) == GARDEN_ID)
         {
            // adresa slejva se poklapa
            Command = ch;
            if ((ch & 0xE0) == 0x20)
            {
               // primljeni bajt je bajt prozivke
               ByteID = 0x00;
               CallFlag = 1;
            }
            else if ((ch & 0xE0) == 0x60)
            {
               // primljeni bajt je komanda za
               // podesavanje sata realnog vremena
               ByteID = 0x03;
               Counter2 = 3;
               // 300 ms je vreme tokom kojeg
               // trebaju da stignu preostali bajtovi
            }
            else if ((ch & 0xE0) == 0xA0)
               {
                  ByteID = 0x08;
                  Counter2 = 6;
               }
         }
      }
      else if (ByteID == 0x03)          
      {
         ConvertTime(ch);
         Tmp_Hour_X1  = X1;
         Tmp_Hour_X10 = X10;
         ByteID = 0x02;
      }
      else if (ByteID == 0x02)          
      {
         ConvertTime(ch);
         Tmp_Min_X1   = X1;
         Tmp_Min_X10  = X10;
         ByteID = 0x01;
      }
      else if (ByteID == 0x01)          
      {
         ConvertTime(ch);
         Tmp_Sec_X1   = X1;
         Tmp_Sec_X10  = X10;
         ByteID = 0x00;
         RTCSetupFlag = 1;
      }
      //ovi bajtovi sluze za program. kada sa web terminala stigne komanda u formatu HH MM SS - SS
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
   Lcd_Chr(1, 3,  Hour_X10 + '0');
   Lcd_Chr(1, 4,  Hour_X1  + '0');
   Lcd_Chr(1, 5,  ':');
   Lcd_Chr(1, 6,  Min_X10  + '0');
   Lcd_Chr(1, 7,  Min_X1   + '0');
   Lcd_Chr(1, 8,  ':');
   Lcd_Chr(1, 9,  Sec_X10  + '0');
   Lcd_Chr(1, 10, Sec_X1   + '0');
   Lcd_Out(1, 12, "F:");
   ByteToStr(FlowValue, buf);    
   Lcd_Out(1, 14, buf);

   // Row 2: S:X W:X A:X M:X
   Lcd_Out(2, 1, "S:");
   if (PinSystemOn) Lcd_Chr(2, 3,  '1'); else Lcd_Chr(2, 3,  '0');
   Lcd_Out(2, 5, "W:");
   if (PinWatering) Lcd_Chr(2, 7,  '1'); else Lcd_Chr(2, 7,  '0');
   Lcd_Out(2, 9, "A:");
   if (PinAlarm)    Lcd_Chr(2, 11, '1'); else Lcd_Chr(2, 11, '0');
   Lcd_Out(2, 13, "M:");
   if (ManualMode)  Lcd_Chr(2, 15, '1'); else Lcd_Chr(2, 15, '0');
}

void init()
{

   // pinovi na portu A su digitalni izlazi;
   TRISA = 0x03;
   // pinovi na portu B su SVI digitalni ulazi
   TRISB = 0x3F;
   TRISC = 0xC0; // pinovi 6 i 7 su vezani za RS232

   TRISD = 0x0F; // pinovi 6 i 7 su vezani za RS232

   PORTA = 0x00;
   PORTB = 0x00;
   PORTC = 0x00;

   ADCON1 = 0b00001110;
   ADCON0 = 0b10000001;


   INTCON = 0b11000000; // default
   PIE1 = 0b00000000;   // default

   T1CON = 0b00110000; // konfiguracija za Tajmer 1
   // preskaler 1/8
   TMR1H = 0x0B; // startne vrednosti tajmera 1
   TMR1L = 0xDC;
   T1CON.TMR1ON = 1;

   // Fosc=20MHz, Tosc= 50ns
   // takt frekv. Fosc/4 dolazi na preskaler koji je podesen na 1/8
   // izlaz preskalera vodi se na brojace TMR1H_TMR1L
   // (10000)h- (0BDC)h= (F424)h= (62500)dec
   // 62500 x  8 x 4 Tosc= 100ms

   PIR1.TMR1IF = 0;
   PIE1.TMR1IE = 1;

   Uart1_Init(19200);
   // konfiguri�emo serijski prt na bitsku brzinu od 19200
   // i konfiguri�emo dodatne bitove za serijski prenos
   TXSTA.TXEN = 1;
   RCSTA.SPEN = 1;
   RCSTA.CREN = 1;
   PIE1.RCIE = 1;

   INTCON.GIE = 1;
   // globalna dozvola prekida
}
