
_init_variables:

;Slave.c,109 :: 		void init_variables()
;Slave.c,112 :: 		GARDEN_ID = 0x00;
	CLRF       _GARDEN_ID+0
;Slave.c,114 :: 		TMP_Taster2 = 0;
	BCF        _TMP_Taster2+0, BitPos(_TMP_Taster2+0)
;Slave.c,115 :: 		TMP_Taster1 = 0;
	BCF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
;Slave.c,117 :: 		TMP_Reset2 = 0;
	BCF        _TMP_Reset2+0, BitPos(_TMP_Reset2+0)
;Slave.c,118 :: 		TMP_Reset1 = 0;
	BCF        _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
;Slave.c,120 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,121 :: 		ch = 0x00;
	CLRF       _ch+0
;Slave.c,122 :: 		Command = 0x00;
	CLRF       _Command+0
;Slave.c,123 :: 		CommandModified = 0x00;
	CLRF       _CommandModified+0
;Slave.c,124 :: 		Counter = 0x00;
	CLRF       _Counter+0
;Slave.c,125 :: 		Counter2 = 0x00;
	CLRF       _Counter2+0
;Slave.c,126 :: 		cntManual = 0x00;
	CLRF       _cntManual+0
;Slave.c,127 :: 		cntReset = 0x00;
	CLRF       _cntReset+0
;Slave.c,128 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,129 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,130 :: 		UpdateLCDFlag = 0;
	BCF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,131 :: 		Sec_X1 = 0x00;
	CLRF       _Sec_X1+0
;Slave.c,132 :: 		Sec_X10 = 0x00;
	CLRF       _Sec_X10+0
;Slave.c,133 :: 		Min_X1 = 0x00;
	CLRF       _Min_X1+0
;Slave.c,134 :: 		Min_X10 = 0x00;
	CLRF       _Min_X10+0
;Slave.c,135 :: 		Hour_X1 = 0x00;
	CLRF       _Hour_X1+0
;Slave.c,136 :: 		Hour_X10 = 0x00;
	CLRF       _Hour_X10+0
;Slave.c,137 :: 		Tmp_Sec_X1 = 0x00;
	CLRF       _Tmp_Sec_X1+0
;Slave.c,138 :: 		Tmp_Sec_X10 = 0x00;
	CLRF       _Tmp_Sec_X10+0
;Slave.c,139 :: 		Tmp_Min_X1 = 0x00;
	CLRF       _Tmp_Min_X1+0
;Slave.c,140 :: 		Tmp_Min_X10 = 0x00;
	CLRF       _Tmp_Min_X10+0
;Slave.c,141 :: 		Tmp_Hour_X1 = 0x00;
	CLRF       _Tmp_Hour_X1+0
;Slave.c,142 :: 		Tmp_Hour_X10 = 0x00;
	CLRF       _Tmp_Hour_X10+0
;Slave.c,144 :: 		Seconds = 0x00;
	CLRF       _Seconds+0
;Slave.c,145 :: 		Minutes = 0x00;
	CLRF       _Minutes+0
;Slave.c,146 :: 		Hours = 0x00;
	CLRF       _Hours+0
;Slave.c,149 :: 		time_left_high   = 0x00;
	CLRF       _time_left_high+0
;Slave.c,150 :: 		time_left_low    = 0x00;
	CLRF       _time_left_low+0
;Slave.c,151 :: 		WateringSec      = 0;
	CLRF       _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,152 :: 		ManualMode       = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,153 :: 		ManualEvent      = 0;
	BCF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,154 :: 		ResetEvent       = 0;
	BCF        _ResetEvent+0, BitPos(_ResetEvent+0)
;Slave.c,155 :: 		ProgramSetupFlag = 0;
	BCF        _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
;Slave.c,156 :: 		ProgStartHour    = 0x00;
	CLRF       _ProgStartHour+0
;Slave.c,157 :: 		ProgStartMin     = 0x00;
	CLRF       _ProgStartMin+0
;Slave.c,158 :: 		PinSystemOn      = 1;
	BSF        PORTA+0, 2
;Slave.c,159 :: 		PinWatering      = 0;
	BCF        PORTA+0, 3
;Slave.c,160 :: 		PinAlarm         = 0;
	BCF        PORTA+0, 4
;Slave.c,161 :: 		}
	RETURN
; end of _init_variables

_ReadADC:

