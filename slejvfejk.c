#define senPoklopac PORTB.F4  // Prekidac - senzor poklopca
#define senVoda PORTB.F5      // Prekidac - senzor vode
#define pinTaster PORTB.F0       // Taster za promenu LCD-a


#define ledPoklopac PORTA.F2 // Svetlo da je aktiviran nadzor poklopca
#define ledVoda PORTA.F3 // Svetlo da je aktiviran nadzor vode
#define ledAlarm PORTA.F4 // Svetlo da se aktivirao alarm


#define DR PORTC.F5 // upravljanje RS485 drajverom

unsigned char Counter=0; // 0-255
unsigned char BrojSahte=0x00;
unsigned char counterd=0;
unsigned char counterDisp=0;
unsigned char ch=0x00;   // primljeni bajt
unsigned char poruka=0x00;
unsigned char komanda=0x00;


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



bit EnableVoda;
bit EnablePoklopac;
bit Voda;
bit Poklopac;
bit Alarm;
bit AlarmVoda;
bit AlarmPoklopac;
bit Flag;
bit Flag2;

void UpdateLCD();

void init(){

     // pinovi na portu A su digitalni izlazi;
     TRISA=0x00;
     // pinovi na portu B su  digitalni ulazi
     TRISB=0xFF;
     TRISC=0xC0;// pinovi 6 i 7 su vezani za RS232

     PORTA=0x00;
     PORTB=0x00;
     PORTC=0x00;

     ADCON0=0x00; //iskljucujemo A/D konverziju
     ADCON1=0b00000110; //svi digitalni pinovi

     INTCON = 0b11000000; // default
     PIE1 = 0b00000000; // default


     T1CON=0b00110000;   // konfiguracija za Tajmer 1
     // preskaler 1/8
     TMR1H = 0x0B;  // startne vrednosti tajmera 1
     TMR1L = 0xDC;
     T1CON.TMR1ON=1;

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
     TXSTA.TXEN=1;
     RCSTA.SPEN=1;
     RCSTA.CREN=1;
     PIE1.RCIE=1;

     INTCON.GIE=1;
     // globalna dozvola prekida
}

void init_var() {
  // promenljive EnableVoda i Enable Poklopac se programiraju preko mastera
   Poklopac=0;
   Voda=0;
   EnablePoklopac=1;
   EnableVoda=1;
   AlarmVoda=0;
   AlarmPoklopac=0;
   Alarm=0;
   Flag=0;
   Flag2=0;

}

void ProcessInputs(){
   if (senPoklopac==1)  {
        Poklopac=1;
        ledPoklopac=1;
   }
   else {
     Poklopac=0;
     ledPoklopac=0;
   }
   if ((EnablePoklopac==1)&&(Poklopac==1)) AlarmPoklopac=1;
   
   if  (EnablePoklopac==0)   AlarmPoklopac=0;
   
   if (senVoda==1)  {
        Voda=1;   // promenljiva
        ledVoda=1; // pali se dioda
   }
   else {
     Voda=0;
     ledVoda=0;
   }
   if ((EnableVoda==1)&&(Voda==1)) AlarmVoda=1;
   
   if  (EnableVoda==0)   AlarmVoda=0;
   
   if ((AlarmVoda==1)|| (AlarmPoklopac==1)) {
     Alarm=1;
     ledAlarm=1;
   }
   else {
     Alarm=0;
     ledAlarm=0;   
   }
}

