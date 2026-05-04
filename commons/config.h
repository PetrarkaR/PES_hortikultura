#ifndef CONFIG_H
#define CONFIG_H

// Konfiguracioni fajl da bi izbegli hard coded values

// serijski prijem (UART) ================================
#define UART_BAUD_RATE 19200
// Protokol Master -> Slave:==============================
/*
 * ========================================================
 *RTC promenljive 011|x|idid| -> 0x60 + 3 Bytes HH|MM||SS
 *Biranje moda 101|x|idid| -> 0xA0 + 5 Bytes /pXX|HH|MM|SS|SS
 *Biranje baste 100|x|idid| -> 0x80 + 1 Byte /bXX|YY
 *Control 110|X|idid| -> 0xC0 +1 byte kontrolni za remote on/off |1111 1111|
 * /cXX|FF (ON)
 * ========================================================
 */
#define RTC_CODE 0x60
#define RTC_BYTES 3
#define MODE_CODE 0xA0
#define MODE_BYTES 5
#define GARDEN_CODE 0x80
#define GARDEN_BYTES 1
#define CONTROL_CODE 0xC0
#define CONTROL_BYTES 1
// Protokol Slave -> Master: ===============================
/*
 * Status 001|x|idid ->  0x20 + 1byte [SWAM 0000] -> SystemOn Watering Alarm
 * Mode
 * */
#define STATUS_CODE 0x20
#define STATUS_SYSTEM_BIT 0x80 // bit7
#define STATUS_WATER_BIT 0x40  // bit6
#define STATUS_ALARM_BIT 0x20  // bit5
#define STATUS_MANUAL_BIT 0x10 // bit4
// MASKE
#define CMD_TYPE_MASK 0xE0  // Top 3 command bits
#define CMD_ID_MASK 0x0F    // bottom 4 SLAVE ID bits
#define CMD_INOUT_MASK 0x10 // bit4
// ETHERNET
#define MAC_ADDR {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f}
#define IP_ADDR {10, 99, 12, 1}
#define HTTP_PORT 80
// OBB MasterRecieve
#define OBB_IDLE 0x00
#define OBB_CMD_BYTE 0x02
#define OBB_STATUS_BYTE 0x01
#endif