;Slave.c,163 :: 		unsigned char ReadADC() {
;Slave.c,164 :: 		ADCON0.GO_DONE = 1;    // pokreni konverziju
	BSF        ADCON0+0, 2
;Slave.c,165 :: 		while (ADCON0.GO_DONE) //
L_ReadADC0:
	BTFSS      ADCON0+0, 2
	GOTO       L_ReadADC1
;Slave.c,166 :: 		;
	GOTO       L_ReadADC0
L_ReadADC1:
;Slave.c,167 :: 		return ADRESH;
	MOVF       ADRESH+0, 0
	MOVWF      R0+0
;Slave.c,168 :: 		}
	RETURN
; end of _ReadADC

_transmit:

;Slave.c,172 :: 		void transmit(unsigned char DATA8b)
;Slave.c,175 :: 		TXREG = DATA8b;
	MOVF       FARG_transmit_DATA8b+0, 0
	MOVWF      TXREG+0
;Slave.c,176 :: 		while (!TXSTA.TRMT) // cekaj dok se shift registar ne isprazni
L_transmit2:
	BTFSC      TXSTA+0, 1
	GOTO       L_transmit3
;Slave.c,177 :: 		;
	GOTO       L_transmit2
L_transmit3:
;Slave.c,178 :: 		}
	RETURN
; end of _transmit

_DecodeTime:

;Slave.c,180 :: 		void DecodeTime()
;Slave.c,182 :: 		Seconds = (Sec_X10 << 4) + Sec_X1;
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
;Slave.c,183 :: 		Minutes = (Min_X10 << 4) + Min_X1;
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
;Slave.c,184 :: 		Hours = (Hour_X10 << 4) + Hour_X1;
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
;Slave.c,185 :: 		}
	RETURN
; end of _DecodeTime

_ProcessInputs:

;Slave.c,187 :: 		void ProcessInputs()
;Slave.c,190 :: 		if (cntManual > 0) cntManual--;
	MOVF       _cntManual+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_ProcessInputs4
	DECF       _cntManual+0, 1
L_ProcessInputs4:
;Slave.c,191 :: 		if (PinTaster == 0) TMP_Taster1 = 0;
	BTFSC      PORTB+0, 0
	GOTO       L_ProcessInputs5
	BCF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
L_ProcessInputs5:
;Slave.c,192 :: 		if ((cntManual == 0) && (TMP_Taster1 == 0) && (PinTaster == 1))
	MOVF       _cntManual+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs8
	BTFSC      _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
	GOTO       L_ProcessInputs8
	BTFSS      PORTB+0, 0
	GOTO       L_ProcessInputs8
L__ProcessInputs108:
;Slave.c,194 :: 		TMP_Taster1 = 1;
	BSF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
;Slave.c,195 :: 		cntManual = DEBOUNCE_TICKS;
	MOVLW      10
	MOVWF      _cntManual+0
;Slave.c,196 :: 		if (ManualMode == 1) ManualMode = 0;
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_ProcessInputs9
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_ProcessInputs10
L_ProcessInputs9:
;Slave.c,197 :: 		else                 ManualMode = 1;
	BSF        _ManualMode+0, BitPos(_ManualMode+0)
L_ProcessInputs10:
;Slave.c,198 :: 		ManualEvent = 1;     // consumed by main
	BSF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,199 :: 		}
L_ProcessInputs8:
;Slave.c,202 :: 		if (cntReset > 0) cntReset--;
	MOVF       _cntReset+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_ProcessInputs11
	DECF       _cntReset+0, 1
L_ProcessInputs11:
;Slave.c,203 :: 		if (PinReset == 0) TMP_Reset1 = 0;
	BTFSC      PORTB+0, 2
	GOTO       L_ProcessInputs12
	BCF        _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
L_ProcessInputs12:
;Slave.c,204 :: 		if ((cntReset == 0) && (TMP_Reset1 == 0) && (PinReset == 1))
	MOVF       _cntReset+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs15
	BTFSC      _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
	GOTO       L_ProcessInputs15
	BTFSS      PORTB+0, 2
	GOTO       L_ProcessInputs15
L__ProcessInputs107:
;Slave.c,206 :: 		TMP_Reset1 = 1;
	BSF        _TMP_Reset1+0, BitPos(_TMP_Reset1+0)
;Slave.c,207 :: 		cntReset = DEBOUNCE_TICKS;
	MOVLW      10
	MOVWF      _cntReset+0
;Slave.c,208 :: 		ResetEvent = 1;      // consumed by main
	BSF        _ResetEvent+0, BitPos(_ResetEvent+0)
;Slave.c,209 :: 		}
L_ProcessInputs15:
;Slave.c,210 :: 		}
	RETURN
; end of _ProcessInputs

_buildStatusByte:

