
_init_variables:

;Slave.c,115 :: 		void init_variables()
;Slave.c,118 :: 		GARDEN_ID = 0x00;
	CLRF       _GARDEN_ID+0
;Slave.c,120 :: 		TMP_Taster2 = 0;
	BCF        _TMP_Taster2+0, BitPos(_TMP_Taster2+0)
;Slave.c,121 :: 		TMP_Taster1 = 0;
	BCF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
;Slave.c,123 :: 		TMP_Reset2 = 0;
	BCF        _TMP_Reset2+0, BitPos(_TMP_Reset2+0)
;Slave.c,124 :: 		TMP_Reset1 = 0;
	BCF        _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
;Slave.c,126 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,127 :: 		ch = 0x00;
	CLRF       _ch+0
;Slave.c,128 :: 		Command = 0x00;
	CLRF       _Command+0
;Slave.c,129 :: 		CommandModified = 0x00;
	CLRF       _CommandModified+0
;Slave.c,130 :: 		Counter = 0x00;
	CLRF       _Counter+0
;Slave.c,131 :: 		Counter2 = 0x00;
	CLRF       _Counter2+0
;Slave.c,132 :: 		cntManual = 0x00;
	CLRF       _cntManual+0
;Slave.c,133 :: 		cntReset = 0x00;
	CLRF       _cntReset+0
;Slave.c,134 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,135 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,136 :: 		UpdateLCDFlag = 0;
	BCF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,137 :: 		Sec_X1 = 0x00;
	CLRF       _Sec_X1+0
;Slave.c,138 :: 		Sec_X10 = 0x00;
	CLRF       _Sec_X10+0
;Slave.c,139 :: 		Min_X1 = 0x00;
	CLRF       _Min_X1+0
;Slave.c,140 :: 		Min_X10 = 0x00;
	CLRF       _Min_X10+0
;Slave.c,141 :: 		Hour_X1 = 0x00;
	CLRF       _Hour_X1+0
;Slave.c,142 :: 		Hour_X10 = 0x00;
	CLRF       _Hour_X10+0
;Slave.c,143 :: 		Tmp_Sec_X1 = 0x00;
	CLRF       _Tmp_Sec_X1+0
;Slave.c,144 :: 		Tmp_Sec_X10 = 0x00;
	CLRF       _Tmp_Sec_X10+0
;Slave.c,145 :: 		Tmp_Min_X1 = 0x00;
	CLRF       _Tmp_Min_X1+0
;Slave.c,146 :: 		Tmp_Min_X10 = 0x00;
	CLRF       _Tmp_Min_X10+0
;Slave.c,147 :: 		Tmp_Hour_X1 = 0x00;
	CLRF       _Tmp_Hour_X1+0
;Slave.c,148 :: 		Tmp_Hour_X10 = 0x00;
	CLRF       _Tmp_Hour_X10+0
;Slave.c,150 :: 		Seconds = 0x00;
	CLRF       _Seconds+0
;Slave.c,151 :: 		Minutes = 0x00;
	CLRF       _Minutes+0
;Slave.c,152 :: 		Hours = 0x00;
	CLRF       _Hours+0
;Slave.c,155 :: 		time_left_high = 0x00;
	CLRF       _time_left_high+0
;Slave.c,156 :: 		time_left_low = 0x00;
	CLRF       _time_left_low+0
;Slave.c,157 :: 		WateringSec = 0;
	CLRF       _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,158 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,159 :: 		ManualEvent = 0;
	BCF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,160 :: 		ResetEvent = 0;
	BCF        _ResetEvent+0, BitPos(_ResetEvent+0)
;Slave.c,161 :: 		ProgramSetupFlag = 0;
	BCF        _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
;Slave.c,162 :: 		ProgStartHour = 0x00;
	CLRF       _ProgStartHour+0
;Slave.c,163 :: 		ProgStartMin = 0x00;
	CLRF       _ProgStartMin+0
;Slave.c,164 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,165 :: 		PinWatering = 0;
	BCF        PORTA+0, 3
;Slave.c,166 :: 		PinAlarm = 0;
	BCF        PORTA+0, 4
;Slave.c,168 :: 		m_bSystemOn=0;
	BCF        _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
;Slave.c,169 :: 		m_bWatering=0;
	BCF        _m_bWatering+0, BitPos(_m_bWatering+0)
;Slave.c,170 :: 		m_bAlarm   =0;
	BCF        _m_bAlarm+0, BitPos(_m_bAlarm+0)
;Slave.c,172 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,173 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,174 :: 		}
	RETURN
; end of _init_variables

_ReadADC:

;Slave.c,176 :: 		unsigned char ReadADC()
;Slave.c,178 :: 		ADCON0.GO_DONE = 1;    // pokreni konverziju
	BSF        ADCON0+0, 2
;Slave.c,179 :: 		while (ADCON0.GO_DONE) //
L_ReadADC0:
	BTFSS      ADCON0+0, 2
	GOTO       L_ReadADC1
;Slave.c,180 :: 		;
	GOTO       L_ReadADC0
L_ReadADC1:
;Slave.c,181 :: 		return ADRESH;
	MOVF       ADRESH+0, 0
	MOVWF      R0+0
;Slave.c,182 :: 		}
	RETURN
; end of _ReadADC

_transmit:

;Slave.c,184 :: 		void transmit(unsigned char DATA8b)
;Slave.c,187 :: 		TXREG = DATA8b;
	MOVF       FARG_transmit_DATA8b+0, 0
	MOVWF      TXREG+0
;Slave.c,188 :: 		while (!TXSTA.TRMT) // cekaj dok se shift registar ne isprazni
L_transmit2:
	BTFSC      TXSTA+0, 1
	GOTO       L_transmit3
;Slave.c,189 :: 		;
	GOTO       L_transmit2
L_transmit3:
;Slave.c,190 :: 		}
	RETURN
; end of _transmit

_DecodeTime:

