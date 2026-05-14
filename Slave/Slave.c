<<<<<<< Updated upstream
#define PinManualBtn                                                           \
  PORTB.F0 // Taster za rucno pokretanje/gasenje pumpe
           // RA0 = analogni ulaz za senzor protoka
           // (potenciometar simulira senzor na ploci)

// IZLAZI:
#define PinPump PORTA.F3      // Pumpa vode (1=radi, 0=stoji)
#define PinAlarm PORTA.F4     // Zujalica za alarm loseg protoka
#define PinStatusLED PORTA.F2 // LED indikator - svetli kad je sistem aktivan
#define DR PORTC.F5           // RS485 smer: 1=saljemo, 0=primamo

// Trajanje rucnog zalivanja: 0x012C = 300 sekundi (5 minuta)
// Razbijeno na dva bajta jer PIC16 ne voli 16-bitne brojeve
#define MANUAL_DURATION_H 0x01
#define MANUAL_DURATION_L 0x2C

#include "../commons/config.h"

sbit LCD_RS at RC0_bit;
sbit LCD_EN at RC2_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D4 at RD4_bit;
=======
// SLAVE program za kontrolisanje baste, koji se nalazi na mikrokontroleru
// PIC16F877A
//  sve sto je vezano za rampe treba da se modifikuje da radi za BASTU.
//  mikroC compiler.
//  simple.
//  definicija ulaznih pinova
#define PinTaster PORTB.F0
#define PinReset PORTB.F2

#define PinSystemOn PORTA.F2
#define PinWatering PORTA.F3
#define PinAlarm PORTA.F4

#define DR PORTC.F5

#include "../commons/config.h"

unsigned char GARDEN_ID = 0x00;
unsigned char Tmp_time_left_high = 0x00;
unsigned char Tmp_time_left_low = 0x00;
unsigned char time_left_high = 0x00;
unsigned char time_left_low = 0x00;
unsigned char ProgStartHour = 0x00;
unsigned char ProgStartMin = 0x00;
unsigned int WateringSec = 0;
>>>>>>> Stashed changes

sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISD7_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD4_bit;

unsigned char SLAVE_ID = 0x00;

// ----- STANJA SISTEMA (bit flagovi) -----
bit SystemOn;       // 1 = sistem aktiviran (ima program ili je rucno ukljucen)
bit WateringActive; // 1 = pumpa trenutno radi, zalivanje u toku
bit AlarmActive;    // 1 = protok van opsega, zujalica urla
bit ManualMode;     // 1 = zalivanje pokrenuto rucno tasterom
bit FlowOK;         // 1 = protok u dozvoljenom opsegu

unsigned char Sec_X1 = 0x00;
unsigned char Sec_X10 = 0x00;
unsigned char Min_X1 = 0x00;
unsigned char Min_X10 = 0x00;
unsigned char Hour_X1 = 0x00;
unsigned char Hour_X10 = 0x00;

// Privremeni bafer za prijem RTC podataka sa UART-a
// Prvo upisujemo ovde, pa tek kad dodje ceo paket prebacimo u prave
// Da ne pokvarimo sat ako se prijem prekine na pola
unsigned char Tmp_Sec_X1 = 0x00;
unsigned char Tmp_Sec_X10 = 0x00;
unsigned char Tmp_Min_X1 = 0x00;
unsigned char Tmp_Min_X10 = 0x00;
unsigned char Tmp_Hour_X1 = 0x00;
unsigned char Tmp_Hour_X10 = 0x00;

// Pakovane BCD vrednosti (za poredjenje, ne koristimo ih mnogo)
unsigned char Seconds = 0x00;
unsigned char Minutes = 0x00;
unsigned char Hours = 0x00;

// ----- PARAMETRI PROGRAMA ZALIVANJA -----
// Ovo nam salje Master kad korisnik podesi program na CRS-u
unsigned char ProgStartHour = 6;  // sat pocetka (default 06:00)
unsigned char ProgStartMin = 0;   // minut pocetka
unsigned char ProgDurationH = 0;  // trajanje - visoki bajt (sekunde)
unsigned char ProgDurationL = 60; // trajanje - niski bajt (default 60s)
unsigned char ProgramMode = 0x00; // 0=OFF, sve ostalo=ON

unsigned char Tmp_ProgStartHour = 0x00;
unsigned char Tmp_ProgStartMin = 0x00;
unsigned char Tmp_ProgDurationH = 0x00;
unsigned char Tmp_ProgDurationL = 0x00;
unsigned char Tmp_ProgramMode = 0x00;