;Slave.c,212 :: 		unsigned char buildStatusByte()
;Slave.c,214 :: 		unsigned char status = 0x00;
	CLRF       buildStatusByte_status_L0+0
;Slave.c,215 :: 		if (PinSystemOn) status |= STATUS_SYSTEM_BIT;
	BTFSS      PORTA+0, 2
	GOTO       L_buildStatusByte16
	BSF        buildStatusByte_status_L0+0, 7
L_buildStatusByte16:
;Slave.c,216 :: 		if (PinWatering) status |= STATUS_WATER_BIT;
	BTFSS      PORTA+0, 3
	GOTO       L_buildStatusByte17
	BSF        buildStatusByte_status_L0+0, 6
L_buildStatusByte17:
;Slave.c,217 :: 		if (PinAlarm)    status |= STATUS_ALARM_BIT;
	BTFSS      PORTA+0, 4
	GOTO       L_buildStatusByte18
	BSF        buildStatusByte_status_L0+0, 5
L_buildStatusByte18:
;Slave.c,218 :: 		if (ManualMode)  status |= STATUS_MANUAL_BIT;
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_buildStatusByte19
	BSF        buildStatusByte_status_L0+0, 4
L_buildStatusByte19:
;Slave.c,219 :: 		return status;
	MOVF       buildStatusByte_status_L0+0, 0
	MOVWF      R0+0
;Slave.c,220 :: 		}
	RETURN
; end of _buildStatusByte

_toBcd:

;Slave.c,223 :: 		unsigned char toBcd(unsigned char val)
;Slave.c,226 :: 		tens = 0;
	CLRF       R2+0
;Slave.c,227 :: 		while (val > 9) { val -= 10; tens++; }
L_toBcd20:
	MOVF       FARG_toBcd_val+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_toBcd21
	MOVLW      10
	SUBWF      FARG_toBcd_val+0, 1
	INCF       R2+0, 1
	GOTO       L_toBcd20
L_toBcd21:
;Slave.c,228 :: 		return (tens << 4) | val;
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
;Slave.c,229 :: 		}
	RETURN
; end of _toBcd

_main:

;Slave.c,231 :: 		void main()
;Slave.c,233 :: 		init();
	CALL       _init+0
;Slave.c,234 :: 		init_variables();
	CALL       _init_variables+0
;Slave.c,235 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Slave.c,236 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,237 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,239 :: 		while (1)
L_main22:
;Slave.c,243 :: 		if (ResetEvent == 1)
	BTFSS      _ResetEvent+0, BitPos(_ResetEvent+0)
	GOTO       L_main24
;Slave.c,245 :: 		ResetEvent  = 0;
	BCF        _ResetEvent+0, BitPos(_ResetEvent+0)
;Slave.c,246 :: 		PinWatering = 0;
	BCF        PORTA+0, 3
;Slave.c,247 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,248 :: 		PinAlarm    = 0;
	BCF        PORTA+0, 4
;Slave.c,249 :: 		ManualMode  = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,250 :: 		ManualEvent = 0;
	BCF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,251 :: 		WateringSec = 0;
	CLRF       _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,252 :: 		}
L_main24:
;Slave.c,255 :: 		if (ManualEvent == 1)
	BTFSS      _ManualEvent+0, BitPos(_ManualEvent+0)
	GOTO       L_main25
;Slave.c,257 :: 		ManualEvent = 0;
	BCF        _ManualEvent+0, BitPos(_ManualEvent+0)
;Slave.c,258 :: 		if (ManualMode == 1)
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_main26
;Slave.c,261 :: 		WateringSec = 180;
	MOVLW      180
	MOVWF      _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,262 :: 		PinWatering = 1;
	BSF        PORTA+0, 3
;Slave.c,263 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,264 :: 		}
	GOTO       L_main27
L_main26:
;Slave.c,268 :: 		WateringSec = 0;
	CLRF       _WateringSec+0
	CLRF       _WateringSec+1
;Slave.c,269 :: 		}
L_main27:
;Slave.c,270 :: 		}
L_main25:
;Slave.c,272 :: 		if (UpdateLCDFlag == 1)
	BTFSS      _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
	GOTO       L_main28
;Slave.c,274 :: 		UpdateLCDFlag = 0;
	BCF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,278 :: 		(Seconds == 0x00) &&
	BTFSC      PORTA+0, 3
	GOTO       L_main31
	MOVF       _Seconds+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;Slave.c,279 :: 		(Hours   == ProgStartHour) &&
	MOVF       _Hours+0, 0
	XORWF      _ProgStartHour+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main31