;Slave.c,192 :: 		void DecodeTime()
;Slave.c,194 :: 		Seconds = (Sec_X10 << 4) + Sec_X1;
	MOVF       _Sec_X10+0, 0
	MOVWF      _Seconds+0
	RLF        _Seconds+0, 1
	BCF        _Seconds+0, 0
	RLF        _Seconds+0, 1
	BCF        _Seconds+0, 0
	RLF        _Seconds+0, 1
	BCF        _Seconds+0, 0
	RLF        _Seconds+0, 1
	BCF        _Seconds+0, 0
	MOVF       _Sec_X1+0, 0
	ADDWF      _Seconds+0, 1
;Slave.c,195 :: 		Minutes = (Min_X10 << 4) + Min_X1;
	MOVF       _Min_X10+0, 0
	MOVWF      _Minutes+0
	RLF        _Minutes+0, 1
	BCF        _Minutes+0, 0
	RLF        _Minutes+0, 1
	BCF        _Minutes+0, 0
	RLF        _Minutes+0, 1
	BCF        _Minutes+0, 0
	RLF        _Minutes+0, 1
	BCF        _Minutes+0, 0
	MOVF       _Min_X1+0, 0
	ADDWF      _Minutes+0, 1
;Slave.c,196 :: 		Hours = (Hour_X10 << 4) + Hour_X1;
	MOVF       _Hour_X10+0, 0
	MOVWF      _Hours+0
	RLF        _Hours+0, 1
	BCF        _Hours+0, 0
	RLF        _Hours+0, 1
	BCF        _Hours+0, 0
	RLF        _Hours+0, 1
	BCF        _Hours+0, 0
	RLF        _Hours+0, 1
	BCF        _Hours+0, 0
	MOVF       _Hour_X1+0, 0
	ADDWF      _Hours+0, 1
;Slave.c,197 :: 		}
	RETURN
; end of _DecodeTime

_ProcessInputs:

;Slave.c,199 :: 		void ProcessInputs()
;Slave.c,220 :: 		if (cntManual > 0)
	MOVF       _cntManual+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_ProcessInputs4
;Slave.c,221 :: 		cntManual--;
	DECF       _cntManual+0, 1
L_ProcessInputs4:
;Slave.c,222 :: 		if (PinTaster == 0)
	BTFSC      PORTB+0, 0
	GOTO       L_ProcessInputs5
;Slave.c,223 :: 		TMP_Taster1 = 0;
	BCF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
L_ProcessInputs5:
;Slave.c,224 :: 		if ((cntManual == 0) && (TMP_Taster1 == 0) && (PinTaster == 1))
	MOVF       _cntManual+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs8
	BTFSC      _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
	GOTO       L_ProcessInputs8
	BTFSS      PORTB+0, 0
	GOTO       L_ProcessInputs8
L__ProcessInputs115:
;Slave.c,226 :: 		TMP_Taster1 = 1;
	BSF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
;Slave.c,227 :: 		cntManual = DEBOUNCE_TICKS;
	MOVLW      10
	MOVWF      _cntManual+0
;Slave.c,228 :: 		if (ManualMode == 1)
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_ProcessInputs9
;Slave.c,229 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_ProcessInputs10
L_ProcessInputs9:
;Slave.c,231 :: 		ManualMode = 1;
	BSF        _ManualMode+0, BitPos(_ManualMode+0)
L_ProcessInputs10:
;Slave.c,232 :: 		ManualEvent = 1; // consumed by main
	BSF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,233 :: 		}
L_ProcessInputs8:
;Slave.c,236 :: 		if (cntReset > 0)
	MOVF       _cntReset+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_ProcessInputs11
;Slave.c,237 :: 		cntReset--;
	DECF       _cntReset+0, 1
L_ProcessInputs11:
;Slave.c,238 :: 		if (PinReset == 0)
	BTFSC      PORTB+0, 2
	GOTO       L_ProcessInputs12
;Slave.c,239 :: 		TMP_Reset1 = 0;
	BCF        _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
L_ProcessInputs12:
;Slave.c,240 :: 		if ((cntReset == 0) && (TMP_Reset1 == 0) && (PinReset == 1))
	MOVF       _cntReset+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs15
	BTFSC      _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
	GOTO       L_ProcessInputs15
	BTFSS      PORTB+0, 2
	GOTO       L_ProcessInputs15
L__ProcessInputs114:
;Slave.c,242 :: 		TMP_Reset1 = 1;
	BSF        _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
;Slave.c,243 :: 		cntReset = DEBOUNCE_TICKS;
	MOVLW      10
	MOVWF      _cntReset+0
;Slave.c,244 :: 		ResetEvent = 1; // consumed by main
	BSF        _ResetEvent+0, BitPos(_ResetEvent+0)
;Slave.c,245 :: 		}
L_ProcessInputs15:
;Slave.c,247 :: 		}
	RETURN
; end of _ProcessInputs

_buildStatusByte:

;Slave.c,249 :: 		unsigned char buildStatusByte()
;Slave.c,251 :: 		unsigned char status = 0x00;
	CLRF       buildStatusByte_status_L0+0
;Slave.c,252 :: 		if (m_bSystemOn)
	BTFSS      _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
	GOTO       L_buildStatusByte16
;Slave.c,253 :: 		status |= STATUS_SYSTEM_BIT;
	BSF        buildStatusByte_status_L0+0, 7
L_buildStatusByte16:
;Slave.c,254 :: 		if (m_bWatering)
	BTFSS      _m_bWatering+0, BitPos(_m_bWatering+0)
	GOTO       L_buildStatusByte17
;Slave.c,255 :: 		status |= STATUS_WATER_BIT;
	BSF        buildStatusByte_status_L0+0, 6
L_buildStatusByte17:
;Slave.c,256 :: 		if (m_bAlarm)
	BTFSS      _m_bAlarm+0, BitPos(_m_bAlarm+0)
	GOTO       L_buildStatusByte18