// Preostalo vreme zalivanja (16-bit, odbrojava se svake sekunde)
unsigned char RemainingH = 0x00;
unsigned char RemainingL = 0x00;

// ----- SENZOR PROTOKA -----
// ADC na kanalu AN0 (RA0), 8-bitni rezultat (0-255)
// Na ploci je potenciometar umesto pravog senzora
unsigned char FlowValue = 0x00; // trenutno ocitavanje
unsigned char FlowMin = 20;     // minimalni dozvoljeni protok
unsigned char FlowMax = 60;     // maksimalni dozvoljeni protok

unsigned char ch = 0x00;             // poslednji primljeni bajt sa UART-a
unsigned char byteId = BYTE_ID_IDLE; // trenutno stanje state machine za prijem
unsigned char Counter2 = 0x00;       // timeout brojac za visebajtni prijem
unsigned char BAJT1 = 0x00;          // prvi bajt status odgovora
unsigned char BAJT2 = 0x00;          // drugi bajt (flagovi)

bit RTCSetupFlag;  // 1 = stigao kompletan RTC paket, treba primeniti
bit ProgSetupFlag; // 1 = stigao kompletan program, treba primeniti
bit FlagDisp;      // 1 = treba osveziti LCD

unsigned char Counter = 0x00; // brojac 100ms tikova do 1 sekunde (0-9)
bit TMP_Btn2; // prethodno stanje tastera (za detekciju rastuce ivice)
bit TMP_Btn1; // trenutno stanje tastera

unsigned char X1;  // jedinice
unsigned char X10; // desetice

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

<<<<<<< Updated upstream
void transmit(unsigned char DATA8b) {
  TXREG = DATA8b;
  while (!TXSTA.TRMT) // cekaj dok se shift registar ne isprazni
    ;
}