;Slave.c,280 :: 		(Minutes == ProgStartMin))
	MOVF       _Minutes+0, 0
	XORWF      _ProgStartMin+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main31
L__main111:
;Slave.c,282 :: 		WateringSec = ((unsigned int)time_left_high << 8) | time_left_low;
	MOVF       _time_left_high+0, 0
	MOVWF      _WateringSec+0
	CLRF       _WateringSec+1
	MOVF       _WateringSec+0, 0
	MOVWF      _WateringSec+1
	CLRF       _WateringSec+0
	MOVF       _time_left_low+0, 0
	IORWF      _WateringSec+0, 1
	MOVLW      0
	IORWF      _WateringSec+1, 1
;Slave.c,283 :: 		PinWatering = 1;
	BSF        PORTA+0, 3
;Slave.c,284 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,285 :: 		}
L_main31:
;Slave.c,288 :: 		if (PinWatering == 1)
	BTFSS      PORTA+0, 3
	GOTO       L_main32
;Slave.c,290 :: 		if (WateringSec > 0) WateringSec--;
	MOVF       _WateringSec+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main118
	MOVF       _WateringSec+0, 0
	SUBLW      0
L__main118:
	BTFSC      STATUS+0, 0
	GOTO       L_main33
	MOVLW      1
	SUBWF      _WateringSec+0, 1
	BTFSS      STATUS+0, 0
	DECF       _WateringSec+1, 1
L_main33:
;Slave.c,291 :: 		if (WateringSec == 0)
	MOVLW      0
	XORWF      _WateringSec+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main119
	MOVLW      0
	XORWF      _WateringSec+0, 0
L__main119:
	BTFSS      STATUS+0, 2
	GOTO       L_main34
;Slave.c,293 :: 		PinWatering = 0;
	BCF        PORTA+0, 3
;Slave.c,294 :: 		PinSystemOn = 1;
	BSF        PORTA+0, 2
;Slave.c,295 :: 		ManualMode  = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,296 :: 		}
L_main34:
;Slave.c,297 :: 		}
L_main32:
;Slave.c,299 :: 		FlowValue = ReadADC();
	CALL       _ReadADC+0
	MOVF       R0+0, 0
	MOVWF      _FlowValue+0
;Slave.c,300 :: 		if (PinWatering == 1)
	BTFSS      PORTA+0, 3
	GOTO       L_main35
;Slave.c,302 :: 		if ((FlowValue < FlowMin) || (FlowValue > FlowMax))
	MOVF       _FlowMin+0, 0
	SUBWF      _FlowValue+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main110
	MOVF       _FlowValue+0, 0
	SUBWF      _FlowMax+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main110
	GOTO       L_main38
L__main110:
;Slave.c,303 :: 		PinAlarm = 1;
	BSF        PORTA+0, 4
	GOTO       L_main39
L_main38:
;Slave.c,305 :: 		PinAlarm = 0;
	BCF        PORTA+0, 4
L_main39:
;Slave.c,306 :: 		}
	GOTO       L_main40
L_main35:
;Slave.c,309 :: 		PinAlarm = 0;
	BCF        PORTA+0, 4
;Slave.c,310 :: 		}
L_main40:
;Slave.c,311 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,312 :: 		}
L_main28:
;Slave.c,314 :: 		if ((ByteID > 0) && (Counter2 == 0))
	MOVF       _ByteID+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main43
	MOVF       _Counter2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main43
L__main109:
;Slave.c,316 :: 		ByteID = 0;
	CLRF       _ByteID+0
;Slave.c,317 :: 		}
L_main43:
;Slave.c,318 :: 		if (CallFlag == 1)
	BTFSS      _CallFlag+0, BitPos(_CallFlag+0)
	GOTO       L_main44
;Slave.c,321 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,322 :: 		transmit(STATUS_CODE | GARDEN_ID);
	MOVLW      32
	IORWF      _GARDEN_ID+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,323 :: 		transmit(buildStatusByte());
	CALL       _buildStatusByte+0
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,324 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,325 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,326 :: 		}
L_main44:
;Slave.c,327 :: 		if (RTCSetupFlag == 1)
	BTFSS      _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
	GOTO       L_main45
;Slave.c,329 :: 		Sec_X1 = Tmp_Sec_X1;
	MOVF       _Tmp_Sec_X1+0, 0
	MOVWF      _Sec_X1+0
;Slave.c,330 :: 		Sec_X10 = Tmp_Sec_X10;
	MOVF       _Tmp_Sec_X10+0, 0
	MOVWF      _Sec_X10+0
