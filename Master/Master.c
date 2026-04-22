#define SPI_Ethernet_HALFDUPLEX 0
#define SPI_Ethernet_FULLDUPLEX 1
#define DR PORTA.F5

typedef struct
{
   unsigned canCloseTCP : 1; // flag which closes socket
   unsigned isBroadcast : 1; // flag which denotes that the IP package has been received via subnet broadcast address (not used for PIC16 family)
} TEthPktFlags;

const unsigned char httpHeader[] = "HTTP/1.1 200 OK\nContent-type: "; // HTTP header
const unsigned char httpMimeTypeHTML[] = "text/html\n\n";             // HTML MIME type
const unsigned char httpMimeTypeScript[] = "text/plain\n\n";          // TEXT MIME type
unsigned char httpMethod[] = "GET /";

// mE ethernet NIC pinout
sfr sbit SPI_Ethernet_Rst at RA1_bit; //SPI_ETH_RST2?????
sfr sbit SPI_Ethernet_CS at RA0_bit;  //SPI_ETH_CS2??????
sfr sbit SPI_Ethernet_Rst_Direction at TRISA1_bit;
sfr sbit SPI_Ethernet_CS_Direction at TRISA0_bit;
// end ethernet NIC definitions
unsigned char myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f};
// jedinstvena MAC adresa uredaja
unsigned char myIpAddr[4] = {10, 99, 12, 1};
// IP adresa uredaja
unsigned char getRequest[15];  // HTTP request buffer
unsigned char dyna[31];        // buffer for dynamic response
unsigned long httpCounter = 0; // counter of HTTP requests

unsigned char i, brojac, RAMP_ID, Flag1, Flag2, Flag3, ch, OBB;
unsigned char niz[150];
unsigned char br_ch;
unsigned char seconds, minutes, hours;

// Lcd pinout settings
sbit LCD_RS at RC0_bit;
sbit LCD_RW at RC1_bit; // Dodao sam LCD_RW
sbit LCD_EN at RC2_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;
// Pin direction
sbit LCD_RS_Direction at TRISC0_bit;
sbit LCD_RW_Direction at TRISC1_bit; // Dodao sam LCD_RW
sbit LCD_EN_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;

unsigned char pom_ch, pom_des, pom_jed;
unsigned char pom_nula = 0x30;

// nizovi za pojedinacne rampe
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
   br_ch = 0; // pozicioniranje na pocetak niza

   for (i = 0; i < 16; i++)
   {
      if (Comm[i] == 1)
      {
         dodajUNiz("Ramp:");
         ByteToStr(i, txt);
         dodajUNiz(txt); // ID broj
         switch (Cmd[i])
         {
            // moze biti: NO:CARDS, IDLE, VEHICLE, TIME SET
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
         {                    // VEHICLE
            pom_nula = 0x30;  // asci 0
            pom_ch = Hour[i]; // ubacivanje sati
            pom_des = (pom_ch >> 4) + pom_nula;
            pom_jed = (pom_ch & 0x0F) + pom_nula;
            niz[br_ch] = pom_des;
            br_ch++;
            niz[br_ch] = pom_jed;
            br_ch++;
            niz[br_ch] = ':';
            br_ch++;

            pom_ch = Min[i]; // ubacivanje minuta
            pom_des = (pom_ch >> 4) + pom_nula;
            pom_jed = (pom_ch & 0x0F) + pom_nula;
            niz[br_ch] = pom_des;
            br_ch++;
            niz[br_ch] = pom_jed;
            br_ch++;
            niz[br_ch] = ':';
            br_ch++;

            pom_ch = Sec[i]; // ubacivanje sekundi
            pom_des = (pom_ch >> 4) + pom_nula;
            pom_jed = (pom_ch & 0x0F) + pom_nula;
            niz[br_ch] = pom_des;
            br_ch++;
            niz[br_ch] = pom_jed;
            br_ch++;
            niz[br_ch] = ' ';
            br_ch++;

            pom_ch = Cat[i]; // ubacivanje kategorije vozila
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
         } //if
      }    // if
   }       // for
   niz[br_ch] = 0x00;
   br_ch++; // kraj stringa
}