//  PAKOVANJE BCD CIFARA u jedan bajt
//  npr. Hour_X10=1, Hour_X1=4 => Hours = 0x14
//  Koristimo za pakovani BCD format
void DecodeTime() {
  Seconds = (Sec_X10 << 4) + Sec_X1;
  Minutes = (Min_X10 << 4) + Min_X1;
  Hours = (Hour_X10 << 4) + Hour_X1;
=======
void init_variables() {

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
  time_left_high = 0x00;
  time_left_low = 0x00;
  WateringSec = 0;
  ManualMode = 0;
  ManualEvent = 0;
  ResetEvent = 0;
  ProgramSetupFlag = 0;
  ProgStartHour = 0x00;
  ProgStartMin = 0x00;
  PinSystemOn = 1;
  PinWatering = 0;
  PinAlarm = 0;
>>>>>>> Stashed changes
}

unsigned char ReadADC() {
  ADCON0.GO_DONE = 1;    // pokreni konverziju
  while (ADCON0.GO_DONE) //
    ;
  return ADRESH;
}

<<<<<<< Updated upstream
void ProcessInputs() {
  TMP_Btn2 = TMP_Btn1;
  if (PinManualBtn == 1)
    TMP_Btn1 = 1;
  else
    TMP_Btn1 = 0;

  // Rastuca ivica detektovana - toggle zalivanja
  if ((TMP_Btn2 == 0) && (TMP_Btn1 == 1)) {
    if (WateringActive == 1) {
      // Pumpa vec radi -> ugasi sve, resetuj
      WateringActive = 0;
      ManualMode = 0;
      RemainingH = 0;
      RemainingL = 0;
      PinPump = 0;
      AlarmActive = 0;
      PinAlarm = 0;
    } else {
      // Pumpa ne radi -> upali rucno zalivanje na 300s
      SystemOn = 1;
      WateringActive = 1;
      ManualMode = 1;
      RemainingH = MANUAL_DURATION_H;
      RemainingL = MANUAL_DURATION_L;
      PinPump = 1;
    }
  }

  // --- SENZOR PROTOKA ---
  FlowValue = ReadADC();

  // Provera opsega - samo kad pumpa radi ima smisla gledati protok
  if (WateringActive == 1) {
    if ((FlowValue < FlowMin) || (FlowValue > FlowMax)) {
      // Protok van opsega - nesto nije u redu (cev pukla, pumpa prazna, itd)
      AlarmActive = 1;
      PinAlarm = 1;
      FlowOK = 0;
    } else {
      // Sve ok, protok normalan
      AlarmActive = 0;
      PinAlarm = 0;
      FlowOK = 1;
    }
  } else {
    // Pumpa ne radi, nema sta da se proverava
    AlarmActive = 0;
    PinAlarm = 0;
    FlowOK = 1;
  }

  SLAVE_ID = PORTD & 0x0F;

  // --- AUTOMATSKO POKRETANJE ZALIVANJA ---
  // Ako je sistem aktivan, pumpa ne radi, i trenutno vreme se
  // poklapa sa programiranim vremenom pocetka -> kreni sa zalivanjem
  // Proveravamo i sekunde==00 da ne bi kretali vise puta u istom minutu
  if ((SystemOn == 1) && (WateringActive == 0)) {
    if ((Hour_X10 * 10 + Hour_X1 == ProgStartHour) &&
        (Min_X10 * 10 + Min_X1 == ProgStartMin) && (Sec_X10 == 0) &&
        (Sec_X1 == 0)) {
      WateringActive = 1;
      ManualMode = 0; // nije rucno, automatski je
      RemainingH = ProgDurationH;
      RemainingL = ProgDurationL;
      PinPump = 1; // pumpa radi
    }
  }

  // --- ODBROJAVANJE PREOSTALOG VREMENA ---
  // Svake sekunde smanjujemo 16-bitni brojac (RemainingH:RemainingL)
  // Kad dodje do nule - gasimo pumpu
  if (WateringActive == 1) {
    if ((RemainingH == 0) && (RemainingL == 0)) {
      // Vreme isteklo - sve gasimo
      WateringActive = 0;
      ManualMode = 0;
      PinPump = 0;
      AlarmActive = 0;
      PinAlarm = 0;
    } else {
      // Dekrementiramo 16-bitni brojac rucno
      if (RemainingL > 0)
        RemainingL--;
      else {
        RemainingL = 0xFF; // underflow niskog bajta -> pozajmi od visokog
        if (RemainingH > 0)
          RemainingH--;
=======
void transmit(unsigned char DATA8b) {

  TXREG = DATA8b;
  while (!TXSTA.TRMT) // cekaj dok se shift registar ne isprazni
    ;
}

void DecodeTime() {
  Seconds = (Sec_X10 << 4) + Sec_X1;
  Minutes = (Min_X10 << 4) + Min_X1;
  Hours = (Hour_X10 << 4) + Hour_X1;
}

void ProcessInputs() {

  // Taster (PORTB.F0) - manual mode
  TMP_Taster2 = TMP_Taster1;
  if (PinTaster == 1)
    TMP_Taster1 = 1;
  else
    TMP_Taster1 = 0;
  if ((TMP_Taster2 == 0) && (TMP_Taster1 == 1)) {
    if (ManualMode == 1)
      ManualMode = 0;
    else
      ManualMode = 1;
    ManualEvent = 1; // consumed by main
  }

  // Reset (PORTB.F2) - reset. sta reci.
  TMP_Reset2 = TMP_Reset1;
  if (PinReset == 1) {
    TMP_Reset1 = 1;
  } else {
    TMP_Reset1 = 0;
  }
  if ((TMP_Reset2 == 0) && (TMP_Reset1 == 1)) {
    ResetEvent = 1; // consumed by main
  }
}

unsigned char buildStatusByte() { // SWAM system, watering, alarm, manual
                                  // -system on je samo za struju prakticno.
  unsigned char status = 0x00;
  if (PinSystemOn)
    status |= STATUS_SYSTEM_BIT;
  if (PinWatering)
    status |= STATUS_WATER_BIT;
  if (PinAlarm)
    status |= STATUS_ALARM_BIT;
  if (ManualMode)
    status |= STATUS_MANUAL_BIT;
  return status;
}

// ezotericni kod za konverziju iz decimalnog u bcd
unsigned char toBcd(unsigned char val) {
  unsigned char tens;
  tens = 0;
  while (val > 9) {
    val -= 10;
    tens++;
  }
  return (tens << 4) | val;
}

void main() {
  init();
  init_variables();
  Lcd_Init();
  Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
  UpdateLCD();

  while (1) {

    // --- Reset: full stop ---
    if (ResetEvent == 1) {
      ResetEvent = 0;
      PinWatering = 0;
      PinSystemOn = 1;
      PinAlarm = 0;
      ManualMode = 0;
      ManualEvent = 0;
      WateringSec = 0;
    }

    // manual dugme , kao toggle radi
    if (ManualEvent == 1) {
      ManualEvent = 0;
      if (ManualMode == 1) {
        // zalivam  180s
        WateringSec = 180;
        PinWatering = 1;
        PinSystemOn = 1;
      } else {
        // gasi zalivanje, ali ne diraj program
        WateringSec = 0;
      }
    }

    if (UpdateLCDFlag == 1) {
      UpdateLCDFlag = 0;

      // Scheduled start: BCD compare, only at second 0 of the matching minute
      if ((PinWatering == 0) && (Seconds == 0x00) && (Hours == ProgStartHour) &&
          (Minutes == ProgStartMin)) {
        WateringSec = ((unsigned int)time_left_high << 8) | time_left_low;
        PinWatering = 1;
        PinSystemOn = 1;
>>>>>>> Stashed changes
      }
    }
  }

<<<<<<< Updated upstream
  // --- STATUS LED ---
  // Prosto: ako je sistem ukljucen, svetli. Ako nije, ne svetli.
  if (SystemOn == 1)
    PinStatusLED = 1;
  else
    PinStatusLED = 0;
}

//  Vecina posla se radi u prekidnoj rutini (tajmer + UART),
//  a main samo reaguje na flagove koje ISR postavi
void main() {
  init();
  Lcd_Init();
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Cmd(_LCD_CLEAR);

  // Procitaj slave ID odmah na startu
  SLAVE_ID = PORTD & 0x0F;
  FlagDisp = 1; // odmah osvezi LCD

  while (1) {
    // Timeout za visebajtni prijem:
    // Ako smo zapoceli prijem paketa ali je Counter2 istekao
    // (nista nije stiglo duze vreme) -> resetuj na IDLE
    // Ovo stiti od zaglavljenja ako se komunikacija prekine na pola
    if ((byteId != BYTE_ID_IDLE) && (Counter2 == 0))
      byteId = BYTE_ID_IDLE;

    // Osvezavanje LCD-a kad ISR postavi flag (svake sekunde)
    if (FlagDisp == 1) {
      FlagDisp = 0;
      UpdateLCD();
    }

    // Primeniti novo vreme ako je stigao kompletan RTC paket
    if (RTCSetupFlag == 1) {
      RTCSetupFlag = 0;
      // Prebaci iz privremenog bafera u prave promenljive
=======
      // Countdown
      if (PinWatering == 1) {
        if (WateringSec > 0)
          WateringSec--;
        if (WateringSec == 0) {
          PinWatering = 0;
          PinSystemOn = 1;
          ManualMode = 0;
        }
      }

      FlowValue = ReadADC();
      if (PinWatering == 1) {
        if ((FlowValue < FlowMin) || (FlowValue > FlowMax))
          PinAlarm = 1;
        else
          PinAlarm = 0;
      } else {
        PinAlarm = 0;
      }
      UpdateLCD();
    }

    if ((ByteID > 0) && (Counter2 == 0)) {
      ByteID = 0;
    }
    if (CallFlag == 1) {
      // Poll response
      DR = 1;
      transmit(STATUS_CODE | GARDEN_ID);
      transmit(buildStatusByte());
      DR = 0;
      CallFlag = 0;
    }
    if (RTCSetupFlag == 1) {
>>>>>>> Stashed changes
      Sec_X1 = Tmp_Sec_X1;
      Sec_X10 = Tmp_Sec_X10;
      Min_X1 = Tmp_Min_X1;
      Min_X10 = Tmp_Min_X10;
      Hour_X1 = Tmp_Hour_X1;
      Hour_X10 = Tmp_Hour_X10;
<<<<<<< Updated upstream

      SendStatus(); // potvrdi Masteru da smo primili
    }

    // Primeniti novi program zalivanja ako je stigao kompletan paket
    if (ProgSetupFlag == 1) {
      ProgSetupFlag = 0;
      ProgramMode = Tmp_ProgramMode;
      ProgStartHour = Tmp_ProgStartHour;
      ProgStartMin = Tmp_ProgStartMin;
      ProgDurationH = Tmp_ProgDurationH;
      ProgDurationL = Tmp_ProgDurationL;

      // Ako je program != 0, aktiviraj sistem; inace ugasi
      if (ProgramMode != 0)
        SystemOn = 1;
      else
        SystemOn = 0;

      SendStatus(); // potvrdi Masteru
    }
  }
}

void IncrementTime() {
  if (Sec_X1 >= 9) {
    Sec_X1 = 0;
    if (Sec_X10 >= 5) {
      Sec_X10 = 0;
      if (Min_X1 >= 9) {
        Min_X1 = 0;
        if (Min_X10 >= 5) {
          Min_X10 = 0;
          if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3))) {
            Hour_X1 = 0;
            if (Hour_X10 == 2)
              Hour_X10 = 0;
            else
              Hour_X10++;
          } else
            Hour_X1++;
        } else
          Min_X10++;
      } else
        Min_X1++;
    } else
      Sec_X10++;
  } else
    Sec_X1++;
}

// ============================================================
//  KONVERZIJA binarnog broja u dve BCD cifre
//  Ulaz: ch (npr. 14)
//  Izlaz: X10=1, X1=4
//  Klasicno oduzimanje desetica dok ne ostane < 10
// ============================================================
void ConvertTime(unsigned char ch) {
  X1 = ch;
  X10 = 0x00;
  while (X1 > 9) {
    X1 = X1 - 10;
    X10++;
  }
}

// ============================================================
//  POMOCNE ZA LCD PRIKAZ
// ============================================================

// Pretvara nibble (0-F) u ASCII karakter za hex prikaz
unsigned char HexDigit(unsigned char val) {
  val = val & 0x0F;
  if (val < 10)
    return val + '0';
  return val + 'A' - 10;
}

// Ispise bajt u hex formatu na LCD (2 karaktera, npr. "3F")
void LcdByteHex(unsigned char row, unsigned char col, unsigned char val) {
  Lcd_Chr(row, col, HexDigit(val >> 4)); // visoki nibble
  Lcd_Chr(row, col + 1, HexDigit(val));  // niski nibble
}

// Ispise bajt kao dvocifreni decimalni broj na LCD (npr. "07", "23")
// Radi isto kao ConvertTime samo lokalno i odmah pise na LCD
void LcdByteDec2(unsigned char row, unsigned char col, unsigned char val) {
  unsigned char ones;
  unsigned char tens = 0x00;
  ones = val;
  while (ones > 9) {
    ones = ones - 10;
    tens++;
  }
  Lcd_Chr(row, col, tens + '0');
  Lcd_Chr(row, col + 1, ones + '0');
}

//  PREKIDNA RUTINA (ISR)
//  Dva izvora prekida:
//    1. Timer1 - tikuje svakih 100ms, svaki 10. tik = 1 sekunda
//    2. UART RX - prijem bajtova sa RS485 magistrale
//
void interrupt() {
  if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1)) {
    PIR1.TMR1IF = 0; // obavezno ocisti flag

    if (Counter == 9) {
      Counter = 0;
      IncrementTime(); // inkrementiraj softverski sat
      DecodeTime();
      ProcessInputs(); // sva logika sistema se vrti ovde
      FlagDisp = 1;    // kazi main-u da osvezi LCD
    } else
      Counter++;

    // Timeout za komunikaciju - svaki tik smanjujemo
    // Ako padne na 0 a nismo zavrsili prijem -> main ce resetovati
    if (Counter2 > 0)
      Counter2--;
    else
      Counter2 = 0; // ne moze ispod nule, unsigned je ali za svaki slucaj

    // Resetuj Timer1 na pocetnu vrednost za sledecih 100ms
    TMR1H = 0x0B;
    TMR1L = 0xDC;
  }

  // (byteId) da pratimo koji bajt u paketu ocekujemo.
  // Protokol: prvi bajt je komandni (sadrzi tip + slave ID),
  // sledeci bajtovi su payload koji zavisi od tipa komande.
  if ((PIE1.RCIE) && (PIR1.RCIF)) {
    ch = RCREG; // procitaj primljeni bajt (i ocisti RCIF)
    PIR1.RCIF = 0;

    if (byteId == BYTE_ID_IDLE) {
      // Cekamo komandni bajt - proveri da li je adresiran nama
      if ((ch & CMD_ID_MASK) == SLAVE_ID) {
        // Jeste za nas! Pogledaj tip komande
        switch (ch & CMD_TYPE_MASK) {
        case RTC_CODE:
          // Master salje novo vreme: ocekujemo HH, MM, SS
          byteId = BYTE_ID_RTC_HOUR;
          Counter2 = RTC_BYTES; // timeout = 3 tikova (300ms)
          break;

        case MODE_CODE:
          // Master salje program zalivanja: 5 bajtova
          byteId = BYTE_ID_MODE_PROGRAM;
          Counter2 = MODE_BYTES; // timeout = 5 tikova (500ms)
          break;

        default:
          // Nepoznata komanda - ignorisi
          byteId = BYTE_ID_IDLE;
          break;
        }
      }
      // Ako nije za nas - ignorisemo, ostajemo u IDLE
    }

    //  MODE PAKET: prijem 5 payload bajtova
    // Redosled: PROGRAM -> START_HOUR -> START_MIN -> DURATION_H -> DURATION_L

    else if (byteId == BYTE_ID_MODE_PROGRAM) {
      // Bajt 1: mod programa (0=off, ostalo=on)
      byteId = BYTE_ID_MODE_START_HOUR;
      Tmp_ProgramMode = ch;
    } else if (byteId == BYTE_ID_MODE_START_HOUR) {
      // Bajt 2: sat pocetka (dolazi sa offsetom 0x30)
      byteId = BYTE_ID_MODE_START_MIN;
      ch = ch - 0x30;
      if (ch > 23)
        ch = 23; // zastita od gluposti
      Tmp_ProgStartHour = ch;
    } else if (byteId == BYTE_ID_MODE_START_MIN) {
      // Bajt 3: minut pocetka (offset 0x30)
      byteId = BYTE_ID_MODE_DURATION_H;
      ch = ch - 0x30;
      if (ch > 59)
        ch = 59;
      Tmp_ProgStartMin = ch;
    } else if (byteId == BYTE_ID_MODE_DURATION_H) {
      // Bajt 4: trajanje visoki bajt (raw, bez offseta)
      byteId = BYTE_ID_MODE_DURATION_L;
      Tmp_ProgDurationH = ch;
    } else if (byteId == BYTE_ID_MODE_DURATION_L) {
      // Bajt 5: trajanje niski bajt - POSLEDNJI, zavrsi prijem
      byteId = BYTE_ID_IDLE;
      Counter2 = 0;
      Tmp_ProgDurationL = ch;
      ProgSetupFlag = 1; // signaliziraj main-u da primeni
    }

    // RTC PAKET: prijem 3 payload bajta
    // Redosled: HOUR -> MIN -> SEC

    else if (byteId == BYTE_ID_RTC_HOUR) {
      // Bajt 1: sat (offset 0x30, konvertuj u BCD cifre)
      byteId = BYTE_ID_RTC_MIN;
      ch = ch - 0x30;
      if (ch > 23)
        ch = 23;
      ConvertTime(ch);
      Tmp_Hour_X1 = X1;
      Tmp_Hour_X10 = X10;
    } else if (byteId == BYTE_ID_RTC_MIN) {
      // Bajt 2: minut (offset 0x30, konvertuj u BCD)
      byteId = BYTE_ID_RTC_SEC;
      ch = ch - 0x30;
      if (ch > 59)
        ch = 59;
      ConvertTime(ch);
      Tmp_Min_X1 = X1;
      Tmp_Min_X10 = X10;
    } else if (byteId == BYTE_ID_RTC_SEC) {
      // Bajt 3: sekunda - POSLEDNJI, zavrsi prijem
      byteId = BYTE_ID_IDLE;
      Counter2 = 0;
      ch = ch - 0x30;
      if (ch > 59)
        ch = 59;
      ConvertTime(ch);
      Tmp_Sec_X1 = X1;
      Tmp_Sec_X10 = X10;
      RTCSetupFlag = 1; // signaliziraj main-u da primeni
    }
  }
}

