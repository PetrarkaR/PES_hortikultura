#ifndef CONFIG_H
#define CONFIG_H

// Konfiguracioni fajl da bi izbegli hard coded values
#define UART_BAUD_RATE 19200

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
#define SLAVE_ON 0x20
#define RTC_SETUP 0x60
#define TROUGHPUT 0x80
#define MODE 0xA0
#define REMOTE_ON 0xC0
#define REMOTE OFF 0xE0

// SLAVE -> MASTER Protocol
#define SLAVE_POWER_OFF 0x00 // 0000
#define SLAVE_POWER_ON 0x20  // 0010
#define SLAVE_WATERING 0x40  // 0100
#define ALARM_EN 0x60        // 0110
#endif