;Slave.c,257 :: 		status |= STATUS_ALARM_BIT;
	BSF        buildStatusByte_status_L0+0, 5
L_buildStatusByte18:
;Slave.c,258 :: 		if (ManualMode)
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_buildStatusByte19
;Slave.c,259 :: 		status |= STATUS_MANUAL_BIT;
	BSF        buildStatusByte_status_L0+0, 4
L_buildStatusByte19:
;Slave.c,260 :: 		return status;
	MOVF       buildStatusByte_status_L0+0, 0
	MOVWF      R0+0
;Slave.c,261 :: 		}
	RETURN
; end of _buildStatusByte

_toBcd:

;Slave.c,280 :: 		unsigned char toBcd(unsigned char val)
;Slave.c,283 :: 		tens = 0;
	CLRF       R2+0
;Slave.c,284 :: 		while (val > 9)
L_toBcd20:
	MOVF       FARG_toBcd_val+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_toBcd21
;Slave.c,286 :: 		val -= 10;
	MOVLW      10
	SUBWF      FARG_toBcd_val+0, 1
;Slave.c,287 :: 		tens++;
	INCF       R2+0, 1
;Slave.c,288 :: 		}
	GOTO       L_toBcd20
L_toBcd21:
;Slave.c,289 :: 		return (tens << 4) | val;
	MOVF       R2+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       FARG_toBcd_val+0, 0
	IORWF      R0+0, 1
;Slave.c,290 :: 		}
	RETURN
; end of _toBcd

_main:

;Slave.c,292 :: 		void main()
;Slave.c,294 :: 		init();
	CALL       _init+0
;Slave.c,295 :: 		init_variables();
	CALL       _init_variables+0
;Slave.c,296 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Slave.c,297 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,299 :: 		while (1)
L_main22:
;Slave.c,303 :: 		if (ResetEvent == 1)
	BTFSS      _ResetEvent+0, BitPos(_ResetEvent+0)
	GOTO       L_main24
;Slave.c,305 :: 		ResetEvent = 0;
	BCF        _ResetEvent+0, BitPos(_ResetEvent+0)
;Slave.c,307 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,308 :: 		ManualEvent = 0;
	BCF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,309 :: 		WateringSec = 0;
	CLRF       _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,311 :: 		m_bSystemOn = 1;
	BSF        _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
;Slave.c,312 :: 		m_bWatering = 0;
	BCF        _m_bWatering+0, BitPos(_m_bWatering+0)
;Slave.c,313 :: 		m_bAlarm = 0;
	BCF        _m_bAlarm+0, BitPos(_m_bAlarm+0)
;Slave.c,314 :: 		PinWatering = 0;
	BCF        PORTA+0, 3
;Slave.c,315 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,316 :: 		PinAlarm = 0;
	BCF        PORTA+0, 4
;Slave.c,317 :: 		}
L_main24:
;Slave.c,320 :: 		if (ManualEvent == 1)
	BTFSS      _ManualEvent+0, BitPos(_ManualEvent+0)
	GOTO       L_main25
;Slave.c,322 :: 		ManualEvent = 0;
	BCF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,323 :: 		if (ManualMode == 1)
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_main26
;Slave.c,326 :: 		WateringSec = 180;
	MOVLW      180
	MOVWF      _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,327 :: 		m_bWatering = 1;
	BSF        _m_bWatering+0, BitPos(_m_bWatering+0)
;Slave.c,328 :: 		PinWatering = 1;
	BSF        PORTA+0, 3
;Slave.c,329 :: 		m_bSystemOn = 1;
	BSF        _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
;Slave.c,330 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,331 :: 		}
	GOTO       L_main27
L_main26:
;Slave.c,335 :: 		WateringSec = 0;
	CLRF       _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,336 :: 		m_bWatering = 0;
	BCF        _m_bWatering+0, BitPos(_m_bWatering+0)
;Slave.c,337 :: 		PinWatering = 0;
	BCF        PORTA+0, 3
;Slave.c,338 :: 		m_bSystemOn = 1;
	BSF        _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
;Slave.c,339 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,340 :: 		}
L_main27:
;Slave.c,341 :: 		}
L_main25:
;Slave.c,343 :: 		if (UpdateLCDFlag == 1)  // 1 sekunda
	BTFSS      _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
	GOTO       L_main28
;Slave.c,345 :: 		UpdateLCDFlag = 0;
	BCF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,349 :: 		(Seconds == 0x00) &&
	BTFSC      _m_bWatering+0, BitPos(_m_bWatering+0)
	GOTO       L_main31
	MOVF       _Seconds+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;Slave.c,350 :: 		(Hours == ProgStartHour) &&
	MOVF       _Hours+0, 0
	XORWF      _ProgStartHour+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;Slave.c,351 :: 		(Minutes == ProgStartMin))
	MOVF       _Minutes+0, 0
	XORWF      _ProgStartMin+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main31
L__main118:
;Slave.c,354 :: 		WateringSec = (unsigned int) ((time_left_high * 100) + time_left_low);
	MOVF       _time_left_high+0, 0
	MOVWF      R0+0
	MOVLW      100
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       _time_left_low+0, 0
	ADDWF      R0+0, 0
	MOVWF      _WateringSec+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      _WateringSec+1
;Slave.c,356 :: 		m_bWatering = 1;
	BSF        _m_bWatering+0, BitPos(_m_bWatering+0)
;Slave.c,357 :: 		PinWatering = 1;
	BSF        PORTA+0, 3
;Slave.c,358 :: 		m_bSystemOn = 1;
	BSF        _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
;Slave.c,359 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,360 :: 		}
L_main31:
;Slave.c,363 :: 		if (m_bWatering == 1) //(PinWatering == 1)
	BTFSS      _m_bWatering+0, BitPos(_m_bWatering+0)
	GOTO       L_main32
;Slave.c,365 :: 		if (WateringSec > 0)
	MOVF       _WateringSec+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main126
	MOVF       _WateringSec+0, 0
	SUBLW      0