//  LCD PRIKAZ
//
//  Red 1:  HH:MM:SS  HH:MM  P
//          ^^^^^^^^^  ^^^^^  ^
//          tekuce     start  P=pumpa radi
//          vreme      prog.
//
//  Red 2:  D:HHLL F:XX    A
//          ^^^^^^ ^^^^    ^
//          traj.  protok  A=alarm
//          (hex)  (hex)
//
//  Trajanje prikazuje preostalo vreme kad pumpa radi,
//  a programirano trajanje kad ne radi
void UpdateLCD() {
  unsigned char DispH = 0x00;
  unsigned char DispL = 0x00;

  // --- Red 1: tekuce vreme (pozicije 1-8) ---
  Lcd_Chr(1, 1, Hour_X10 + '0');
  Lcd_Chr(1, 2, Hour_X1 + '0');
  Lcd_Chr(1, 3, ':');
  Lcd_Chr(1, 4, Min_X10 + '0');
  Lcd_Chr(1, 5, Min_X1 + '0');
  Lcd_Chr(1, 6, ':');
  Lcd_Chr(1, 7, Sec_X10 + '0');
  Lcd_Chr(1, 8, Sec_X1 + '0');

  // --- Red 1: vreme pocetka programa (pozicije 11-15) ---
  Lcd_Chr(1, 9, ' ');
  Lcd_Chr(1, 10, ' ');
  LcdByteDec2(1, 11, ProgStartHour);
  Lcd_Chr(1, 13, ':');
  LcdByteDec2(1, 14, ProgStartMin);

  // --- Red 1, pozicija 16: indikator pumpe ---
  if (WateringActive == 1)
    Lcd_Chr(1, 16, 'P');
  else
    Lcd_Chr(1, 16, ' ');

  // --- Red 2: trajanje ---
  // Ako pumpa radi -> prikazujemo preostalo vreme
  // Ako ne radi -> prikazujemo ukupno programirano trajanje
  if (WateringActive == 1) {
    DispH = RemainingH;
    DispL = RemainingL;
  } else {
    DispH = ProgDurationH;
    DispL = ProgDurationL;
  }

  Lcd_Chr(2, 1, 'D');
  Lcd_Chr(2, 2, ':');
  LcdByteHex(2, 3, DispH); // visoki bajt u hex
  LcdByteHex(2, 5, DispL); // niski bajt u hex

  // --- Red 2: protok ---
  Lcd_Chr(2, 7, ' ');
  Lcd_Chr(2, 8, 'F');
  Lcd_Chr(2, 9, ':');
  LcdByteHex(2, 10, FlowValue); // ADC vrednost u hex

  Lcd_Out(2, 12, "    "); // ocisti sredinu

  // --- Red 2, pozicija 16: indikator alarma ---
  if (AlarmActive == 1)
    Lcd_Chr(2, 16, 'A');
  else
    Lcd_Chr(2, 16, ' ');
}

