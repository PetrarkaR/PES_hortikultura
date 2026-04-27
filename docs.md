# Protokol

Slave ID = 4bit val


Slave -> Master

1. Status poll
001X - SLAVE ID + 1 byte (zapravo poruka o statusu)

SWAM 0000
SystemOn
Watering
Alarm
Manual

Master -> Slave
2. RTC setup
Isto kao s prez

011X - SLAVE ID + 3 bytea(H,M,S)

3. Program setup + 5 bytea(H,M,S,sekunde trajanja programa)

101x-SLAVE ID

4. Biranje baste + 2 bytea

/b xx yy
100x- SLAVE ID

5. Control + 1 byte

011x - SLAVE ID 
kontrolni bajt moze da bude 0x01 za paljenje ili 0x00 za gasenje. ili ista vrednost koja radi kao toggle on - off