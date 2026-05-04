
_init_variables:

;Master.c,79 :: 		void init_variables() {
;Master.c,80 :: 		no_ch = 0x00;
	CLRF        _no_ch+0 
;Master.c,81 :: 		OBB = 0x00;
	CLRF        _OBB+0 
;Master.c,82 :: 		Flag1 = 0x00;
	CLRF        _Flag1+0 
;Master.c,83 :: 		Flag2 = 0x00;
	CLRF        _Flag2+0 
;Master.c,84 :: 		Flag3 = 0x00;
	CLRF        _Flag3+0 
;Master.c,86 :: 		SLAVE_ID = 0x0F;
	MOVLW       15
	MOVWF       _SLAVE_ID+0 
;Master.c,87 :: 		for (i = 0; i < 16; i++) {
	CLRF        _i+0 
L_init_variables0:
	MOVLW       16
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_init_variables1
;Master.c,88 :: 		Mode[i] = 0x00;
	MOVLW       _Mode+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Mode+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,89 :: 		Comm[i] = 0x00;
	MOVLW       _Comm+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,90 :: 		Hour[i] = 0x00;
	MOVLW       _Hour+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Hour+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,91 :: 		Min[i] = 0x00;
	MOVLW       _Min+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Min+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,92 :: 		Sec[i] = 0x00;
	MOVLW       _Sec+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Sec+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,87 :: 		for (i = 0; i < 16; i++) {
	INCF        _i+0, 1 
;Master.c,93 :: 		}
	GOTO        L_init_variables0
L_init_variables1:
;Master.c,94 :: 		}
	RETURN      0
; end of _init_variables

_init:

;Master.c,96 :: 		void init() {
;Master.c,98 :: 		PIR1 = 0b00000000; // flegovi prijema preko UART-a
	CLRF        PIR1+0 
;Master.c,99 :: 		PIE1 = 0b00100001; // dozvola prekida za UART, RCIE, TMR1IE
	MOVLW       33
	MOVWF       PIE1+0 
;Master.c,103 :: 		T1CON = 0b10110000; // konfiguracija za tajmer1
	MOVLW       176
	MOVWF       T1CON+0 
;Master.c,104 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;Master.c,110 :: 		TMR1L = 0xB5;
	MOVLW       181
	MOVWF       TMR1L+0 
;Master.c,111 :: 		TMR1H = 0xB3;
	MOVLW       179
	MOVWF       TMR1H+0 
;Master.c,113 :: 		INTCON = 0b01000000; // periferijski interapt
	MOVLW       64
	MOVWF       INTCON+0 
;Master.c,114 :: 		INTCON.GIE = 1;      // globalna dozvola prekida
	BSF         INTCON+0, 7 
;Master.c,117 :: 		TRISA = 0x00;
	CLRF        TRISA+0 
;Master.c,120 :: 		TRISB = 0x0F; // ostali pinovi PORTB su izlazi
	MOVLW       15
	MOVWF       TRISB+0 
;Master.c,121 :: 		TRISC = 0xD0; // 0b11010000; // ovo je OK
	MOVLW       208
	MOVWF       TRISC+0 
;Master.c,123 :: 		PORTA = 0x00;
	CLRF        PORTA+0 
;Master.c,124 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;Master.c,125 :: 		PORTC = 0x00;
	CLRF        PORTC+0 
;Master.c,127 :: 		ADCON0 = 0x00; // iskljucujemo A/D konverziju
	CLRF        ADCON0+0 
;Master.c,128 :: 		ADCON1 = 0x0F; // svi digitalni
	MOVLW       15
	MOVWF       ADCON1+0 
;Master.c,131 :: 		UART1_Init(UART_BAUD_RATE);
	MOVLW       80
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Master.c,134 :: 		TXSTA.TXEN = 1;
	BSF         TXSTA+0, 5 
;Master.c,135 :: 		RCSTA.SPEN = 1;
	BSF         RCSTA+0, 7 
;Master.c,136 :: 		RCSTA.CREN = 1;
	BSF         RCSTA+0, 4 
;Master.c,137 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE,
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
;Master.c,138 :: 		_SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Master.c,139 :: 		SPI_Ethernet_Init(myMacAddr, myIpAddr, SPI_Ethernet_FULLDUPLEX);
	MOVLW       _myMacAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_mac+0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_mac+1 
	MOVLW       _myIpAddr+0
	MOVWF       FARG_SPI_Ethernet_Init_ip+0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FARG_SPI_Ethernet_Init_ip+1 
	MOVLW       1
	MOVWF       FARG_SPI_Ethernet_Init_fullDuplex+0 
	CALL        _SPI_Ethernet_Init+0, 0
;Master.c,143 :: 		}
	RETURN      0
; end of _init

_putConstString:

;Master.c,146 :: 		unsigned int putConstString(const char *s) {
;Master.c,147 :: 		unsigned int cnt = 0;
	CLRF        putConstString_cnt_L0+0 
	CLRF        putConstString_cnt_L0+1 
;Master.c,148 :: 		while (*s) {
L_putConstString3:
	MOVF        FARG_putConstString_s+0, 0 
	MOVWF       TBLPTRL 
	MOVF        FARG_putConstString_s+1, 0 
	MOVWF       TBLPTRH 
	MOVF        FARG_putConstString_s+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_putConstString4
;Master.c,149 :: 		SPI_Ethernet_putByte(*s++);
	MOVF        FARG_putConstString_s+0, 0 
	MOVWF       TBLPTRL 
	MOVF        FARG_putConstString_s+1, 0 
	MOVWF       TBLPTRH 
	MOVF        FARG_putConstString_s+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_SPI_Ethernet_putByte_v+0
	CALL        _SPI_Ethernet_putByte+0, 0
	MOVLW       1
	ADDWF       FARG_putConstString_s+0, 1 
	MOVLW       0
	ADDWFC      FARG_putConstString_s+1, 1 
	ADDWFC      FARG_putConstString_s+2, 1 
;Master.c,150 :: 		cnt++;
	INFSNZ      putConstString_cnt_L0+0, 1 
	INCF        putConstString_cnt_L0+1, 1 
;Master.c,151 :: 		}
	GOTO        L_putConstString3
L_putConstString4:
;Master.c,152 :: 		return (cnt);
	MOVF        putConstString_cnt_L0+0, 0 
	MOVWF       R0 
	MOVF        putConstString_cnt_L0+1, 0 
	MOVWF       R1 
;Master.c,153 :: 		}
	RETURN      0
; end of _putConstString

_putString:

;Master.c,154 :: 		unsigned int putString(char *s) {
;Master.c,155 :: 		unsigned int cnt = 0;
	CLRF        putString_cnt_L0+0 
	CLRF        putString_cnt_L0+1 
;Master.c,156 :: 		while (*s) {
L_putString5:
	MOVFF       FARG_putString_s+0, FSR0L
	MOVFF       FARG_putString_s+1, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_putString6
;Master.c,157 :: 		SPI_Ethernet_putByte(*s++);
	MOVFF       FARG_putString_s+0, FSR0L
	MOVFF       FARG_putString_s+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_SPI_Ethernet_putByte_v+0 
	CALL        _SPI_Ethernet_putByte+0, 0
	INFSNZ      FARG_putString_s+0, 1 
	INCF        FARG_putString_s+1, 1 
;Master.c,158 :: 		cnt++;
	INFSNZ      putString_cnt_L0+0, 1 
	INCF        putString_cnt_L0+1, 1 
;Master.c,159 :: 		}
	GOTO        L_putString5
L_putString6:
;Master.c,160 :: 		return (cnt);
	MOVF        putString_cnt_L0+0, 0 
	MOVWF       R0 
	MOVF        putString_cnt_L0+1, 0 
	MOVWF       R1 
;Master.c,161 :: 		}
	RETURN      0
; end of _putString

_appendBuffer:

;Master.c,162 :: 		void appendBuffer(char *p_ch) {
;Master.c,163 :: 		while ((*p_ch) != 0x00) {
L_appendBuffer7:
	MOVFF       FARG_appendBuffer_p_ch+0, FSR0L
	MOVFF       FARG_appendBuffer_p_ch+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_appendBuffer8
;Master.c,164 :: 		buffer[no_ch] = *p_ch;
	MOVLW       _buffer+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FSR1H 
	MOVF        _no_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVFF       FARG_appendBuffer_p_ch+0, FSR0L
	MOVFF       FARG_appendBuffer_p_ch+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Master.c,165 :: 		no_ch++;
	INCF        _no_ch+0, 1 
;Master.c,166 :: 		p_ch++;
	INFSNZ      FARG_appendBuffer_p_ch+0, 1 
	INCF        FARG_appendBuffer_p_ch+1, 1 
;Master.c,167 :: 		}
	GOTO        L_appendBuffer7
L_appendBuffer8:
;Master.c,168 :: 		}
	RETURN      0
; end of _appendBuffer

_formBuffer:

;Master.c,169 :: 		void formBuffer() {
;Master.c,170 :: 		unsigned char i = 0;
	CLRF        formBuffer_i_L0+0 
;Master.c,172 :: 		unsigned char StatusByte = 0x00;
	CLRF        formBuffer_StatusByte_L0+0 
;Master.c,173 :: 		no_ch = 0x00; // start of buffer
	CLRF        _no_ch+0 
;Master.c,176 :: 		for (i = 0; i < 16; i++) {
	CLRF        formBuffer_i_L0+0 
L_formBuffer9:
	MOVLW       16
	SUBWF       formBuffer_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_formBuffer10
;Master.c,177 :: 		if (Comm[i] == 1) { // samo slejvovi koji su se odazvali
	MOVLW       _Comm+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR0H 
	MOVF        formBuffer_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formBuffer12
;Master.c,178 :: 		appendBuffer("Basta: ");
	MOVLW       ?lstr1_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr1_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,179 :: 		ByteToStr(i, txt);
	MOVF        formBuffer_i_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       formBuffer_txt_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(formBuffer_txt_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;Master.c,180 :: 		appendBuffer(txt); // append broj baste
	MOVLW       formBuffer_txt_L0+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(formBuffer_txt_L0+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,181 :: 		appendBuffer(" ");
	MOVLW       ?lstr2_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr2_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,182 :: 		StatusByte = Status1[i];
	MOVLW       _Status1+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Status1+0)
	MOVWF       FSR0H 
	MOVF        formBuffer_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       formBuffer_StatusByte_L0+0 
;Master.c,183 :: 		if (!(StatusByte & STATUS_SYSTEM_BIT)) {
	BTFSC       R1, 7 
	GOTO        L_formBuffer13
;Master.c,184 :: 		appendBuffer("OFF\n\n");
	MOVLW       ?lstr3_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr3_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,185 :: 		} else if (StatusByte & STATUS_WATER_BIT) {
	GOTO        L_formBuffer14
L_formBuffer13:
	BTFSS       formBuffer_StatusByte_L0+0, 6 
	GOTO        L_formBuffer15
;Master.c,186 :: 		if (StatusByte & STATUS_MANUAL_BIT) {
	BTFSS       formBuffer_StatusByte_L0+0, 4 
	GOTO        L_formBuffer16
;Master.c,187 :: 		appendBuffer("Watering(Manual_Mode)\n\n");
	MOVLW       ?lstr4_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr4_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,188 :: 		} else {
	GOTO        L_formBuffer17
L_formBuffer16:
;Master.c,189 :: 		appendBuffer("Watering(Automatic_Mode)\n\n");
	MOVLW       ?lstr5_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr5_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,190 :: 		}
L_formBuffer17:
;Master.c,191 :: 		} else if (StatusByte & STATUS_ALARM_BIT) {
	GOTO        L_formBuffer18
L_formBuffer15:
	BTFSS       formBuffer_StatusByte_L0+0, 5 
	GOTO        L_formBuffer19
;Master.c,192 :: 		appendBuffer("ALARM ON\n\n");
	MOVLW       ?lstr6_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr6_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,193 :: 		} else {
	GOTO        L_formBuffer20
L_formBuffer19:
;Master.c,194 :: 		appendBuffer("IDLE\n\n");
	MOVLW       ?lstr7_Master+0
	MOVWF       FARG_appendBuffer_p_ch+0 
	MOVLW       hi_addr(?lstr7_Master+0)
	MOVWF       FARG_appendBuffer_p_ch+1 
	CALL        _appendBuffer+0, 0
;Master.c,195 :: 		}
L_formBuffer20:
L_formBuffer18:
L_formBuffer14:
;Master.c,196 :: 		}
L_formBuffer12:
;Master.c,176 :: 		for (i = 0; i < 16; i++) {
	INCF        formBuffer_i_L0+0, 1 
;Master.c,197 :: 		}
	GOTO        L_formBuffer9
L_formBuffer10:
;Master.c,198 :: 		buffer[no_ch] = 0x00;
	MOVLW       _buffer+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FSR1H 
	MOVF        _no_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,199 :: 		no_ch++;
	INCF        _no_ch+0, 1 
;Master.c,200 :: 		}
	RETURN      0
; end of _formBuffer

_SPI_Ethernet_UserUDP:

;Master.c,201 :: 		unsigned int SPI_Ethernet_UserUDP(unsigned char *remoteHost, unsigned int remotePort, unsigned int destPort, unsigned int reqLength, TEthPktFlags *flags){
;Master.c,202 :: 		return 0;}
	CLRF        R0 
	CLRF        R1 
	RETURN      0
; end of _SPI_Ethernet_UserUDP

_SPI_Ethernet_UserTCP:

;Master.c,206 :: 		unsigned int reqLength, char *canCloseTCP) {
;Master.c,207 :: 		unsigned int len = 0; // reply length
	CLRF        SPI_Ethernet_UserTCP_len_L0+0 
	CLRF        SPI_Ethernet_UserTCP_len_L0+1 
;Master.c,210 :: 		if (localPort != 80) {
	MOVLW       0
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP84
	MOVLW       80
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+0, 0 
L__SPI_Ethernet_UserTCP84:
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP21
;Master.c,211 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	RETURN      0
;Master.c,212 :: 		}
L_SPI_Ethernet_UserTCP21:
;Master.c,213 :: 		PORTA.F4 = 1;
	BSF         PORTA+0, 4 
;Master.c,214 :: 		for (i = 0; i < 15; i++) {
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP22:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP85
	MOVLW       15
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP85:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP23
;Master.c,215 :: 		getRequest[i] = SPI_Ethernet_getByte();
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FLOC__SPI_Ethernet_UserTCP+1 
	CALL        _SPI_Ethernet_getByte+0, 0
	MOVFF       FLOC__SPI_Ethernet_UserTCP+0, FSR1L
	MOVFF       FLOC__SPI_Ethernet_UserTCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Master.c,214 :: 		for (i = 0; i < 15; i++) {
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;Master.c,216 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP22
L_SPI_Ethernet_UserTCP23:
;Master.c,217 :: 		getRequest[i] = 0;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,219 :: 		if (memcmp(getRequest, httpMethod, 5)) {
	MOVLW       _getRequest+0
	MOVWF       FARG_memcmp_s1+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_memcmp_s1+1 
	MOVLW       _httpMethod+0
	MOVWF       FARG_memcmp_s2+0 
	MOVLW       hi_addr(_httpMethod+0)
	MOVWF       FARG_memcmp_s2+1 
	MOVLW       5
	MOVWF       FARG_memcmp_n+0 
	MOVLW       0
	MOVWF       FARG_memcmp_n+1 
	CALL        _memcmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP25
;Master.c,220 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	RETURN      0
;Master.c,221 :: 		}
L_SPI_Ethernet_UserTCP25:
;Master.c,222 :: 		if (getRequest[5] == 'r') { // RTC
	MOVF        _getRequest+5, 0 
	XORLW       114
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP26
;Master.c,224 :: 		Flag2 = 0x01;
	MOVLW       1
	MOVWF       _Flag2+0 
;Master.c,225 :: 		hours = getRequest[6];
	MOVF        _getRequest+6, 0 
	MOVWF       _hours+0 
;Master.c,226 :: 		minutes = getRequest[7];
	MOVF        _getRequest+7, 0 
	MOVWF       _minutes+0 
;Master.c,227 :: 		seconds = getRequest[8];
	MOVF        _getRequest+8, 0 
	MOVWF       _seconds+0 
;Master.c,228 :: 		} else if (getRequest[5] == 'b') { // basta
	GOTO        L_SPI_Ethernet_UserTCP27
L_SPI_Ethernet_UserTCP26:
	MOVF        _getRequest+5, 0 
	XORLW       98
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP28
;Master.c,229 :: 		flagGarden = 1;
	BSF         _flagGarden+0, BitPos(_flagGarden+0) 
;Master.c,230 :: 		TargetGarden = getRequest[6];
	MOVF        _getRequest+6, 0 
	MOVWF       _TargetGarden+0 
;Master.c,231 :: 		TargetGardenProgram = getRequest[7];
	MOVF        _getRequest+7, 0 
	MOVWF       _TargetGardenProgram+0 
;Master.c,232 :: 		} else if (getRequest[5] == 'p') { // Program
	GOTO        L_SPI_Ethernet_UserTCP29
L_SPI_Ethernet_UserTCP28:
	MOVF        _getRequest+5, 0 
	XORLW       112
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP30
;Master.c,233 :: 		flagMode = 1;
	BSF         _flagMode+0, BitPos(_flagMode+0) 
;Master.c,234 :: 		TargetMode = getRequest[6];
	MOVF        _getRequest+6, 0 
	MOVWF       _TargetMode+0 
;Master.c,235 :: 		ModeProgram = getRequest[7];
	MOVF        _getRequest+7, 0 
	MOVWF       _ModeProgram+0 
;Master.c,236 :: 		ModeStartHour = getRequest[8];
	MOVF        _getRequest+8, 0 
	MOVWF       _ModeStartHour+0 
;Master.c,237 :: 		ModeStartMin = getRequest[9];
	MOVF        _getRequest+9, 0 
	MOVWF       _ModeStartMin+0 
;Master.c,238 :: 		ModeStartSecH = getRequest[10];
	MOVF        _getRequest+10, 0 
	MOVWF       _ModeStartSecH+0 
;Master.c,239 :: 		ModeStartSecL = getRequest[11];
	MOVF        _getRequest+11, 0 
	MOVWF       _ModeStartSecL+0 
;Master.c,240 :: 		} else if (getRequest[5] == 'c') { // cXXFF XX=>targetSlave, FF=>on/off
	GOTO        L_SPI_Ethernet_UserTCP31
L_SPI_Ethernet_UserTCP30:
	MOVF        _getRequest+5, 0 
	XORLW       99
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP32
;Master.c,241 :: 		flagControl = 1;
	BSF         _flagControl+0, BitPos(_flagControl+0) 
;Master.c,242 :: 		TargetControl = getRequest[6];
	MOVF        _getRequest+6, 0 
	MOVWF       _TargetControl+0 
;Master.c,243 :: 		ControlByte = getRequest[7];
	MOVF        _getRequest+7, 0 
	MOVWF       _ControlByte+0 
;Master.c,244 :: 		}
L_SPI_Ethernet_UserTCP32:
L_SPI_Ethernet_UserTCP31:
L_SPI_Ethernet_UserTCP29:
L_SPI_Ethernet_UserTCP27:
;Master.c,246 :: 		if (len == 0) {
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP86
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
L__SPI_Ethernet_UserTCP86:
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP33
;Master.c,247 :: 		formBuffer();
	CALL        _formBuffer+0, 0
;Master.c,248 :: 		len = putConstString(httpHeader);
	MOVLW       _httpHeader+0
	MOVWF       FARG_putConstString_s+0 
	MOVLW       hi_addr(_httpHeader+0)
	MOVWF       FARG_putConstString_s+1 
	MOVLW       higher_addr(_httpHeader+0)
	MOVWF       FARG_putConstString_s+2 
	CALL        _putConstString+0, 0
	MOVF        R0, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+0 
	MOVF        R1, 0 
	MOVWF       SPI_Ethernet_UserTCP_len_L0+1 
;Master.c,249 :: 		len += putConstString(httpMimeTypeHTML);
	MOVLW       _httpMimeTypeHTML+0
	MOVWF       FARG_putConstString_s+0 
	MOVLW       hi_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_putConstString_s+1 
	MOVLW       higher_addr(_httpMimeTypeHTML+0)
	MOVWF       FARG_putConstString_s+2 
	CALL        _putConstString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;Master.c,250 :: 		len += putString(buffer);
	MOVLW       _buffer+0
	MOVWF       FARG_putString_s+0 
	MOVLW       hi_addr(_buffer+0)
	MOVWF       FARG_putString_s+1 
	CALL        _putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;Master.c,251 :: 		for (i = 0; i < 16; i++) {
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP34:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP87
	MOVLW       16
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP87:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP35
;Master.c,252 :: 		Comm[i] = 0x00;
	MOVLW       _Comm+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,253 :: 		Hour[i] = 0x00;
	MOVLW       _Hour+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Hour+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,254 :: 		Min[i] = 0x00;
	MOVLW       _Min+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Min+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,255 :: 		Sec[i] = 0x00;
	MOVLW       _Sec+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Sec+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,251 :: 		for (i = 0; i < 16; i++) {
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;Master.c,256 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP34
L_SPI_Ethernet_UserTCP35:
;Master.c,257 :: 		}
L_SPI_Ethernet_UserTCP33:
;Master.c,258 :: 		return len; // return to the library with the number of bytes to transmit
	MOVF        SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       R0 
	MOVF        SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       R1 
;Master.c,259 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserTCP

_transmit:

;Master.c,261 :: 		void transmit(unsigned char DATA8b) {
;Master.c,262 :: 		TXREG = DATA8b;
	MOVF        FARG_transmit_DATA8b+0, 0 
	MOVWF       TXREG+0 
;Master.c,263 :: 		while (!TXSTA.TRMT)
L_transmit37:
	BTFSC       TXSTA+0, 1 
	GOTO        L_transmit38
;Master.c,264 :: 		;
	GOTO        L_transmit37
L_transmit38:
;Master.c,265 :: 		}
	RETURN      0
; end of _transmit

_interrupt:

;Master.c,267 :: 		void interrupt() {
;Master.c,268 :: 		if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1)) {
	BTFSS       PIE1+0, 0 
	GOTO        L_interrupt41
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt41
L__interrupt80:
;Master.c,270 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;Master.c,271 :: 		if (brojac == 0x04) { // na svakih 125ms prozivka slejvova
	MOVF        _brojac+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt42
;Master.c,272 :: 		brojac = 0x00;
	CLRF        _brojac+0 
;Master.c,273 :: 		Flag1 = 0x01;
	MOVLW       1
	MOVWF       _Flag1+0 
;Master.c,274 :: 		} else {
	GOTO        L_interrupt43
L_interrupt42:
;Master.c,275 :: 		brojac++;
	INCF        _brojac+0, 1 
;Master.c,276 :: 		}
L_interrupt43:
;Master.c,277 :: 		TMR1L = 0xB5;
	MOVLW       181
	MOVWF       TMR1L+0 
;Master.c,278 :: 		TMR1H = 0xB3; // reset tajmera
	MOVLW       179
	MOVWF       TMR1H+0 
;Master.c,279 :: 		}
L_interrupt41:
;Master.c,281 :: 		if ((PIE1.RCIE) && (PIR1.RCIF)) { // UART RECIEVE FROM SLAVE
	BTFSS       PIE1+0, 5 
	GOTO        L_interrupt46
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt46
L__interrupt79:
;Master.c,283 :: 		PIR1.RCIF = 0; // Recieve flag na 0
	BCF         PIR1+0, 5 
;Master.c,284 :: 		ch = RCREG;    // prima se bajt preko UART-a
	MOVF        RCREG+0, 0 
	MOVWF       R2 
;Master.c,286 :: 		switch (OBB) {
	GOTO        L_interrupt47
;Master.c,287 :: 		case OBB_IDLE:
L_interrupt49:
;Master.c,288 :: 		break;
	GOTO        L_interrupt48
;Master.c,289 :: 		case OBB_CMD_BYTE:
L_interrupt50:
;Master.c,290 :: 		if ((ch & CMD_TYPE_MASK == STATUS_CODE)) {
	BTFSS       R2, 0 
	GOTO        L_interrupt51
;Master.c,291 :: 		if ((ch & CMD_ID_MASK) == SLAVE_ID) {
	MOVLW       15
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORWF       _SLAVE_ID+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt52
;Master.c,293 :: 		OBB = OBB_STATUS_BYTE;
	MOVLW       1
	MOVWF       _OBB+0 
;Master.c,294 :: 		} else {
	GOTO        L_interrupt53
L_interrupt52:
;Master.c,295 :: 		OBB = OBB_IDLE;
	CLRF        _OBB+0 
;Master.c,296 :: 		}
L_interrupt53:
;Master.c,297 :: 		} else {
	GOTO        L_interrupt54
L_interrupt51:
;Master.c,298 :: 		OBB = OBB_IDLE;
	CLRF        _OBB+0 
;Master.c,299 :: 		}
L_interrupt54:
;Master.c,300 :: 		break;
	GOTO        L_interrupt48
;Master.c,301 :: 		case OBB_STATUS_BYTE:
L_interrupt55:
;Master.c,302 :: 		Status1[SLAVE_ID] = ch; // SWAM0000
	MOVLW       _Status1+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Status1+0)
	MOVWF       FSR1H 
	MOVF        _SLAVE_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
;Master.c,303 :: 		OBB = OBB_IDLE;
	CLRF        _OBB+0 
;Master.c,304 :: 		break;
	GOTO        L_interrupt48
;Master.c,305 :: 		default:
L_interrupt56:
;Master.c,306 :: 		OBB = OBB_IDLE;
	CLRF        _OBB+0 
;Master.c,307 :: 		break;
	GOTO        L_interrupt48
;Master.c,308 :: 		}
L_interrupt47:
	MOVF        _OBB+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt49
	MOVF        _OBB+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt50
	MOVF        _OBB+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt55
	GOTO        L_interrupt56
L_interrupt48:
;Master.c,309 :: 		}
L_interrupt46:
;Master.c,310 :: 		}
L__interrupt88:
	RETFIE      1
; end of _interrupt

_main:

;Master.c,313 :: 		void main(void) {
;Master.c,317 :: 		init();
	CALL        _init+0, 0
;Master.c,318 :: 		init_variables();
	CALL        _init_variables+0, 0
;Master.c,320 :: 		while (1) {
L_main57:
;Master.c,321 :: 		SPI_Ethernet_doPacket();
	CALL        _SPI_Ethernet_doPacket+0, 0
;Master.c,322 :: 		if (FLag1 == 0x01) {
	MOVF        _Flag1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main59
;Master.c,323 :: 		Flag1 = 0x00;
	CLRF        _Flag1+0 
;Master.c,324 :: 		SLAVE_ID++;
	INCF        _SLAVE_ID+0, 1 
;Master.c,325 :: 		if (SLAVE_ID == 0x10) {
	MOVF        _SLAVE_ID+0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main60
;Master.c,326 :: 		SLAVE_ID = 0x00;
	CLRF        _SLAVE_ID+0 
;Master.c,327 :: 		PORTA.F4 = 1;
	BSF         PORTA+0, 4 
;Master.c,328 :: 		if (Flag3 == 0x01) {
	MOVF        _Flag3+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main61
;Master.c,329 :: 		Flag3 = 0x00;
	CLRF        _Flag3+0 
;Master.c,330 :: 		Flag2 = 0x00;
	CLRF        _Flag2+0 
;Master.c,331 :: 		} else if (Flag2 == 0x01) {
	GOTO        L_main62
L_main61:
	MOVF        _Flag2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main63
;Master.c,332 :: 		Flag3 = 0x01;
	MOVLW       1
	MOVWF       _Flag3+0 
;Master.c,333 :: 		}
L_main63:
L_main62:
;Master.c,334 :: 		} // svi slejovi pollovani
	GOTO        L_main64
L_main60:
;Master.c,336 :: 		PORTA.F4 = 0;
	BCF         PORTA+0, 4 
;Master.c,337 :: 		}
L_main64:
;Master.c,343 :: 		if ((flagControl == 1) && (TargetControl == SLAVE_ID)) {
	BTFSS       _flagControl+0, BitPos(_flagControl+0) 
	GOTO        L_main67
	MOVF        _TargetControl+0, 0 
	XORWF       _SLAVE_ID+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main67
L__main83:
;Master.c,344 :: 		DR = 1; // we send
	BSF         PORTA+0, 5 
;Master.c,345 :: 		transmit(CONTROL_CODE | SLAVE_ID);
	MOVLW       192
	IORWF       _SLAVE_ID+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,346 :: 		transmit(ControlByte);
	MOVF        _ControlByte+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,347 :: 		DR = 0;             // we stop sending
	BCF         PORTA+0, 5 
;Master.c,348 :: 		flagControl = 0;    // clear
	BCF         _flagControl+0, BitPos(_flagControl+0) 
;Master.c,349 :: 		OBB = OBB_CMD_BYTE; // ocekujem response
	MOVLW       2
	MOVWF       _OBB+0 
;Master.c,350 :: 		} else if (Flag3 == 0x01) {
	GOTO        L_main68
L_main67:
	MOVF        _Flag3+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main69
;Master.c,351 :: 		DR = 1;
	BSF         PORTA+0, 5 
;Master.c,352 :: 		transmit(RTC_CODE | SLAVE_ID);
	MOVLW       96
	IORWF       _SLAVE_ID+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,353 :: 		transmit(hours);
	MOVF        _hours+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,354 :: 		transmit(minutes);
	MOVF        _minutes+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,355 :: 		transmit(seconds);
	MOVF        _seconds+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,356 :: 		DR = 0;
	BCF         PORTA+0, 5 
;Master.c,357 :: 		Flag3 = 0x00;
	CLRF        _Flag3+0 
;Master.c,358 :: 		OBB = OBB_CMD_BYTE; // ocekujem response
	MOVLW       2
	MOVWF       _OBB+0 
;Master.c,359 :: 		} else if ((flagMode == 1) && TargetMode == SLAVE_ID) {
	GOTO        L_main70
L_main69:
	BTFSS       _flagMode+0, BitPos(_flagMode+0) 
	GOTO        L_main73
	MOVF        _TargetMode+0, 0 
	XORWF       _SLAVE_ID+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main73
L__main82:
;Master.c,360 :: 		DR = 1;
	BSF         PORTA+0, 5 
;Master.c,361 :: 		transmit(MODE_CODE | SLAVE_ID);
	MOVLW       160
	IORWF       _SLAVE_ID+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,362 :: 		transmit(ModeProgram);
	MOVF        _ModeProgram+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,363 :: 		transmit(ModeStartHour);
	MOVF        _ModeStartHour+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,364 :: 		transmit(ModeStartMin);
	MOVF        _ModeStartMin+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,365 :: 		transmit(ModeStartSecH);
	MOVF        _ModeStartSecH+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,366 :: 		transmit(ModeStartSecL);
	MOVF        _ModeStartSecL+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,367 :: 		DR = 0;
	BCF         PORTA+0, 5 
;Master.c,368 :: 		OBB = OBB_CMD_BYTE; // ocekujem response
	MOVLW       2
	MOVWF       _OBB+0 
;Master.c,369 :: 		flagMode = 0;
	BCF         _flagMode+0, BitPos(_flagMode+0) 
;Master.c,370 :: 		} else if ((flagGarden == 1) && TargetGarden == SLAVE_ID) {
	GOTO        L_main74
L_main73:
	BTFSS       _flagGarden+0, BitPos(_flagGarden+0) 
	GOTO        L_main77
	MOVF        _TargetGarden+0, 0 
	XORWF       _SLAVE_ID+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_main77
L__main81:
;Master.c,371 :: 		DR = 1;
	BSF         PORTA+0, 5 
;Master.c,372 :: 		transmit(GARDEN_CODE | SLAVE_ID);
	MOVLW       128
	IORWF       _SLAVE_ID+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,373 :: 		transmit(TargetGardenProgram);
	MOVF        _TargetGardenProgram+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,374 :: 		DR = 0;
	BCF         PORTA+0, 5 
;Master.c,375 :: 		OBB = OBB_CMD_BYTE; // ocekujem response
	MOVLW       2
	MOVWF       _OBB+0 
;Master.c,376 :: 		flagGarden = 0;
	BCF         _flagGarden+0, BitPos(_flagGarden+0) 
;Master.c,377 :: 		} else {
	GOTO        L_main78
L_main77:
;Master.c,378 :: 		DR = 1;
	BSF         PORTA+0, 5 
;Master.c,379 :: 		transmit(STATUS_CODE | SLAVE_ID);
	MOVLW       32
	IORWF       _SLAVE_ID+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,380 :: 		OBB = OBB_CMD_BYTE;
	MOVLW       2
	MOVWF       _OBB+0 
;Master.c,381 :: 		}
L_main78:
L_main74:
L_main70:
L_main68:
;Master.c,382 :: 		}
L_main59:
;Master.c,383 :: 		}
	GOTO        L_main57
;Master.c,384 :: 		}
	GOTO        $+0
; end of _main