//  FORMIRANJE STATUS PORUKE (Slave -> Master)
//  Pakuje stanje sistema u 2 bajta po protokolu
//  BAJT1: STATUS_CODE | SLAVE_ID (identifikacija)
//  BAJT2: flagovi stanja (bit7=system, bit6=water, bit5=alarm, bit4=manual)
void Message_StoM() {
  BAJT1 = STATUS_CODE | SLAVE_ID;
  BAJT2 = 0x00;

  if (SystemOn == 1)
    BAJT2 = BAJT2 | STATUS_SYSTEM_BIT;
  if (WateringActive == 1)
    BAJT2 = BAJT2 | STATUS_WATER_BIT;
  if (AlarmActive == 1)
    BAJT2 = BAJT2 | STATUS_ALARM_BIT;
  if (ManualMode == 1)
    BAJT2 = BAJT2 | STATUS_MANUAL_BIT;
}

//  SLANJE STATUSA NAZAD MASTERU
//  Prebaci RS485 na TX, posalji 2 bajta, vrati na RX
void SendStatus() {
  Message_StoM();
  DR = 1;          // RS485 na transmit mod
  transmit(BAJT1); // posalji identifikacioni bajt
  transmit(BAJT2); // posalji flagove
  DR = 0;          // vrati na receive mod
}