;Slave.c,331 :: 		Min_X1 = Tmp_Min_X1;
	MOVF       _Tmp_Min_X1+0, 0
	MOVWF      _Min_X1+0
;Slave.c,332 :: 		Min_X10 = Tmp_Min_X10;
	MOVF       _Tmp_Min_X10+0, 0
	MOVWF      _Min_X10+0
;Slave.c,333 :: 		Hour_X1 = Tmp_Hour_X1;
	MOVF       _Tmp_Hour_X1+0, 0
	MOVWF      _Hour_X1+0
;Slave.c,334 :: 		Hour_X10 = Tmp_Hour_X10;
	MOVF       _Tmp_Hour_X10+0, 0
	MOVWF      _Hour_X10+0
;Slave.c,335 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,336 :: 		transmit(STATUS_CODE | GARDEN_ID);
	MOVLW      32
	IORWF      _GARDEN_ID+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,337 :: 		transmit(buildStatusByte());
	CALL       _buildStatusByte+0
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,338 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,339 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,340 :: 		}
L_main45:
;Slave.c,341 :: 		if (ProgramSetupFlag == 1)
	BTFSS      _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
	GOTO       L_main46
;Slave.c,343 :: 		ProgStartHour  = toBcd(Tmp_ProgStartHour);
	MOVF       _Tmp_ProgStartHour+0, 0
	MOVWF      FARG_toBcd_val+0
	CALL       _toBcd+0
	MOVF       R0+0, 0
	MOVWF      _ProgStartHour+0
;Slave.c,344 :: 		ProgStartMin   = toBcd(Tmp_ProgStartMin);
	MOVF       _Tmp_ProgStartMin+0, 0
	MOVWF      FARG_toBcd_val+0
	CALL       _toBcd+0
	MOVF       R0+0, 0
	MOVWF      _ProgStartMin+0
;Slave.c,345 :: 		time_left_high = Tmp_time_left_high;
	MOVF       _Tmp_time_left_high+0, 0
	MOVWF      _time_left_high+0
;Slave.c,346 :: 		time_left_low  = Tmp_time_left_low;
	MOVF       _Tmp_time_left_low+0, 0
	MOVWF      _time_left_low+0
;Slave.c,348 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,349 :: 		transmit(STATUS_CODE | GARDEN_ID);
	MOVLW      32
	IORWF      _GARDEN_ID+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,350 :: 		transmit(buildStatusByte());
	CALL       _buildStatusByte+0
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,351 :: 		ProgramSetupFlag = 0;
	BCF        _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
;Slave.c,352 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,353 :: 		}
L_main46:
;Slave.c,354 :: 		}
	GOTO       L_main22
;Slave.c,355 :: 		}
	GOTO       $+0
; end of _main

_IncrementTime:

;Slave.c,357 :: 		void IncrementTime()
;Slave.c,359 :: 		if (Sec_X1 >= 9)
	MOVLW      9
	SUBWF      _Sec_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime47
;Slave.c,361 :: 		Sec_X1 = 0;
	CLRF       _Sec_X1+0
;Slave.c,362 :: 		if (Sec_X10 >= 5)
	MOVLW      5
	SUBWF      _Sec_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime48
;Slave.c,364 :: 		Sec_X10 = 0;
	CLRF       _Sec_X10+0
;Slave.c,366 :: 		if (Min_X1 >= 9)
	MOVLW      9
	SUBWF      _Min_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime49
;Slave.c,368 :: 		Min_X1 = 0;
	CLRF       _Min_X1+0
;Slave.c,369 :: 		if (Min_X10 >= 5)
	MOVLW      5
	SUBWF      _Min_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime50
;Slave.c,371 :: 		Min_X10 = 0;
	CLRF       _Min_X10+0
;Slave.c,373 :: 		if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3)))
	MOVLW      9
	SUBWF      _Hour_X1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__IncrementTime112
	MOVLW      2
	SUBWF      _Hour_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime113
	MOVLW      3
	SUBWF      _Hour_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime113
	GOTO       L__IncrementTime112
L__IncrementTime113:
	GOTO       L_IncrementTime55
L__IncrementTime112:
;Slave.c,375 :: 		Hour_X1 = 0;
	CLRF       _Hour_X1+0
;Slave.c,376 :: 		if (Hour_X10 == 2)
	MOVF       _Hour_X10+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_IncrementTime56
;Slave.c,378 :: 		Hour_X10 = 0;
	CLRF       _Hour_X10+0
;Slave.c,379 :: 		}
	GOTO       L_IncrementTime57