void interrupt()
{ // korisceni su prekid serijske komunikacije i  tajmera 1

   if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1))
   {
      // prekid tajmera 1 -  na svakih 25ms
      PIE1.TMR1IE = 1;
      PIR1.TMR1IF = 0;
      if (brojac == 0x04)
      { // na svakih 125ms proziva se po jedna rampa od 16
         brojac = 0x00;
         Flag1 = 0x01; // podize se flag koji nam govori da je doslo vreme da se prozove rampa, koristimo ga u Main funkciji
      }
      else
      {
         brojac++;
      }
      TMR1L = 0xB5;
      TMR1H = 0xB3;
   }

   if ((PIE1.RCIE) && (PIR1.RCIF))
   { // prekid zbog serijske komunikacije
      unsigned char ch;
      PIR1.RCIF = 0;
     
      ch = RCREG; //prima se bajt preko UART-a
      if (OBB != 0x00)
      {
         if (OBB == 0x05)
         {                     // prijem bajta komande, koja se dekodira, i onda se odreduje da li treba jo� da se primaju bajtovi
            Comm[RAMP_ID] = 1; // komunikacija je OK
            if ((ch & 0xE0) == 0x00)
            {
               OBB = 0x00;   // NO CARDS
               Cmd[RAMP_ID] = 3;
            }
            if ((ch & 0xE0) == 0x20)
               OBB = 0x00; // IDLE
            if ((ch & 0xE0) == 0x40)
            {
               OBB = 0x04;   // VEHICLE
               Cmd[RAMP_ID] = 1;
            }
            if ((ch & 0xE0) == 0x60)
            {
               OBB = 0x00;  // RTC
               Cmd[RAMP_ID] = 2;
            }
         }
         else
         {
            switch (OBB)
            {
               //   sekunde, minuti, sati i kategorija vozila koje je pro�lo
            case 4:
               Sec[RAMP_ID] = ch;
               break; //ch_sec=ch;
            case 3:
               Min[RAMP_ID] = ch;
               break; //ch_min=ch;
            case 2:
               Hour[RAMP_ID] = ch;
               break; //ch_hour=ch;
            case 1:
               Cat[RAMP_ID] = ch;
               break; //ch_cat=ch;
            default:
               break;
            }
            OBB--;
         }
      }
   } //  if ((PIE1.RCIE) && (PIR1.RCIF)){
} //void interrupt ()

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

   unsigned int len = 0; // my reply length
   unsigned int i;       // general purpose integer
   if (localPort != 80)
      return (0);
   PORTA.F4 = 1;
   // get 10 first bytes only of the request, the rest does not matter here
   for (i = 0; i < 10; i++)
      getRequest[i] = SPI_Ethernet_getByte();
   getRequest[i] = 0;

   if (memcmp(getRequest, httpMethod, 5))
      return (0);
   // only GET method is supported here

   if (getRequest[5] == 's')
   { //primio komandu za prozivanje slejvova "s"
      // s 0x3? 0x3? 0x3? 0x3?
      // 0x3? predstavlja ASCII karakter, (?  -  0, 1, 2, � , 9, A, B, C, D, E i F)
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

      } //  if (((getRequest[6]& 0xF0) ....
   }    // if (getRequest[5]==0x73)
   if (getRequest[5] == 'r')
   {
      // primio komandu za podesavanje RTC  "r"
      Flag2 = 0x01;
      // podize FLAG 2 za postavljanje sata realnog vremena
      seconds = getRequest[6]; //nova vrednost za sekunde
      minutes = getRequest[7]; // nova vrednost za minute
      hours = getRequest[8];   // nova vrednost za sate
   }
   if (len == 0)
   {
      FormirajNiz();
      len = putConstString(httpHeader); // HTTP header
      len += putConstString(httpMimeTypeHTML);
      len += putString(niz); // with HTML MIME type
      for (i = 0; i < 16; i++)
      { // inicijalizacija
         Comm[i] = 0x00;
         Cmd[i] = 0x00;
         Cat[i] = 0x00;
         Hour[i] = 0x00;
         Min[i] = 0x00;
         Sec[i] = 0x00;
      }
   }             //  if(len == 0)
   return (len); // return to the library with the number of bytes to transmit
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

   PIR1 = 0b00000000; // flegovi prijema preko UART-a
   PIE1 = 0b00100001; // dozvola prekida za UART, RCIE, TMR1IE
   //PIE1.TMR1IE = 1;
   //PIE1.RC1IE=1;

   T1CON = 0b10110000; // konfiguracija za tajmer1
   T1CON.TMR1ON = 1;
   // 16-bit operation
   // preskaler 1:8
   // 25MH T0=40ns
   // 40ns*4*8=1.28us
   // 25ms=25000us=1.28*19531=  B5B3
   TMR1L = 0xB5;
   TMR1H = 0xB3;

   INTCON = 0b01000000; // periferijski interapt
   INTCON.GIE = 1;      // globalna dozvola prekida

   // svi pinovi na portu A su izlazi (vidi na semi)
   TRISA = 0x00;
   // obrati paznju, postoje tasteri na portovima RB0 - RB3, to su digitalni ulazi
   TRISB = 0x0F; // ostali pinovi PORTB su izlazi
   TRISC = 0xD0; // 0b11010000; // ovo je OK

   PORTA = 0x00;
   PORTB = 0x00;
   PORTC = 0x00;

   ADCON0 = 0x00; // iskljucujemo A/D konverziju
   ADCON1 = 0x0F; // svi digitalni
   //PORTA.F0=0;

   UART1_Init(19200);
   // konfigurisemo brzinu od 19200 i dodatne bitove za serijski prenos
   TXSTA.TXEN = 1;
   RCSTA.SPEN = 1;
   RCSTA.CREN = 1;

   Lcd_Init();
   Lcd_Cmd(_LCD_CURSOR_OFF);
   UpdateLCD();

   SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
   SPI_Ethernet_Init(myMacAddr, myIpAddr, SPI_Ethernet_FULLDUPLEX); // inicijalizujemo Ethernet port
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
      {                //ovde se ulazi na svakih 125ms
         Flag1 = 0x00; // vratimo FLAG1 na nulu
         RAMP_ID++;    // biramo sledeci slejv
         if (RAMP_ID == 0x10)
         { //kada se prozovu svih 16 rampi onda se brojac rampi vrati na nulu
            RAMP_ID = 0x00;
            PORTA.F4 = 1; //pali se dioda na svake 2 sekunde, 16x125ms=2s
            if (Flag3 == 0x01)
            {
               Flag3 = 0x00;
               Flag2 = 0x00;
            }
            // FLAG 3 se postavlja na 0 ako se proziva rampa a na 1
            // ako se podesava sat realnog vremena
            else if (Flag2 == 0x01)
               Flag3 = 0x01;
            UpdateLCD();
         }
         else
            PORTA.F4 = 0;

         if (Flag3 == 0x00)
         { //salje se prozivka rampama
            DR = 1;
            if (Operation[RAMP_ID] == 0x01)
               ByteX = 0x30 + RAMP_ID;
            else
               ByteX = 0x20 + RAMP_ID;
            transmit(ByteX);
            DR = 0;
            OBB = 0x05; //OBB (ocekivani broj bajtova) postavlja se na 5,
            //sto znaci da sledeci bajt koji primamo predstavlja komandu
         } // if (Flag3==0x00
         else
         { //ovde se salje svim rampama zahtev za podesavanje vremena,
            DR = 1;
            ByteX = 0x70 + RAMP_ID;
            transmit(ByteX); // komandni
            transmit(seconds);
            transmit(minutes);
            transmit(hours);
            DR = 0;
            OBB = 0x05; // opet se OBB postavlja na 5 jer posle ovoga slede potvrde ispravnog pode�avanja sata
         }              //else
      }                 // od Flag1==1
   }                    // while (1)
}