L__main126:
	BTFSC      STATUS+0, 0
	GOTO       L_main33
;Slave.c,366 :: 		WateringSec--;
	MOVLW      1
	SUBWF      _WateringSec+0, 1
	BTFSS      STATUS+0, 0
	DECF       _WateringSec+1, 1
L_main33:
;Slave.c,368 :: 		if (WateringSec == 0)
	MOVLW      0
	XORWF      _WateringSec+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main127
	MOVLW      0
	XORWF      _WateringSec+0, 0
L__main127:
	BTFSS      STATUS+0, 2
	GOTO       L_main34
;Slave.c,370 :: 		m_bWatering = 0;
	BCF        _m_bWatering+0, BitPos(_m_bWatering+0)
;Slave.c,371 :: 		PinWatering = 0;
	BCF        PORTA+0, 3
;Slave.c,372 :: 		m_bSystemOn = 1;
	BSF        _m_bSystemOn+0, BitPos(_m_bSystemOn+0)
;Slave.c,373 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,375 :: 		ManualMode = 0;  // ???
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,376 :: 		}
L_main34:
;Slave.c,377 :: 		}
L_main32:
;Slave.c,379 :: 		FlowValue = ReadADC();
	CALL       _ReadADC+0
	MOVF       R0+0, 0
	MOVWF      _FlowValue+0
;Slave.c,381 :: 		if (m_bWatering == 1) //(PinWatering == 1)
	BTFSS      _m_bWatering+0, BitPos(_m_bWatering+0)
	GOTO       L_main35
;Slave.c,383 :: 		if ((FlowValue < FlowMin) || (FlowValue > FlowMax)) {
	MOVF       _FlowMin+0, 0
	SUBWF      _FlowValue+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main117
	MOVF       _FlowValue+0, 0
	SUBWF      _FlowMax+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main117
	GOTO       L_main38
L__main117:
;Slave.c,384 :: 		PinAlarm = 1;
	BSF        PORTA+0, 4
;Slave.c,385 :: 		m_bAlarm = 1;
	BSF        _m_bAlarm+0, BitPos(_m_bAlarm+0)
;Slave.c,386 :: 		}
	GOTO       L_main39
L_main38:
;Slave.c,388 :: 		PinAlarm = 0;
	BCF        PORTA+0, 4
;Slave.c,389 :: 		m_bAlarm = 0;
	BCF        _m_bAlarm+0, BitPos(_m_bAlarm+0)
;Slave.c,390 :: 		}
L_main39:
;Slave.c,391 :: 		}
	GOTO       L_main40
L_main35:
;Slave.c,394 :: 		PinAlarm = 0;
	BCF        PORTA+0, 4
;Slave.c,395 :: 		m_bAlarm = 0;
	BCF        _m_bAlarm+0, BitPos(_m_bAlarm+0)
;Slave.c,396 :: 		}
L_main40:
;Slave.c,398 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,399 :: 		}  // 1 sekunda
L_main28:
;Slave.c,401 :: 		if ((ByteID > 0) && (Counter2 == 0))
	MOVF       _ByteID+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main43
	MOVF       _Counter2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main43
L__main116:
;Slave.c,403 :: 		ByteID = 0;
	CLRF       _ByteID+0
;Slave.c,404 :: 		}
L_main43:
;Slave.c,407 :: 		if (CallFlag == 1)
	BTFSS      _CallFlag+0, BitPos(_CallFlag+0)
	GOTO       L_main44
;Slave.c,410 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,411 :: 		transmit(STATUS_CODE | GARDEN_ID);
	MOVLW      32
	IORWF      _GARDEN_ID+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,412 :: 		transmit(buildStatusByte());
	CALL       _buildStatusByte+0
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,413 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,414 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,415 :: 		}
L_main44:
;Slave.c,417 :: 		if (RTCSetupFlag == 1)
	BTFSS      _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
	GOTO       L_main45
;Slave.c,419 :: 		Sec_X1 = Tmp_Sec_X1;
	MOVF       _Tmp_Sec_X1+0, 0
	MOVWF      _Sec_X1+0
;Slave.c,420 :: 		Sec_X10 = Tmp_Sec_X10;
	MOVF       _Tmp_Sec_X10+0, 0
	MOVWF      _Sec_X10+0
;Slave.c,421 :: 		Min_X1 = Tmp_Min_X1;
	MOVF       _Tmp_Min_X1+0, 0
	MOVWF      _Min_X1+0
;Slave.c,422 :: 		Min_X10 = Tmp_Min_X10;
	MOVF       _Tmp_Min_X10+0, 0
	MOVWF      _Min_X10+0
;Slave.c,423 :: 		Hour_X1 = Tmp_Hour_X1;
	MOVF       _Tmp_Hour_X1+0, 0
	MOVWF      _Hour_X1+0
;Slave.c,424 :: 		Hour_X10 = Tmp_Hour_X10;
	MOVF       _Tmp_Hour_X10+0, 0
	MOVWF      _Hour_X10+0
;Slave.c,425 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,426 :: 		transmit(STATUS_CODE | GARDEN_ID);
	MOVLW      32
	IORWF      _GARDEN_ID+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,427 :: 		transmit(buildStatusByte());
	CALL       _buildStatusByte+0
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,428 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,429 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,430 :: 		}
L_main45:
;Slave.c,431 :: 		if (ProgramSetupFlag == 1)
	BTFSS      _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
	GOTO       L_main46
;Slave.c,433 :: 		ProgStartHour = toBcd(Tmp_ProgStartHour);
	MOVF       _Tmp_ProgStartHour+0, 0
	MOVWF      FARG_toBcd_val+0
	CALL       _toBcd+0
	MOVF       R0+0, 0
	MOVWF      _ProgStartHour+0
;Slave.c,434 :: 		ProgStartMin = toBcd(Tmp_ProgStartMin);
	MOVF       _Tmp_ProgStartMin+0, 0
	MOVWF      FARG_toBcd_val+0
	CALL       _toBcd+0
	MOVF       R0+0, 0
	MOVWF      _ProgStartMin+0