L_IncrementTime56:
;Slave.c,381 :: 		Hour_X10++;
	INCF       _Hour_X10+0, 1
L_IncrementTime57:
;Slave.c,382 :: 		}
	GOTO       L_IncrementTime58
L_IncrementTime55:
;Slave.c,384 :: 		Hour_X1++;
	INCF       _Hour_X1+0, 1
L_IncrementTime58:
;Slave.c,386 :: 		}
	GOTO       L_IncrementTime59
L_IncrementTime50:
;Slave.c,388 :: 		Min_X10++;
	INCF       _Min_X10+0, 1
L_IncrementTime59:
;Slave.c,389 :: 		}
	GOTO       L_IncrementTime60
L_IncrementTime49:
;Slave.c,391 :: 		Min_X1++;
	INCF       _Min_X1+0, 1
L_IncrementTime60:
;Slave.c,393 :: 		}
	GOTO       L_IncrementTime61
L_IncrementTime48:
;Slave.c,395 :: 		Sec_X10++;
	INCF       _Sec_X10+0, 1
L_IncrementTime61:
;Slave.c,396 :: 		}
	GOTO       L_IncrementTime62
L_IncrementTime47:
;Slave.c,398 :: 		Sec_X1++;
	INCF       _Sec_X1+0, 1
L_IncrementTime62:
;Slave.c,399 :: 		}
	RETURN
; end of _IncrementTime

_ConvertTime:

;Slave.c,401 :: 		void ConvertTime(unsigned char ch)
;Slave.c,403 :: 		X1 = ch;
	MOVF       FARG_ConvertTime_ch+0, 0
	MOVWF      _X1+0
;Slave.c,404 :: 		X10 = 0x00;
	CLRF       _X10+0
;Slave.c,405 :: 		while (X1 > 9)
L_ConvertTime63:
	MOVF       _X1+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_ConvertTime64
;Slave.c,407 :: 		X1 = X1 - 10;
	MOVLW      10
	SUBWF      _X1+0, 1
;Slave.c,408 :: 		X10++;
	INCF       _X10+0, 1
;Slave.c,409 :: 		}
	GOTO       L_ConvertTime63
L_ConvertTime64:
;Slave.c,410 :: 		}
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

;Slave.c,412 :: 		void interrupt()
;Slave.c,414 :: 		GARDEN_ID = PORTD & 0x0F;
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      _GARDEN_ID+0
;Slave.c,415 :: 		if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
	BTFSS      PIE1+0, 0
	GOTO       L_interrupt67
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt67
L__interrupt117:
;Slave.c,418 :: 		PIR1.TMR1IF = 0; // brise se flag
	BCF        PIR1+0, 0
;Slave.c,420 :: 		if (Counter == 9)
	MOVF       _Counter+0, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt68
;Slave.c,422 :: 		Counter = 0;
	CLRF       _Counter+0
;Slave.c,423 :: 		IncrementTime();
	CALL       _IncrementTime+0
;Slave.c,424 :: 		DecodeTime();
	CALL       _DecodeTime+0
;Slave.c,425 :: 		UpdateLCDFlag = 1;
	BSF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,426 :: 		}
	GOTO       L_interrupt69
L_interrupt68:
;Slave.c,428 :: 		Counter++;
	INCF       _Counter+0, 1
L_interrupt69:
;Slave.c,430 :: 		if (Counter2 > 0)
	MOVF       _Counter2+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt70
;Slave.c,431 :: 		Counter2--;
	DECF       _Counter2+0, 1
	GOTO       L_interrupt71
L_interrupt70:
;Slave.c,433 :: 		Counter2 = 0;
	CLRF       _Counter2+0
L_interrupt71:
;Slave.c,435 :: 		ProcessInputs();
	CALL       _ProcessInputs+0
;Slave.c,437 :: 		TMR1H = 0x0B; // startne vrednosti tajmera 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,438 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,439 :: 		}
L_interrupt67:
;Slave.c,441 :: 		if ((PIE1.RCIE) && (PIR1.RCIF))
	BTFSS      PIE1+0, 5
	GOTO       L_interrupt74
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt74
L__interrupt116:
;Slave.c,443 :: 		ch = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      _ch+0
;Slave.c,445 :: 		if (ByteID == 0x00)
	MOVF       _ByteID+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt75
;Slave.c,447 :: 		if(((ch & 0x0F)== GARDEN_ID) && ((ch&0xE0)==0xA0))
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
L__interrupt115:
;Slave.c,449 :: 		Command=ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
;Slave.c,450 :: 		ByteID = 0x08;
	MOVLW      8
	MOVWF      _ByteID+0