void init() {
  // --- Smerovi portova ---
  // TRISA: RA0-RA1 ulazi (ADC + nesto), RA2-RA4 izlazi (LED, pump, alarm)
  TRISA = 0x03;
  // TRISB: svi ulazi (taster na RB0, ostali neiskorisceni)
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
  // Fosc/32, kanal AN0, ADC ukljucen
  ADCON0 = 0b10000001;

  // --- Prekidi ---
  // GIE=1, PEIE=1 (omoguci globalne i periferne prekide)
  INTCON = 0b11000000;
  PIE1 = 0b00000000; // za sad sve onemoguceno, palimo pojedinacno dole

  // --- Timer1 ---
  // NE DIRAJ !!!!
  T1CON = 0b00110000;
  // Pocetna vrednost za 100ms interval
  // (0x10000 - 0x0BDC = 0xF424 = 62500 tikova)
  // 62500 * 8(preskaler) * 4(instrukcijski ciklus) * 50ns(20MHz) = 100ms
  TMR1H = 0x0B;
  TMR1L = 0xDC;
  T1CON.TMR1ON = 1; // pokreni timer
  PIR1.TMR1IF = 0;  // ocisti flag za svaki slucaj
  PIE1.TMR1IE = 1;  // omoguci Timer1 prekid

  Uart1_Init(UART_BAUD_RATE);
  TXSTA.TXEN = 1;
  RCSTA.SPEN = 1;
  RCSTA.CREN = 1;
  PIE1.RCIE = 1;

  // Konacno - pusti prekide da rade
  INTCON.GIE = 1;
=======
      DR = 1;
      transmit(STATUS_CODE | GARDEN_ID);
      transmit(buildStatusByte());
      RTCSetupFlag = 0;
      DR = 0;
    }
    if (ProgramSetupFlag == 1) {
      ProgStartHour = toBcd(Tmp_ProgStartHour);
      ProgStartMin = toBcd(Tmp_ProgStartMin);
      time_left_high = Tmp_time_left_high;
      time_left_low = Tmp_time_left_low;

      DR = 1;
      transmit(STATUS_CODE | GARDEN_ID);
      transmit(buildStatusByte());
      ProgramSetupFlag = 0;
      DR = 0;
    }
  }
}