;Slave.c,435 :: 		time_left_high = Tmp_time_left_high;
	MOVF       _Tmp_time_left_high+0, 0
	MOVWF      _time_left_high+0
;Slave.c,436 :: 		time_left_low = Tmp_time_left_low;
	MOVF       _Tmp_time_left_low+0, 0
	MOVWF      _time_left_low+0
;Slave.c,438 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,439 :: 		transmit(STATUS_CODE | GARDEN_ID);
	MOVLW      32
	IORWF      _GARDEN_ID+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,440 :: 		transmit(buildStatusByte());
	CALL       _buildStatusByte+0
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,441 :: 		ProgramSetupFlag = 0;
	BCF        _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
;Slave.c,442 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,443 :: 		}
L_main46:
;Slave.c,444 :: 		}
	GOTO       L_main22
;Slave.c,445 :: 		}
	GOTO       $+0
; end of _main

_IncrementTime:

;Slave.c,447 :: 		void IncrementTime()
;Slave.c,449 :: 		if (Sec_X1 >= 9)
	MOVLW      9
	SUBWF      _Sec_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime47
;Slave.c,451 :: 		Sec_X1 = 0;
	CLRF       _Sec_X1+0
;Slave.c,452 :: 		if (Sec_X10 >= 5)
	MOVLW      5
	SUBWF      _Sec_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime48
;Slave.c,454 :: 		Sec_X10 = 0;
	CLRF       _Sec_X10+0
;Slave.c,456 :: 		if (Min_X1 >= 9)
	MOVLW      9
	SUBWF      _Min_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime49
;Slave.c,458 :: 		Min_X1 = 0;
	CLRF       _Min_X1+0
;Slave.c,459 :: 		if (Min_X10 >= 5)
	MOVLW      5
	SUBWF      _Min_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime50
;Slave.c,461 :: 		Min_X10 = 0;
	CLRF       _Min_X10+0
;Slave.c,463 :: 		if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3)))
	MOVLW      9
	SUBWF      _Hour_X1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__IncrementTime119
	MOVLW      2
	SUBWF      _Hour_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime120
	MOVLW      3
	SUBWF      _Hour_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime120
	GOTO       L__IncrementTime119
L__IncrementTime120:
	GOTO       L_IncrementTime55
L__IncrementTime119:
;Slave.c,465 :: 		Hour_X1 = 0;
	CLRF       _Hour_X1+0
;Slave.c,466 :: 		if (Hour_X10 == 2)
	MOVF       _Hour_X10+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_IncrementTime56
;Slave.c,468 :: 		Hour_X10 = 0;
	CLRF       _Hour_X10+0
;Slave.c,469 :: 		}
	GOTO       L_IncrementTime57
L_IncrementTime56:
;Slave.c,471 :: 		Hour_X10++;
	INCF       _Hour_X10+0, 1
L_IncrementTime57:
;Slave.c,472 :: 		}
	GOTO       L_IncrementTime58
L_IncrementTime55:
;Slave.c,474 :: 		Hour_X1++;
	INCF       _Hour_X1+0, 1
L_IncrementTime58:
;Slave.c,476 :: 		}
	GOTO       L_IncrementTime59
L_IncrementTime50:
;Slave.c,478 :: 		Min_X10++;
	INCF       _Min_X10+0, 1
L_IncrementTime59:
;Slave.c,479 :: 		}
	GOTO       L_IncrementTime60
L_IncrementTime49:
;Slave.c,481 :: 		Min_X1++;
	INCF       _Min_X1+0, 1
L_IncrementTime60:
;Slave.c,483 :: 		}
	GOTO       L_IncrementTime61
L_IncrementTime48:
;Slave.c,485 :: 		Sec_X10++;
	INCF       _Sec_X10+0, 1
L_IncrementTime61:
;Slave.c,486 :: 		}
	GOTO       L_IncrementTime62
L_IncrementTime47:
;Slave.c,488 :: 		Sec_X1++;
	INCF       _Sec_X1+0, 1
L_IncrementTime62:
;Slave.c,489 :: 		}
	RETURN
; end of _IncrementTime

_ConvertTime:

;Slave.c,491 :: 		void ConvertTime(unsigned char ch)
;Slave.c,493 :: 		X1 = ch;
	MOVF       FARG_ConvertTime_ch+0, 0
	MOVWF      _X1+0
;Slave.c,494 :: 		X10 = 0x00;
	CLRF       _X10+0
;Slave.c,495 :: 		while (X1 > 9)
L_ConvertTime63:
	MOVF       _X1+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_ConvertTime64
;Slave.c,497 :: 		X1 = X1 - 10;
	MOVLW      10
	SUBWF      _X1+0, 1
;Slave.c,498 :: 		X10++;
	INCF       _X10+0, 1
;Slave.c,499 :: 		}
	GOTO       L_ConvertTime63
L_ConvertTime64:
;Slave.c,500 :: 		}
	RETURN
; end of _ConvertTime

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave.c,502 :: 		void interrupt()
;Slave.c,504 :: 		GARDEN_ID = PORTD & 0x0F;
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      _GARDEN_ID+0
;Slave.c,505 :: 		if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
	BTFSS      PIE1+0, 0
	GOTO       L_interrupt67
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt67
L__interrupt124:
;Slave.c,508 :: 		PIR1.TMR1IF = 0; // brise se flag
	BCF        PIR1+0, 0
;Slave.c,510 :: 		if (Counter == 9)
	MOVF       _Counter+0, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt68
;Slave.c,512 :: 		Counter = 0;
	CLRF       _Counter+0
;Slave.c,513 :: 		IncrementTime();
	CALL       _IncrementTime+0
;Slave.c,514 :: 		DecodeTime();
	CALL       _DecodeTime+0
;Slave.c,515 :: 		UpdateLCDFlag = 1;
	BSF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,516 :: 		}
	GOTO       L_interrupt69