void interrupt() {

   if ((PIE1.TMR1IE)&&(PIR1.TMR1IF)){
     // prekid tajmera na svakih 100ms
        PIR1.TMR1IF = 0; // brise se flag
        
        if (counterd>0) counterd--;
        
        if (counterd==0) {
           // dozvola za taster
           if (PORTB.F0==1) {  // taster pritisnut
           
                 counterd=5; // ponovo nse onemogucava dozvola za taster

                  // promena brojaca za displej
                  if  (counterDisp==2) counterDisp=0;
                  else counterDisp++;
                 
           
           }
        
        }

        if (Counter>=9) {
           Counter=0;
           Flag2 = 1; // prosla je 1sec
           
        }
        else Counter++;

        ProcessInputs();

        TMR1H = 0x0B;  // startne vrednosti tajmera 1
        TMR1L = 0xDC;
   }
   
   
    if ((PIE1.RCIE) && (PIR1.RCIF))  {
        PIR1.RCIF = 0;
        ch=RCREG;
                
                // BJ: M -> S samo jedan bajt komande, u kojem su prva dva bita "01", ostalo je EnP , EnV i r.b. sahte
                
        if (((ch&0x0F)== BrojSahte) && ((ch&0xC0)== 0x40)){ // Provera da li se adresa slejva poklapa i da li su prva dva bita "01"
              komanda = ch;

              if ((ch&0x10)==0x10)   // Provera da li je primljeni bajt EnableVoda=1
                  EnableVoda=1;
              else
                  EnableVoda=0;

               if ((ch&0x20)==0x20)    // Provera da li je primljeni bajt EnablePoklopac=1
                  EnablePoklopac=1;
               else
                  EnablePoklopac=0;
                           
              // BJ: ovo mora ovde, Flag se postavlja tek kada se primi komanda a ne bilo koji karakter
              // BJ: bila je greska
              Flag = 1;

         }
        
     }
}
void transmit(unsigned char DATA8b){

  TXREG = DATA8b;
  while (!TXSTA.TRMT);

}

void UpdateLCD(){
    if(counterDisp == 0){
          Lcd_Out(1, 1, "Voda           ");
          Lcd_Out(2, 1, "Poklopac       ");
           if(Voda == 1){
          Lcd_Chr(1,16,'1');
          }
          else {
           Lcd_Chr(1,16,'0');
          }
           if(Poklopac == 1){
          Lcd_Chr(2,16,'1');
          }
          else {
           Lcd_Chr(2,16,'0');
          }
     }
    else if(counterDisp==1){
          Lcd_Out(1, 1, "Enable Voda    ");
          Lcd_Out(2, 1, "Enable Pokl    ");
           if(EnableVoda == 1){
          Lcd_Chr(1,16,'1');
          }
          else {
           Lcd_Chr(1,16,'0');
          }
           if(EnablePoklopac == 1){
          Lcd_Chr(2,16,'1');
          }
          else {
           Lcd_Chr(2,16,'0');
          }
         }
    else if(counterDisp==2){
         Lcd_Out(1, 1, "Alarm Voda     ");
         Lcd_Out(2, 1, "Alarm Pokl     ");
          if(AlarmVoda == 1){
          Lcd_Chr(1,16,'1');
          }
          else {
           Lcd_Chr(1,16,'0');
          }
           if(AlarmPoklopac == 1){
          Lcd_Chr(2,16,'1');
          }
          else {
           Lcd_Chr(2,16,'0');
          }
         }
 }




void main() {
init_var();
init();
Lcd_Init();
Lcd_Cmd(_LCD_CURSOR_OFF);

while(1){
if(Flag2 == 1){
   UpdateLCD();
   
   if(Flag == 1){
     Flag = 0;
     poruka = 0x00;
     if(Poklopac == 1){
        poruka = poruka | 0x01;
      }
      if(Voda == 1){
        poruka = poruka | 0x02;
       }
      if(AlarmVoda == 1){
        poruka = poruka | 0x04;
      }
      if(AlarmPoklopac == 1){
        poruka = poruka | 0x08;
      }
      if(Alarm == 1){
        poruka = poruka | 0x10;
      }
      DR = 1;          
          // BJ:  S -> M prvo bajt komande, u kojem su prva dva bita "01", ostalo je EnP , EnV i r.b. sahte
      transmit(komanda);
          // BJ:  S -> M bajt poruke, 0, 0, 0, A, AlP, AlV, V, P          
          // Da bi ih master prepoznao, bajtovi moraju da se razlikuju bar u prva dva bita.
      transmit(poruka);
      DR = 0;
    }

 }

}
}