void IncrementTime() {
  if (Sec_X1 >= 9) {
    Sec_X1 = 0;
    if (Sec_X10 >= 5) {
      Sec_X10 = 0;
      /////////
      if (Min_X1 >= 9) {
        Min_X1 = 0;
        if (Min_X10 >= 5) {
          Min_X10 = 0;
          /////////
          if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3))) {
            Hour_X1 = 0;
            if (Hour_X10 == 2) {
              Hour_X10 = 0;
            } else
              Hour_X10++;
          } else
            Hour_X1++;
          /////////
        } else
          Min_X10++;
      } else
        Min_X1++;
      /////////
    } else
      Sec_X10++;
  } else
    Sec_X1++;
}

void ConvertTime(unsigned char ch) {
  X1 = ch;
  X10 = 0x00;
  while (X1 > 9) {
    X1 = X1 - 10;
    X10++;
  }
}

void interrupt() {
  if ((PIE1.TMR1IE) && (PIR1.TMR1IF)) {
    // prekid tajmera na svakih 100ms
    PIR1.TMR1IF = 0; // brise se flag

    if (Counter == 9) {
      Counter = 0;
      IncrementTime();
      DecodeTime();
      UpdateLCDFlag = 1;
    } else
      Counter++;

    if (Counter2 > 0)
      Counter2--;
    else
      Counter2 = 0;

    ProcessInputs();

    TMR1H = 0x0B; // startne vrednosti tajmera 1
    TMR1L = 0xDC;
  }

  if ((PIE1.RCIE) && (PIR1.RCIF)) {
    ch = RCREG;
    if (ByteID == 0x00) {
      if ((ch & RTC_BROADCAST) == RTC_BROADCAST) {
        // primljeni bajt je komanda za
        // podesavanje sata realnog vremena
        ByteID = 0x03;
        Counter2 = 3;
        // 300 ms je vreme tokom kojeg
        // trebaju da stignu preostali bajtovi
      } else if ((ch & CMD_ID_MASK) == GARDEN_ID) {
        // adresa slejva se poklapa
        Command = ch;
        if ((ch & CMD_TYPE_MASK) == STATUS_CODE) {
          // primljeni bajt je bajt prozivke
          ByteID = 0x00;
          CallFlag = 1;
        } else if ((ch & CMD_TYPE_MASK) == 0xA0) {
          ByteID = 0x08;
          Counter2 = 6;
        }
      }

    } else if (ByteID == 0x03) {
      ConvertTime(ch);
      Tmp_Hour_X1 = X1;
      Tmp_Hour_X10 = X10;
      ByteID = 0x02;
    } else if (ByteID == 0x02) {
      ConvertTime(ch);
      Tmp_Min_X1 = X1;
      Tmp_Min_X10 = X10;
      ByteID = 0x01;
    } else if (ByteID == 0x01) {
      ConvertTime(ch);
      Tmp_Sec_X1 = X1;
      Tmp_Sec_X10 = X10;
      ByteID = 0x00;
      RTCSetupFlag = 1;
    }
    // ovi bajtovi sluze za program. kada sa web terminala stigne komanda u
    // formatu HH MM SS - SS
    else if (ByteID == 0x08) {
      Tmp_ProgStartHour = ch;
      ByteID = 0x07;
    } else if (ByteID == 0x07) {
      Tmp_ProgStartMin = ch;
      ByteID = 0x06;
    } else if (ByteID == 0x06) {
      Tmp_time_left_high = ch;
      ByteID = 0x05;
    } else if (ByteID == 0x05) {
      Tmp_time_left_low = ch;
      ByteID = 0x00;
      ProgramSetupFlag = 1;
    }
  }
}

void UpdateLCD() {
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
  ByteToStr(FlowValue, buf);
  Lcd_Out(1, 14, buf);

  // Row 2: S:X W:X A:X M:X
  Lcd_Out(2, 1, "S:");
  if (PinSystemOn)
    Lcd_Chr(2, 3, '1');
  else
    Lcd_Chr(2, 3, '0');
  Lcd_Out(2, 5, "W:");
  if (PinWatering)
    Lcd_Chr(2, 7, '1');
  else
    Lcd_Chr(2, 7, '0');
  Lcd_Out(2, 9, "A:");
  if (PinAlarm)
    Lcd_Chr(2, 11, '1');
  else
    Lcd_Chr(2, 11, '0');
  Lcd_Out(2, 13, "M:");
  if (ManualMode)
    Lcd_Chr(2, 15, '1');
  else
    Lcd_Chr(2, 15, '0');
}

void init() {

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
>>>>>>> Stashed changes
}