L_interrupt68:
;Slave.c,518 :: 		Counter++;
	INCF       _Counter+0, 1
L_interrupt69:
;Slave.c,520 :: 		if (Counter2 > 0)
	MOVF       _Counter2+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt70
;Slave.c,521 :: 		Counter2--;
	DECF       _Counter2+0, 1
	GOTO       L_interrupt71
L_interrupt70:
;Slave.c,523 :: 		Counter2 = 0;
	CLRF       _Counter2+0
L_interrupt71:
;Slave.c,525 :: 		ProcessInputs();
	CALL       _ProcessInputs+0
;Slave.c,527 :: 		TMR1H = 0x0B; // startne vrednosti tajmera 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,528 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,529 :: 		}
L_interrupt67:
;Slave.c,531 :: 		if ((PIE1.RCIE) && (PIR1.RCIF))
	BTFSS      PIE1+0, 5
	GOTO       L_interrupt74
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt74
L__interrupt123:
;Slave.c,533 :: 		ch = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      _ch+0
;Slave.c,535 :: 		if (ByteID == 0x00)
	MOVF       _ByteID+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt75
;Slave.c,537 :: 		if (((ch & 0x0F) == GARDEN_ID) && ((ch & 0xE0) == 0xA0))  // mode code
	MOVLW      15
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORWF      _GARDEN_ID+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt78
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt78
L__interrupt122:
;Slave.c,539 :: 		Command = ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
;Slave.c,540 :: 		ByteID = 0x08;
	MOVLW      8
	MOVWF      _ByteID+0
;Slave.c,541 :: 		Counter2 = 4;
	MOVLW      4
	MOVWF      _Counter2+0
;Slave.c,542 :: 		}
	GOTO       L_interrupt79
L_interrupt78:
;Slave.c,543 :: 		else if (ch == 0x7F) //((ch & 0xE0) == 0x60)
	MOVF       _ch+0, 0
	XORLW      127
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt80
;Slave.c,545 :: 		ByteID = 0x03;
	MOVLW      3
	MOVWF      _ByteID+0
;Slave.c,546 :: 		Counter2 = 3;
	MOVLW      3
	MOVWF      _Counter2+0
;Slave.c,547 :: 		}
	GOTO       L_interrupt81
L_interrupt80:
;Slave.c,548 :: 		else if (((ch & 0x0F) == GARDEN_ID) && ((ch & 0xE0) == 0x20))  // status code
	MOVLW      15
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORWF      _GARDEN_ID+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt84
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt84
L__interrupt121:
;Slave.c,550 :: 		Command = ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
;Slave.c,551 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,552 :: 		CallFlag = 1;
	BSF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,553 :: 		}
L_interrupt84:
L_interrupt81:
L_interrupt79:
;Slave.c,554 :: 		}
	GOTO       L_interrupt85
L_interrupt75:
;Slave.c,555 :: 		else if (ByteID == 0x03)
	MOVF       _ByteID+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt86
;Slave.c,557 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,558 :: 		Tmp_Hour_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Hour_X1+0
;Slave.c,559 :: 		Tmp_Hour_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Hour_X10+0
;Slave.c,560 :: 		ByteID = 0x02;
	MOVLW      2
	MOVWF      _ByteID+0
;Slave.c,561 :: 		}
	GOTO       L_interrupt87
L_interrupt86:
;Slave.c,562 :: 		else if (ByteID == 0x02)
	MOVF       _ByteID+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt88
;Slave.c,564 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,565 :: 		Tmp_Min_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Min_X1+0
;Slave.c,566 :: 		Tmp_Min_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Min_X10+0
;Slave.c,567 :: 		ByteID = 0x01;
	MOVLW      1
	MOVWF      _ByteID+0
;Slave.c,568 :: 		}
	GOTO       L_interrupt89
L_interrupt88:
;Slave.c,569 :: 		else if (ByteID == 0x01)
	MOVF       _ByteID+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt90
;Slave.c,571 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,572 :: 		Tmp_Sec_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Sec_X1+0
;Slave.c,573 :: 		Tmp_Sec_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Sec_X10+0
;Slave.c,574 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,575 :: 		RTCSetupFlag = 1;
	BSF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,576 :: 		}
	GOTO       L_interrupt91
L_interrupt90:
;Slave.c,578 :: 		else if (ByteID == 0x08)
	MOVF       _ByteID+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt92
;Slave.c,580 :: 		Tmp_ProgStartHour = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgStartHour+0
;Slave.c,581 :: 		ByteID = 0x07;
	MOVLW      7
	MOVWF      _ByteID+0
;Slave.c,582 :: 		}
	GOTO       L_interrupt93
L_interrupt92:
;Slave.c,583 :: 		else if (ByteID == 0x07)
	MOVF       _ByteID+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt94
;Slave.c,585 :: 		Tmp_ProgStartMin = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgStartMin+0
;Slave.c,586 :: 		ByteID = 0x06;
	MOVLW      6
	MOVWF      _ByteID+0
;Slave.c,587 :: 		}
	GOTO       L_interrupt95
L_interrupt94:
;Slave.c,588 :: 		else if (ByteID == 0x06)
	MOVF       _ByteID+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt96
;Slave.c,590 :: 		Tmp_time_left_high = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_time_left_high+0
;Slave.c,591 :: 		ByteID = 0x05;
	MOVLW      5
	MOVWF      _ByteID+0
;Slave.c,592 :: 		}
	GOTO       L_interrupt97
L_interrupt96:
;Slave.c,593 :: 		else if (ByteID == 0x05)
	MOVF       _ByteID+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt98
;Slave.c,595 :: 		Tmp_time_left_low = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_time_left_low+0
;Slave.c,596 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,597 :: 		ProgramSetupFlag = 1;
	BSF        _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