;Slave.c,451 :: 		Counter2=4;
	MOVLW      4
	MOVWF      _Counter2+0
;Slave.c,452 :: 		}
	GOTO       L_interrupt79
L_interrupt78:
;Slave.c,453 :: 		else if((ch&0xE0)==0x60){
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      96
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt80
;Slave.c,454 :: 		ByteID = 0x03;
	MOVLW      3
	MOVWF      _ByteID+0
;Slave.c,455 :: 		Counter2 = 3;
	MOVLW      3
	MOVWF      _Counter2+0
;Slave.c,456 :: 		}
	GOTO       L_interrupt81
L_interrupt80:
;Slave.c,457 :: 		else if(((ch&0x0F)==GARDEN_ID)&& ((ch&0xE0)==0x20)){
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
L__interrupt114:
;Slave.c,458 :: 		Command= ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
;Slave.c,459 :: 		ByteID=0x00;
	CLRF       _ByteID+0
;Slave.c,460 :: 		}
L_interrupt84:
L_interrupt81:
L_interrupt79:
;Slave.c,461 :: 		}
	GOTO       L_interrupt85
L_interrupt75:
;Slave.c,462 :: 		else if (ByteID == 0x03)
	MOVF       _ByteID+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt86
;Slave.c,464 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,465 :: 		Tmp_Hour_X1  = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Hour_X1+0
;Slave.c,466 :: 		Tmp_Hour_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Hour_X10+0
;Slave.c,467 :: 		ByteID = 0x02;
	MOVLW      2
	MOVWF      _ByteID+0
;Slave.c,468 :: 		}
	GOTO       L_interrupt87
L_interrupt86:
;Slave.c,469 :: 		else if (ByteID == 0x02)
	MOVF       _ByteID+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt88
;Slave.c,471 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,472 :: 		Tmp_Min_X1   = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Min_X1+0
;Slave.c,473 :: 		Tmp_Min_X10  = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Min_X10+0
;Slave.c,474 :: 		ByteID = 0x01;
	MOVLW      1
	MOVWF      _ByteID+0
;Slave.c,475 :: 		}
	GOTO       L_interrupt89
L_interrupt88:
;Slave.c,476 :: 		else if (ByteID == 0x01)
	MOVF       _ByteID+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt90
;Slave.c,478 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,479 :: 		Tmp_Sec_X1   = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Sec_X1+0
;Slave.c,480 :: 		Tmp_Sec_X10  = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Sec_X10+0
;Slave.c,481 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,482 :: 		RTCSetupFlag = 1;
	BSF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,483 :: 		}
	GOTO       L_interrupt91
L_interrupt90:
;Slave.c,485 :: 		else if (ByteID == 0x08)
	MOVF       _ByteID+0, 0
	XORLW      8
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt92
;Slave.c,487 :: 		Tmp_ProgStartHour = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgStartHour+0
;Slave.c,488 :: 		ByteID = 0x07;
	MOVLW      7
	MOVWF      _ByteID+0
;Slave.c,489 :: 		}
	GOTO       L_interrupt93
L_interrupt92:
;Slave.c,490 :: 		else if (ByteID == 0x07)
	MOVF       _ByteID+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt94
;Slave.c,492 :: 		Tmp_ProgStartMin = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgStartMin+0
;Slave.c,493 :: 		ByteID = 0x06;
	MOVLW      6
	MOVWF      _ByteID+0
;Slave.c,494 :: 		}
	GOTO       L_interrupt95
L_interrupt94:
;Slave.c,495 :: 		else if (ByteID == 0x06)
	MOVF       _ByteID+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt96
;Slave.c,497 :: 		Tmp_time_left_high = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_time_left_high+0
;Slave.c,498 :: 		ByteID = 0x05;
	MOVLW      5
	MOVWF      _ByteID+0
;Slave.c,499 :: 		}
	GOTO       L_interrupt97
L_interrupt96:
;Slave.c,500 :: 		else if (ByteID == 0x05)
	MOVF       _ByteID+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt98
;Slave.c,502 :: 		Tmp_time_left_low = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_time_left_low+0
;Slave.c,503 :: 		ByteID = 0x00;
	CLRF       _ByteID+0
;Slave.c,504 :: 		ProgramSetupFlag = 1;
	BSF        _ProgramSetupFlag+0, BitPos(_ProgramSetupFlag+0)
