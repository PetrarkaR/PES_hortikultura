#ifndef CONFIG_H
#define CONFIG_H

// Konfiguracioni fajl da bi izbegli hard coded values
#define UART_BAUD_RATE 19200

// serijski prijem (UART)
//
// Protokol Master -> Slave:
/*
  RTC promenljive 011|x|idid| -> 0x60
  Biranje moda 101|x|idid -> 0xA0 + 5 Bytes /pXX|HH|MM|SS|SS
  Biranje baste 100|x|idid -> 0x80 + 2 bytes /bXX|YY
  Control 110|X|idid -> 0xC0 +1 byte kontrolni
*/
#define RTC_CODE 0x60
#define MODE_CODE 0xA0
#define GARDEN_CODE 0x80
#define CONTROL_CODE 0xC0
// Protokol Slave -> Master
/*
 * Status 001|x|idid ->  0x20 + 1byte [SWAM 0000] -> SystemOn Watering Alarm
 * Mode
 * */
#define STATUS_CODE 0x20
#endif