;Slave.c,598 :: 		}
L_interrupt98:
L_interrupt97:
L_interrupt95:
L_interrupt93:
L_interrupt91:
L_interrupt89:
L_interrupt87:
L_interrupt85:
;Slave.c,599 :: 		}
L_interrupt74:
;Slave.c,600 :: 		}
L__interrupt128:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_LcdOut2:

;Slave.c,605 :: 		void LcdOut2(unsigned char row, unsigned char col, unsigned char value)
;Slave.c,609 :: 		tens = 0;
	CLRF       LcdOut2_tens_L0+0
;Slave.c,610 :: 		while (value > 9)
L_LcdOut299:
	MOVF       FARG_LcdOut2_value+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_LcdOut2100
;Slave.c,612 :: 		value -= 10;
	MOVLW      10
	SUBWF      FARG_LcdOut2_value+0, 1
;Slave.c,613 :: 		tens++;
	INCF       LcdOut2_tens_L0+0, 1
;Slave.c,614 :: 		}
	GOTO       L_LcdOut299
L_LcdOut2100:
;Slave.c,616 :: 		Lcd_Chr(row, col,     tens  + '0');
	MOVF       FARG_LcdOut2_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_LcdOut2_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      LcdOut2_tens_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,617 :: 		Lcd_Chr(row, col + 1, value + '0');
	MOVF       FARG_LcdOut2_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	INCF       FARG_LcdOut2_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      FARG_LcdOut2_value+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,618 :: 		}
	RETURN
; end of _LcdOut2

_LcdOutDuration:

;Slave.c,620 :: 		void LcdOutDuration(unsigned char row, unsigned char col, unsigned int seconds)
;Slave.c,624 :: 		minutes = 0;
	CLRF       LcdOutDuration_minutes_L0+0
;Slave.c,625 :: 		while ((seconds >= 60) && (minutes < 99))
L_LcdOutDuration101:
	MOVLW      0
	SUBWF      FARG_LcdOutDuration_seconds+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__LcdOutDuration129
	MOVLW      60
	SUBWF      FARG_LcdOutDuration_seconds+0, 0
L__LcdOutDuration129:
	BTFSS      STATUS+0, 0
	GOTO       L_LcdOutDuration102
	MOVLW      99
	SUBWF      LcdOutDuration_minutes_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_LcdOutDuration102
L__LcdOutDuration125:
;Slave.c,627 :: 		seconds -= 60;
	MOVLW      60
	SUBWF      FARG_LcdOutDuration_seconds+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_LcdOutDuration_seconds+1, 1
;Slave.c,628 :: 		minutes++;
	INCF       LcdOutDuration_minutes_L0+0, 1
;Slave.c,629 :: 		}
	GOTO       L_LcdOutDuration101
L_LcdOutDuration102:
;Slave.c,630 :: 		if (seconds >= 60)
	MOVLW      0
	SUBWF      FARG_LcdOutDuration_seconds+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__LcdOutDuration130
	MOVLW      60
	SUBWF      FARG_LcdOutDuration_seconds+0, 0
L__LcdOutDuration130:
	BTFSS      STATUS+0, 0
	GOTO       L_LcdOutDuration105
;Slave.c,632 :: 		seconds = 59;
	MOVLW      59
	MOVWF      FARG_LcdOutDuration_seconds+0
	MOVLW      0
	MOVWF      FARG_LcdOutDuration_seconds+1
;Slave.c,633 :: 		}
L_LcdOutDuration105:
;Slave.c,635 :: 		LcdOut2(row, col, minutes);
	MOVF       FARG_LcdOutDuration_row+0, 0
	MOVWF      FARG_LcdOut2_row+0
	MOVF       FARG_LcdOutDuration_col+0, 0
	MOVWF      FARG_LcdOut2_col+0
	MOVF       LcdOutDuration_minutes_L0+0, 0
	MOVWF      FARG_LcdOut2_value+0
	CALL       _LcdOut2+0
;Slave.c,636 :: 		Lcd_Chr(row, col + 2, ':');
	MOVF       FARG_LcdOutDuration_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	ADDWF      FARG_LcdOutDuration_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,637 :: 		LcdOut2(row, col + 3, (unsigned char)seconds);
	MOVF       FARG_LcdOutDuration_row+0, 0
	MOVWF      FARG_LcdOut2_row+0
	MOVLW      3
	ADDWF      FARG_LcdOutDuration_col+0, 0
	MOVWF      FARG_LcdOut2_col+0
	MOVF       FARG_LcdOutDuration_seconds+0, 0
	MOVWF      FARG_LcdOut2_value+0
	CALL       _LcdOut2+0
;Slave.c,638 :: 		}
	RETURN
; end of _LcdOutDuration

_LcdOut3:

;Slave.c,640 :: 		void LcdOut3(unsigned char row, unsigned char col, unsigned char value)
;Slave.c,645 :: 		hundreds = 0;
	CLRF       LcdOut3_hundreds_L0+0
;Slave.c,646 :: 		tens = 0;
	CLRF       LcdOut3_tens_L0+0
;Slave.c,648 :: 		while (value > 99)
L_LcdOut3106:
	MOVF       FARG_LcdOut3_value+0, 0
	SUBLW      99
	BTFSC      STATUS+0, 0
	GOTO       L_LcdOut3107
;Slave.c,650 :: 		value -= 100;
	MOVLW      100
	SUBWF      FARG_LcdOut3_value+0, 1
;Slave.c,651 :: 		hundreds++;
	INCF       LcdOut3_hundreds_L0+0, 1
;Slave.c,652 :: 		}
	GOTO       L_LcdOut3106
L_LcdOut3107:
;Slave.c,653 :: 		while (value > 9)
L_LcdOut3108:
	MOVF       FARG_LcdOut3_value+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_LcdOut3109
;Slave.c,655 :: 		value -= 10;
	MOVLW      10
	SUBWF      FARG_LcdOut3_value+0, 1
;Slave.c,656 :: 		tens++;
	INCF       LcdOut3_tens_L0+0, 1
;Slave.c,657 :: 		}
	GOTO       L_LcdOut3108