;Slave.c,505 :: 		}
L_interrupt98:
L_interrupt97:
L_interrupt95:
L_interrupt93:
L_interrupt91:
L_interrupt89:
L_interrupt87:
L_interrupt85:
;Slave.c,506 :: 		}
L_interrupt74:
;Slave.c,507 :: 		}
L__interrupt120:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_UpdateLCD:

;Slave.c,509 :: 		void UpdateLCD()
;Slave.c,514 :: 		Lcd_Out(1, 1, "T ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,515 :: 		Lcd_Chr(1, 3,  Hour_X10 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,516 :: 		Lcd_Chr(1, 4,  Hour_X1  + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,517 :: 		Lcd_Chr(1, 5,  ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,518 :: 		Lcd_Chr(1, 6,  Min_X10  + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,519 :: 		Lcd_Chr(1, 7,  Min_X1   + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,520 :: 		Lcd_Chr(1, 8,  ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,521 :: 		Lcd_Chr(1, 9,  Sec_X10  + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,522 :: 		Lcd_Chr(1, 10, Sec_X1   + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,523 :: 		Lcd_Out(1, 12, "F:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,525 :: 		Lcd_Out(1, 14, FlowValue);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Out_column+0
	MOVF       _FlowValue+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,528 :: 		Lcd_Out(2, 1, "S:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,529 :: 		if (PinSystemOn) Lcd_Chr(2, 3,  '1'); else Lcd_Chr(2, 3,  '0');
	BTFSS      PORTA+0, 2
	GOTO       L_UpdateLCD99
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      49
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD100
L_UpdateLCD99:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD100:
;Slave.c,530 :: 		Lcd_Out(2, 5, "W:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,531 :: 		if (PinWatering) Lcd_Chr(2, 7,  '1'); else Lcd_Chr(2, 7,  '0');
	BTFSS      PORTA+0, 3
	GOTO       L_UpdateLCD101
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      49
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD102
L_UpdateLCD101:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD102:
;Slave.c,532 :: 		Lcd_Out(2, 9, "A:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,533 :: 		if (PinAlarm)    Lcd_Chr(2, 11, '1'); else Lcd_Chr(2, 11, '0');
	BTFSS      PORTA+0, 4
	GOTO       L_UpdateLCD103
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      49
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD104
L_UpdateLCD103:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD104:
;Slave.c,534 :: 		Lcd_Out(2, 13, "M:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,535 :: 		if (ManualMode)  Lcd_Chr(2, 15, '1'); else Lcd_Chr(2, 15, '0');
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_UpdateLCD105
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      49
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD106
L_UpdateLCD105:
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD106:
;Slave.c,536 :: 		}
	RETURN
; end of _UpdateLCD

_init:

;Slave.c,538 :: 		void init()
;Slave.c,542 :: 		TRISA = 0x03;
	MOVLW      3
	MOVWF      TRISA+0
;Slave.c,544 :: 		TRISB = 0x3F;
	MOVLW      63
	MOVWF      TRISB+0
;Slave.c,545 :: 		TRISC = 0xC0; // pinovi 6 i 7 su vezani za RS232
	MOVLW      192
	MOVWF      TRISC+0
;Slave.c,547 :: 		TRISD = 0x0F; // pinovi 6 i 7 su vezani za RS232
	MOVLW      15
	MOVWF      TRISD+0
;Slave.c,549 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;Slave.c,550 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;Slave.c,551 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Slave.c,553 :: 		ADCON1 = 0b00001110;
	MOVLW      14
	MOVWF      ADCON1+0
;Slave.c,554 :: 		ADCON0 = 0b10000001;
	MOVLW      129
	MOVWF      ADCON0+0
;Slave.c,557 :: 		INTCON = 0b11000000; // default
	MOVLW      192
	MOVWF      INTCON+0
;Slave.c,558 :: 		PIE1 = 0b00000000;   // default
	CLRF       PIE1+0
;Slave.c,560 :: 		T1CON = 0b00110000; // konfiguracija za Tajmer 1
	MOVLW      48
	MOVWF      T1CON+0
;Slave.c,562 :: 		TMR1H = 0x0B; // startne vrednosti tajmera 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,563 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,564 :: 		T1CON.TMR1ON = 1;
	BSF        T1CON+0, 0
;Slave.c,572 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,573 :: 		PIE1.TMR1IE = 1;
	BSF        PIE1+0, 0
;Slave.c,575 :: 		Uart1_Init(19200);
	MOVLW      64
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave.c,578 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;Slave.c,579 :: 		RCSTA.SPEN = 1;
	BSF        RCSTA+0, 7
;Slave.c,580 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;Slave.c,581 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;Slave.c,583 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;Slave.c,585 :: 		}
	RETURN
; end of _init