L_LcdOut3109:
;Slave.c,659 :: 		Lcd_Chr(row, col,     hundreds + '0');
	MOVF       FARG_LcdOut3_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_LcdOut3_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      LcdOut3_hundreds_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,660 :: 		Lcd_Chr(row, col + 1, tens     + '0');
	MOVF       FARG_LcdOut3_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	INCF       FARG_LcdOut3_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      LcdOut3_tens_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,661 :: 		Lcd_Chr(row, col + 2, value    + '0');
	MOVF       FARG_LcdOut3_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	ADDWF      FARG_LcdOut3_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      FARG_LcdOut3_value+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,662 :: 		}
	RETURN
; end of _LcdOut3

_UpdateLCD:

;Slave.c,665 :: 		void UpdateLCD()
;Slave.c,667 :: 		Lcd_Out(1, 1, "T ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,668 :: 		Lcd_Chr(1, 3,  Hour_X10 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,669 :: 		Lcd_Chr(1, 4,  Hour_X1  + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,670 :: 		Lcd_Chr(1, 5,  ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,671 :: 		Lcd_Chr(1, 6,  Min_X10  + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,672 :: 		Lcd_Chr(1, 7,  Min_X1   + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,673 :: 		Lcd_Chr(1, 8,  ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,674 :: 		Lcd_Chr(1, 9,  Sec_X10  + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,675 :: 		Lcd_Chr(1, 10, Sec_X1   + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,676 :: 		Lcd_Chr(1, 11, ' ');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,677 :: 		Lcd_Out(1, 12, "F");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,678 :: 		LcdOut3(1, 13, FlowValue);
	MOVLW      1
	MOVWF      FARG_LcdOut3_row+0
	MOVLW      13
	MOVWF      FARG_LcdOut3_col+0
	MOVF       _FlowValue+0, 0
	MOVWF      FARG_LcdOut3_value+0
	CALL       _LcdOut3+0
;Slave.c,680 :: 		if (m_bAlarm)    Lcd_Chr(2, 1, 'A'); else Lcd_Chr(2, 1, '/');
	BTFSS      _m_bAlarm+0, BitPos(_m_bAlarm+0)
	GOTO       L_UpdateLCD110
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      65
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD111
L_UpdateLCD110:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      47
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD111:
;Slave.c,681 :: 		if (ManualMode)  Lcd_Chr(2, 2, 'M'); else Lcd_Chr(2, 2, '/');
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_UpdateLCD112
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      77
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD113
L_UpdateLCD112:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      47
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD113:
;Slave.c,683 :: 		Lcd_Out(2, 3, "S:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,684 :: 		Lcd_Chr(2, 4, (Tmp_ProgStartHour / 10)+ '0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Tmp_ProgStartHour+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,685 :: 		Lcd_Chr(2, 5, (Tmp_ProgStartHour % 10)+ '0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Tmp_ProgStartHour+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,686 :: 		Lcd_Out(2, 6, ":");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,687 :: 		Lcd_Chr(2, 7, (Tmp_ProgStartMin / 10)+ '0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Tmp_ProgStartMin+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,688 :: 		Lcd_Chr(2, 8, (Tmp_ProgStartMin % 10)+ '0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Tmp_ProgStartMin+0, 0
	MOVWF      R0+0
	CALL       _Div_8x8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,690 :: 		Lcd_Out(2, 10, " R");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,691 :: 		LcdOutDuration(2, 12, WateringSec);
	MOVLW      2
	MOVWF      FARG_LcdOutDuration_row+0
	MOVLW      12
	MOVWF      FARG_LcdOutDuration_col+0
	MOVF       _WateringSec+0, 0
	MOVWF      FARG_LcdOutDuration_seconds+0
	MOVF       _WateringSec+1, 0
	MOVWF      FARG_LcdOutDuration_seconds+1
	CALL       _LcdOutDuration+0
;Slave.c,692 :: 		}
	RETURN
; end of _UpdateLCD

_init:

;Slave.c,694 :: 		void init()
;Slave.c,698 :: 		TRISA = 0x03;
	MOVLW      3
	MOVWF      TRISA+0
;Slave.c,700 :: 		TRISB = 0x3F;
	MOVLW      63
	MOVWF      TRISB+0
;Slave.c,701 :: 		TRISC = 0xC0; // pinovi 6 i 7 su vezani za RS232
	MOVLW      192
	MOVWF      TRISC+0
;Slave.c,703 :: 		TRISD = 0x0F; // pinovi 6 i 7 su vezani za RS232
	MOVLW      15
	MOVWF      TRISD+0
;Slave.c,705 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;Slave.c,706 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;Slave.c,707 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Slave.c,709 :: 		ADCON1 = 0b00001110;
	MOVLW      14
	MOVWF      ADCON1+0
;Slave.c,710 :: 		ADCON0 = 0b10000001;
	MOVLW      129
	MOVWF      ADCON0+0
;Slave.c,712 :: 		INTCON = 0b11000000; // default
	MOVLW      192
	MOVWF      INTCON+0
;Slave.c,713 :: 		PIE1 = 0b00000000;   // default
	CLRF       PIE1+0
;Slave.c,715 :: 		T1CON = 0b00110000; // konfiguracija za Tajmer 1
	MOVLW      48
	MOVWF      T1CON+0
;Slave.c,717 :: 		TMR1H = 0x0B; // startne vrednosti tajmera 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,718 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,719 :: 		T1CON.TMR1ON = 1;
	BSF        T1CON+0, 0
;Slave.c,727 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,728 :: 		PIE1.TMR1IE = 1;
	BSF        PIE1+0, 0
;Slave.c,730 :: 		Uart1_Init(19200);
	MOVLW      64
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave.c,733 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;Slave.c,734 :: 		RCSTA.SPEN = 1;
	BSF        RCSTA+0, 7
;Slave.c,735 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;Slave.c,736 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;Slave.c,738 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;Slave.c,740 :: 		}
	RETURN
; end of _init
