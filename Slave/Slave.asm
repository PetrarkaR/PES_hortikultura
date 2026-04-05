
_init_variables:

;Slave.c,102 :: 		void init_variables()
;Slave.c,105 :: 		RAMP_ID = 0x00;
	CLRF       _RAMP_ID+0
;Slave.c,106 :: 		Category = 0x00;
	CLRF       _Category+0
;Slave.c,107 :: 		Operation = 0;
	BCF        _Operation+0, BitPos(_Operation+0)
;Slave.c,108 :: 		Event = 0;
	BCF        _Event+0, BitPos(_Event+0)
;Slave.c,109 :: 		RampOpen = 0;
	BCF        _RampOpen+0, BitPos(_RampOpen+0)
;Slave.c,110 :: 		EXTRampOpen = 0;
	BCF        _EXTRampOpen+0, BitPos(_EXTRampOpen+0)
;Slave.c,111 :: 		Error = 0;
	BCF        _Error+0, BitPos(_Error+0)
;Slave.c,112 :: 		Sensor = 0;
	BCF        _Sensor+0, BitPos(_Sensor+0)
;Slave.c,113 :: 		Operation2 = 0;
	BCF        _Operation2+0, BitPos(_Operation2+0)
;Slave.c,114 :: 		RampOpen2 = 0;
	BCF        _RampOpen2+0, BitPos(_RampOpen2+0)
;Slave.c,116 :: 		TMP_Taster2 = 0;
	BCF        _TMP_Taster2+0, BitPos(_TMP_Taster2+0)
;Slave.c,117 :: 		TMP_Taster1 = 0;
	BCF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
;Slave.c,119 :: 		TMP_Sensor2 = 0;
	BCF        _TMP_Sensor2+0, BitPos(_TMP_Sensor2+0)
;Slave.c,120 :: 		TMP_Sensor1 = 0;
	BCF        _TMP_Sensor1+0, BitPos(_TMP_Sensor1+0)
;Slave.c,122 :: 		TMP_Error2 = 0;
	BCF        _TMP_Error2+0, BitPos(_TMP_Error2+0)
;Slave.c,123 :: 		TMP_Error1 = 0;
	BCF        _TMP_Error1+0, BitPos(_TMP_Error1+0)
;Slave.c,125 :: 		TMP_EXTRampOpen2 = 0;
	BCF        _TMP_EXTRampOpen2+0, BitPos(_TMP_EXTRampOpen2+0)
;Slave.c,126 :: 		TMP_EXTRampOpen1 = 0;
	BCF        _TMP_EXTRampOpen1+0, BitPos(_TMP_EXTRampOpen1+0)
;Slave.c,127 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,128 :: 		ch = 0x00;
	CLRF       _ch+0
;Slave.c,129 :: 		Command = 0x00;
	CLRF       _Command+0
;Slave.c,130 :: 		CommandModified = 0x00;
	CLRF       _CommandModified+0
;Slave.c,131 :: 		Counter = 0x00;
	CLRF       _Counter+0
;Slave.c,132 :: 		Counter2 = 0x00;
	CLRF       _Counter2+0
;Slave.c,133 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,134 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,135 :: 		UpdateLCDFlag = 0;
	BCF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,136 :: 		Sec_X1 = 0x00;
	CLRF       _Sec_X1+0
;Slave.c,137 :: 		Sec_X10 = 0x00;
	CLRF       _Sec_X10+0
;Slave.c,138 :: 		Min_X1 = 0x00;
	CLRF       _Min_X1+0
;Slave.c,139 :: 		Min_X10 = 0x00;
	CLRF       _Min_X10+0
;Slave.c,140 :: 		Hour_X1 = 0x00;
	CLRF       _Hour_X1+0
;Slave.c,141 :: 		Hour_X10 = 0x00;
	CLRF       _Hour_X10+0
;Slave.c,142 :: 		Tmp_Sec_X1 = 0x00;
	CLRF       _Tmp_Sec_X1+0
;Slave.c,143 :: 		Tmp_Sec_X10 = 0x00;
	CLRF       _Tmp_Sec_X10+0
;Slave.c,144 :: 		Tmp_Min_X1 = 0x00;
	CLRF       _Tmp_Min_X1+0
;Slave.c,145 :: 		Tmp_Min_X10 = 0x00;
	CLRF       _Tmp_Min_X10+0
;Slave.c,146 :: 		Tmp_Hour_X1 = 0x00;
	CLRF       _Tmp_Hour_X1+0
;Slave.c,147 :: 		Tmp_Hour_X10 = 0x00;
	CLRF       _Tmp_Hour_X10+0
;Slave.c,149 :: 		Seconds = 0x00;
	CLRF       _Seconds+0
;Slave.c,150 :: 		Minutes = 0x00;
	CLRF       _Minutes+0
;Slave.c,151 :: 		Hours = 0x00;
	CLRF       _Hours+0
;Slave.c,152 :: 		}
	RETURN
; end of _init_variables

_transmit:

;Slave.c,154 :: 		void transmit(unsigned char DATA8b)
;Slave.c,157 :: 		TXREG = DATA8b;
	MOVF       FARG_transmit_DATA8b+0, 0
	MOVWF      TXREG+0
;Slave.c,158 :: 		while (!TXSTA.TRMT)
L_transmit0:
	BTFSC      TXSTA+0, 1
	GOTO       L_transmit1
;Slave.c,159 :: 		;
	GOTO       L_transmit0
L_transmit1:
;Slave.c,160 :: 		}
	RETURN
; end of _transmit

_DecodeTime:

;Slave.c,162 :: 		void DecodeTime()
;Slave.c,164 :: 		Seconds = (Sec_X10 << 4) + Sec_X1;
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
;Slave.c,165 :: 		Minutes = (Min_X10 << 4) + Min_X1;
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
;Slave.c,166 :: 		Hours = (Hour_X10 << 4) + Hour_X1;
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
;Slave.c,167 :: 		}
	RETURN
; end of _DecodeTime

_ProcessInputs:

;Slave.c,169 :: 		void ProcessInputs()
;Slave.c,171 :: 		TMP_Taster2 = TMP_Taster1;
	BTFSC      _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
	GOTO       L__ProcessInputs118
	BCF        _TMP_Taster2+0, BitPos(_TMP_Taster2+0)
	GOTO       L__ProcessInputs119
L__ProcessInputs118:
	BSF        _TMP_Taster2+0, BitPos(_TMP_Taster2+0)
L__ProcessInputs119:
;Slave.c,172 :: 		if (PinTaster == 1)
	BTFSS      PORTB+0, 0
	GOTO       L_ProcessInputs2
;Slave.c,173 :: 		TMP_Taster1 = 1; // aktivan 1
	BSF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
	GOTO       L_ProcessInputs3
L_ProcessInputs2:
;Slave.c,175 :: 		TMP_Taster1 = 0;
	BCF        _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
L_ProcessInputs3:
;Slave.c,176 :: 		if ((TMP_Taster2 == 1) && (TMP_Taster1 == 1))
	BTFSS      _TMP_Taster2+0, BitPos(_TMP_Taster2+0)
	GOTO       L_ProcessInputs6
	BTFSS      _TMP_Taster1+0, BitPos(_TMP_Taster1+0)
	GOTO       L_ProcessInputs6
L__ProcessInputs112:
;Slave.c,178 :: 		Event = 1;
	BSF        _Event+0, BitPos(_Event+0)
;Slave.c,179 :: 		PinEvent = 1;
	BSF        PORTA+0, 4
;Slave.c,180 :: 		}
L_ProcessInputs6:
;Slave.c,182 :: 		TMP_Sensor2 = TMP_Sensor1;
	BTFSC      _TMP_Sensor1+0, BitPos(_TMP_Sensor1+0)
	GOTO       L__ProcessInputs120
	BCF        _TMP_Sensor2+0, BitPos(_TMP_Sensor2+0)
	GOTO       L__ProcessInputs121
L__ProcessInputs120:
	BSF        _TMP_Sensor2+0, BitPos(_TMP_Sensor2+0)
L__ProcessInputs121:
;Slave.c,183 :: 		if (PinSensor == 1)
	BTFSS      PORTB+0, 1
	GOTO       L_ProcessInputs7
;Slave.c,184 :: 		TMP_Sensor1 = 1; // aktivan 1
	BSF        _TMP_Sensor1+0, BitPos(_TMP_Sensor1+0)
	GOTO       L_ProcessInputs8
L_ProcessInputs7:
;Slave.c,186 :: 		TMP_Sensor1 = 0;
	BCF        _TMP_Sensor1+0, BitPos(_TMP_Sensor1+0)
L_ProcessInputs8:
;Slave.c,187 :: 		if ((TMP_Sensor2 == 1) && (TMP_Sensor1 == 1))
	BTFSS      _TMP_Sensor2+0, BitPos(_TMP_Sensor2+0)
	GOTO       L_ProcessInputs11
	BTFSS      _TMP_Sensor1+0, BitPos(_TMP_Sensor1+0)
	GOTO       L_ProcessInputs11
L__ProcessInputs111:
;Slave.c,188 :: 		RampOpen = 0;
	BCF        _RampOpen+0, BitPos(_RampOpen+0)
L_ProcessInputs11:
;Slave.c,190 :: 		TMP_Error2 = TMP_Error1;
	BTFSC      _TMP_Error1+0, BitPos(_TMP_Error1+0)
	GOTO       L__ProcessInputs122
	BCF        _TMP_Error2+0, BitPos(_TMP_Error2+0)
	GOTO       L__ProcessInputs123
L__ProcessInputs122:
	BSF        _TMP_Error2+0, BitPos(_TMP_Error2+0)
L__ProcessInputs123:
;Slave.c,191 :: 		if (PinError == 1)
	BTFSS      PORTB+0, 4
	GOTO       L_ProcessInputs12
;Slave.c,192 :: 		TMP_Error1 = 1; // aktivan 1
	BSF        _TMP_Error1+0, BitPos(_TMP_Error1+0)
	GOTO       L_ProcessInputs13
L_ProcessInputs12:
;Slave.c,194 :: 		TMP_Error1 = 0;
	BCF        _TMP_Error1+0, BitPos(_TMP_Error1+0)
L_ProcessInputs13:
;Slave.c,195 :: 		if ((TMP_Error2 == 1) && (TMP_Error1 == 1))
	BTFSS      _TMP_Error2+0, BitPos(_TMP_Error2+0)
	GOTO       L_ProcessInputs16
	BTFSS      _TMP_Error1+0, BitPos(_TMP_Error1+0)
	GOTO       L_ProcessInputs16
L__ProcessInputs110:
;Slave.c,196 :: 		Error = 1;
	BSF        _Error+0, BitPos(_Error+0)
	GOTO       L_ProcessInputs17
L_ProcessInputs16:
;Slave.c,197 :: 		else if ((TMP_Error2 == 0) && (TMP_Error1 == 0))
	BTFSC      _TMP_Error2+0, BitPos(_TMP_Error2+0)
	GOTO       L_ProcessInputs20
	BTFSC      _TMP_Error1+0, BitPos(_TMP_Error1+0)
	GOTO       L_ProcessInputs20
L__ProcessInputs109:
;Slave.c,198 :: 		Error = 0;
	BCF        _Error+0, BitPos(_Error+0)
L_ProcessInputs20:
L_ProcessInputs17:
;Slave.c,200 :: 		TMP_EXTRampOpen2 = TMP_EXTRampOpen1;
	BTFSC      _TMP_EXTRampOpen1+0, BitPos(_TMP_EXTRampOpen1+0)
	GOTO       L__ProcessInputs124
	BCF        _TMP_EXTRampOpen2+0, BitPos(_TMP_EXTRampOpen2+0)
	GOTO       L__ProcessInputs125
L__ProcessInputs124:
	BSF        _TMP_EXTRampOpen2+0, BitPos(_TMP_EXTRampOpen2+0)
L__ProcessInputs125:
;Slave.c,201 :: 		if (PinEXTRampOpen == 1)
	BTFSS      PORTB+0, 5
	GOTO       L_ProcessInputs21
;Slave.c,202 :: 		TMP_EXTRampOpen1 = 1; // aktivan 1
	BSF        _TMP_EXTRampOpen1+0, BitPos(_TMP_EXTRampOpen1+0)
	GOTO       L_ProcessInputs22
L_ProcessInputs21:
;Slave.c,204 :: 		TMP_EXTRampOpen1 = 0;
	BCF        _TMP_EXTRampOpen1+0, BitPos(_TMP_EXTRampOpen1+0)
L_ProcessInputs22:
;Slave.c,206 :: 		if ((TMP_EXTRampOpen2 == 1) && (TMP_EXTRampOpen1 == 1))
	BTFSS      _TMP_EXTRampOpen2+0, BitPos(_TMP_EXTRampOpen2+0)
	GOTO       L_ProcessInputs25
	BTFSS      _TMP_EXTRampOpen1+0, BitPos(_TMP_EXTRampOpen1+0)
	GOTO       L_ProcessInputs25
L__ProcessInputs108:
;Slave.c,207 :: 		EXTRampOpen = 1;
	BSF        _EXTRampOpen+0, BitPos(_EXTRampOpen+0)
	GOTO       L_ProcessInputs26
L_ProcessInputs25:
;Slave.c,208 :: 		else if ((TMP_EXTRampOpen2 == 0) && (TMP_EXTRampOpen1 == 0))
	BTFSC      _TMP_EXTRampOpen2+0, BitPos(_TMP_EXTRampOpen2+0)
	GOTO       L_ProcessInputs29
	BTFSC      _TMP_EXTRampOpen1+0, BitPos(_TMP_EXTRampOpen1+0)
	GOTO       L_ProcessInputs29
L__ProcessInputs107:
;Slave.c,209 :: 		EXTRampOpen = 0;
	BCF        _EXTRampOpen+0, BitPos(_EXTRampOpen+0)
L_ProcessInputs29:
L_ProcessInputs26:
;Slave.c,211 :: 		if (PORTD.F2 == 1)
	BTFSS      PORTD+0, 2
	GOTO       L_ProcessInputs30
;Slave.c,212 :: 		if (PORTD.F3 == 1)
	BTFSS      PORTD+0, 3
	GOTO       L_ProcessInputs31
;Slave.c,213 :: 		Category = 0x03;
	MOVLW      3
	MOVWF      _Category+0
	GOTO       L_ProcessInputs32
L_ProcessInputs31:
;Slave.c,215 :: 		Category = 0x02;
	MOVLW      2
	MOVWF      _Category+0
L_ProcessInputs32:
	GOTO       L_ProcessInputs33
L_ProcessInputs30:
;Slave.c,216 :: 		else if (PORTD.F3 == 1)
	BTFSS      PORTD+0, 3
	GOTO       L_ProcessInputs34
;Slave.c,217 :: 		Category = 0x01;
	MOVLW      1
	MOVWF      _Category+0
	GOTO       L_ProcessInputs35
L_ProcessInputs34:
;Slave.c,219 :: 		Category = 0x00;
	CLRF       _Category+0
L_ProcessInputs35:
L_ProcessInputs33:
;Slave.c,220 :: 		}
	RETURN
; end of _ProcessInputs

_main:

;Slave.c,222 :: 		void main()
;Slave.c,224 :: 		init();
	CALL       _init+0
;Slave.c,225 :: 		init_variables();
	CALL       _init_variables+0
;Slave.c,226 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Slave.c,227 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,228 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,230 :: 		while (1)
L_main36:
;Slave.c,233 :: 		RampOpen2 = RampOpen | EXTRampOpen;
	BTFSC      _RampOpen+0, BitPos(_RampOpen+0)
	GOTO       L__main126
	BTFSC      _EXTRampOpen+0, BitPos(_EXTRampOpen+0)
	GOTO       L__main126
	BCF        _RampOpen2+0, BitPos(_RampOpen2+0)
	GOTO       L__main127
L__main126:
	BSF        _RampOpen2+0, BitPos(_RampOpen2+0)
L__main127:
;Slave.c,234 :: 		if (Error == 1)
	BTFSS      _Error+0, BitPos(_Error+0)
	GOTO       L_main38
;Slave.c,235 :: 		Operation2 = 0;
	BCF        _Operation2+0, BitPos(_Operation2+0)
	GOTO       L_main39
L_main38:
;Slave.c,237 :: 		Operation2 = Operation;
	BTFSC      _Operation+0, BitPos(_Operation+0)
	GOTO       L__main128
	BCF        _Operation2+0, BitPos(_Operation2+0)
	GOTO       L__main129
L__main128:
	BSF        _Operation2+0, BitPos(_Operation2+0)
L__main129:
L_main39:
;Slave.c,238 :: 		PinOperation = Operation2;
	BTFSC      _Operation2+0, BitPos(_Operation2+0)
	GOTO       L__main130
	BCF        PORTA+0, 2
	GOTO       L__main131
L__main130:
	BSF        PORTA+0, 2
L__main131:
;Slave.c,239 :: 		PinRampOpen = RampOpen2;
	BTFSC      _RampOpen2+0, BitPos(_RampOpen2+0)
	GOTO       L__main132
	BCF        PORTA+0, 3
	GOTO       L__main133
L__main132:
	BSF        PORTA+0, 3
L__main133:
;Slave.c,240 :: 		if (UpdateLCDFlag == 1)
	BTFSS      _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
	GOTO       L_main40
;Slave.c,242 :: 		UpdateLCDFlag = 0;
	BCF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,243 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,244 :: 		}
L_main40:
;Slave.c,246 :: 		if ((BytesToReceive > 0) && (Counter2 == 0))
	MOVF       _BytesToReceive+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main43
	MOVF       _Counter2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main43
L__main113:
;Slave.c,248 :: 		BytesToReceive = 0;
	CLRF       _BytesToReceive+0
;Slave.c,249 :: 		}
L_main43:
;Slave.c,250 :: 		if (CallFlag == 1)
	BTFSS      _CallFlag+0, BitPos(_CallFlag+0)
	GOTO       L_main44
;Slave.c,252 :: 		if ((Command & 0x10) == 0x10)
	MOVLW      16
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      16
	BTFSS      STATUS+0, 2
	GOTO       L_main45
;Slave.c,253 :: 		Operation = 1;
	BSF        _Operation+0, BitPos(_Operation+0)
	GOTO       L_main46
L_main45:
;Slave.c,255 :: 		Operation = 0;
	BCF        _Operation+0, BitPos(_Operation+0)
L_main46:
;Slave.c,256 :: 		if (Error == 1)
	BTFSS      _Error+0, BitPos(_Error+0)
	GOTO       L_main47
;Slave.c,259 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,260 :: 		if (Operation == 0x01)
	BTFSS      _Operation+0, BitPos(_Operation+0)
	GOTO       L_main48
;Slave.c,261 :: 		CommandModified = 0b00010000 | RAMP_ID;
	MOVLW      16
	IORWF      _RAMP_ID+0, 0
	MOVWF      _CommandModified+0
	GOTO       L_main49
L_main48:
;Slave.c,263 :: 		CommandModified = 0b00000000 | RAMP_ID;
	MOVF       _RAMP_ID+0, 0
	MOVWF      _CommandModified+0
L_main49:
;Slave.c,264 :: 		transmit(CommandModified);
	MOVF       _CommandModified+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,265 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,266 :: 		}
	GOTO       L_main50
L_main47:
;Slave.c,267 :: 		else if (Event == 0)
	BTFSC      _Event+0, BitPos(_Event+0)
	GOTO       L_main51
;Slave.c,271 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,272 :: 		if (Operation == 1)
	BTFSS      _Operation+0, BitPos(_Operation+0)
	GOTO       L_main52
;Slave.c,273 :: 		CommandModified = 0b00110000 | RAMP_ID;
	MOVLW      48
	IORWF      _RAMP_ID+0, 0
	MOVWF      _CommandModified+0
	GOTO       L_main53
L_main52:
;Slave.c,275 :: 		CommandModified = 0b00100000 | RAMP_ID;
	MOVLW      32
	IORWF      _RAMP_ID+0, 0
	MOVWF      _CommandModified+0
L_main53:
;Slave.c,276 :: 		transmit(CommandModified);
	MOVF       _CommandModified+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,277 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,278 :: 		}
	GOTO       L_main54
L_main51:
;Slave.c,285 :: 		if (Operation == 1)
	BTFSS      _Operation+0, BitPos(_Operation+0)
	GOTO       L_main55
;Slave.c,287 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,288 :: 		CommandModified = 0b01010000 | RAMP_ID;
	MOVLW      80
	IORWF      _RAMP_ID+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _CommandModified+0
;Slave.c,289 :: 		transmit(CommandModified);
	MOVF       R0+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,290 :: 		transmit(Seconds);
	MOVF       _Seconds+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,291 :: 		transmit(Minutes);
	MOVF       _Minutes+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,292 :: 		transmit(Hours);
	MOVF       _Hours+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,293 :: 		transmit(Category);
	MOVF       _Category+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,294 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,295 :: 		Event = 0;
	BCF        _Event+0, BitPos(_Event+0)
;Slave.c,296 :: 		PinEvent = 0;
	BCF        PORTA+0, 4
;Slave.c,297 :: 		RampOpen = 1;
	BSF        _RampOpen+0, BitPos(_RampOpen+0)
;Slave.c,298 :: 		}
L_main55:
;Slave.c,299 :: 		}
L_main54:
L_main50:
;Slave.c,300 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,301 :: 		}
L_main44:
;Slave.c,302 :: 		if (RTCSetupFlag == 1)
	BTFSS      _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
	GOTO       L_main56
;Slave.c,304 :: 		Sec_X1 = Tmp_Sec_X1;
	MOVF       _Tmp_Sec_X1+0, 0
	MOVWF      _Sec_X1+0
;Slave.c,305 :: 		Sec_X10 = Tmp_Sec_X10;
	MOVF       _Tmp_Sec_X10+0, 0
	MOVWF      _Sec_X10+0
;Slave.c,306 :: 		Min_X1 = Tmp_Min_X1;
	MOVF       _Tmp_Min_X1+0, 0
	MOVWF      _Min_X1+0
;Slave.c,307 :: 		Min_X10 = Tmp_Min_X10;
	MOVF       _Tmp_Min_X10+0, 0
	MOVWF      _Min_X10+0
;Slave.c,308 :: 		Hour_X1 = Tmp_Hour_X1;
	MOVF       _Tmp_Hour_X1+0, 0
	MOVWF      _Hour_X1+0
;Slave.c,309 :: 		Hour_X10 = Tmp_Hour_X10;
	MOVF       _Tmp_Hour_X10+0, 0
	MOVWF      _Hour_X10+0
;Slave.c,310 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,311 :: 		if (Operation == 1)
	BTFSS      _Operation+0, BitPos(_Operation+0)
	GOTO       L_main57
;Slave.c,312 :: 		CommandModified = 0b01110000 | RAMP_ID;
	MOVLW      112
	IORWF      _RAMP_ID+0, 0
	MOVWF      _CommandModified+0
	GOTO       L_main58
L_main57:
;Slave.c,314 :: 		CommandModified = 0b01100000 | RAMP_ID;
	MOVLW      96
	IORWF      _RAMP_ID+0, 0
	MOVWF      _CommandModified+0
L_main58:
;Slave.c,315 :: 		transmit(CommandModified);
	MOVF       _CommandModified+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,316 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,317 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,318 :: 		}
L_main56:
;Slave.c,319 :: 		}
	GOTO       L_main36
;Slave.c,320 :: 		}
	GOTO       $+0
; end of _main

_IncrementTime:

;Slave.c,322 :: 		void IncrementTime()
;Slave.c,324 :: 		if (Sec_X1 >= 9)
	MOVLW      9
	SUBWF      _Sec_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime59
;Slave.c,326 :: 		Sec_X1 = 0;
	CLRF       _Sec_X1+0
;Slave.c,327 :: 		if (Sec_X10 >= 5)
	MOVLW      5
	SUBWF      _Sec_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime60
;Slave.c,329 :: 		Sec_X10 = 0;
	CLRF       _Sec_X10+0
;Slave.c,331 :: 		if (Min_X1 >= 9)
	MOVLW      9
	SUBWF      _Min_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime61
;Slave.c,333 :: 		Min_X1 = 0;
	CLRF       _Min_X1+0
;Slave.c,334 :: 		if (Min_X10 >= 5)
	MOVLW      5
	SUBWF      _Min_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime62
;Slave.c,336 :: 		Min_X10 = 0;
	CLRF       _Min_X10+0
;Slave.c,338 :: 		if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3)))
	MOVLW      9
	SUBWF      _Hour_X1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__IncrementTime114
	MOVLW      2
	SUBWF      _Hour_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime115
	MOVLW      3
	SUBWF      _Hour_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime115
	GOTO       L__IncrementTime114
L__IncrementTime115:
	GOTO       L_IncrementTime67
L__IncrementTime114:
;Slave.c,340 :: 		Hour_X1 = 0;
	CLRF       _Hour_X1+0
;Slave.c,341 :: 		if (Hour_X10 == 2)
	MOVF       _Hour_X10+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_IncrementTime68
;Slave.c,343 :: 		Hour_X10 = 0;
	CLRF       _Hour_X10+0
;Slave.c,344 :: 		}
	GOTO       L_IncrementTime69
L_IncrementTime68:
;Slave.c,346 :: 		Hour_X10++;
	INCF       _Hour_X10+0, 1
L_IncrementTime69:
;Slave.c,347 :: 		}
	GOTO       L_IncrementTime70
L_IncrementTime67:
;Slave.c,349 :: 		Hour_X1++;
	INCF       _Hour_X1+0, 1
L_IncrementTime70:
;Slave.c,351 :: 		}
	GOTO       L_IncrementTime71
L_IncrementTime62:
;Slave.c,353 :: 		Min_X10++;
	INCF       _Min_X10+0, 1
L_IncrementTime71:
;Slave.c,354 :: 		}
	GOTO       L_IncrementTime72
L_IncrementTime61:
;Slave.c,356 :: 		Min_X1++;
	INCF       _Min_X1+0, 1
L_IncrementTime72:
;Slave.c,358 :: 		}
	GOTO       L_IncrementTime73
L_IncrementTime60:
;Slave.c,360 :: 		Sec_X10++;
	INCF       _Sec_X10+0, 1
L_IncrementTime73:
;Slave.c,361 :: 		}
	GOTO       L_IncrementTime74
L_IncrementTime59:
;Slave.c,363 :: 		Sec_X1++;
	INCF       _Sec_X1+0, 1
L_IncrementTime74:
;Slave.c,364 :: 		}
	RETURN
; end of _IncrementTime

_ConvertTime:

;Slave.c,366 :: 		void ConvertTime(unsigned char ch)
;Slave.c,368 :: 		X1 = ch;
	MOVF       FARG_ConvertTime_ch+0, 0
	MOVWF      _X1+0
;Slave.c,369 :: 		X10 = 0x00;
	CLRF       _X10+0
;Slave.c,370 :: 		while (X1 > 9)
L_ConvertTime75:
	MOVF       _X1+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_ConvertTime76
;Slave.c,372 :: 		X1 = X1 - 10;
	MOVLW      10
	SUBWF      _X1+0, 1
;Slave.c,373 :: 		X10++;
	INCF       _X10+0, 1
;Slave.c,374 :: 		}
	GOTO       L_ConvertTime75
L_ConvertTime76:
;Slave.c,375 :: 		}
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

;Slave.c,377 :: 		void interrupt()
;Slave.c,379 :: 		if ((PIE1.TMR1IE) && (PIR1.TMR1IF))
	BTFSS      PIE1+0, 0
	GOTO       L_interrupt79
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt79
L__interrupt117:
;Slave.c,382 :: 		PIR1.TMR1IF = 0; // brise se flag
	BCF        PIR1+0, 0
;Slave.c,384 :: 		if (Counter == 9)
	MOVF       _Counter+0, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt80
;Slave.c,386 :: 		Counter = 0;
	CLRF       _Counter+0
;Slave.c,387 :: 		IncrementTime();
	CALL       _IncrementTime+0
;Slave.c,388 :: 		DecodeTime();
	CALL       _DecodeTime+0
;Slave.c,389 :: 		UpdateLCDFlag = 1;
	BSF        _UpdateLCDFlag+0, BitPos(_UpdateLCDFlag+0)
;Slave.c,390 :: 		}
	GOTO       L_interrupt81
L_interrupt80:
;Slave.c,392 :: 		Counter++;
	INCF       _Counter+0, 1
L_interrupt81:
;Slave.c,394 :: 		if (Counter2 > 0)
	MOVF       _Counter2+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt82
;Slave.c,395 :: 		Counter2--;
	DECF       _Counter2+0, 1
	GOTO       L_interrupt83
L_interrupt82:
;Slave.c,397 :: 		Counter2 = 0;
	CLRF       _Counter2+0
L_interrupt83:
;Slave.c,399 :: 		ProcessInputs();
	CALL       _ProcessInputs+0
;Slave.c,401 :: 		TMR1H = 0x0B; // startne vrednosti tajmera 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,402 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,403 :: 		}
L_interrupt79:
;Slave.c,405 :: 		if ((PIE1.RCIE) && (PIR1.RCIF))
	BTFSS      PIE1+0, 5
	GOTO       L_interrupt86
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt86
L__interrupt116:
;Slave.c,407 :: 		ch = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      _ch+0
;Slave.c,408 :: 		if (BytesToReceive == 0x00)
	MOVF       _BytesToReceive+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt87
;Slave.c,410 :: 		if ((ch & 0x0F) == RAMP_ID)
	MOVLW      15
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORWF      _RAMP_ID+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt88
;Slave.c,413 :: 		Command = ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
;Slave.c,414 :: 		if ((ch & 0xE0) == 0x20)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt89
;Slave.c,417 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,418 :: 		CallFlag = 1;
	BSF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,419 :: 		}
	GOTO       L_interrupt90
L_interrupt89:
;Slave.c,420 :: 		else if ((ch & 0xE0) == 0x60)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      96
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt91
;Slave.c,424 :: 		BytesToReceive = 0x03;
	MOVLW      3
	MOVWF      _BytesToReceive+0
;Slave.c,425 :: 		Counter2 = 3;
	MOVLW      3
	MOVWF      _Counter2+0
;Slave.c,428 :: 		}
L_interrupt91:
L_interrupt90:
;Slave.c,429 :: 		}
L_interrupt88:
;Slave.c,430 :: 		}
	GOTO       L_interrupt92
L_interrupt87:
;Slave.c,431 :: 		else if (BytesToReceive == 0x03)
	MOVF       _BytesToReceive+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt93
;Slave.c,433 :: 		BytesToReceive = 0x02;
	MOVLW      2
	MOVWF      _BytesToReceive+0
;Slave.c,434 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,435 :: 		if (ch > 59)
	MOVF       R1+0, 0
	SUBLW      59
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt94
;Slave.c,436 :: 		ch = 59;
	MOVLW      59
	MOVWF      _ch+0
L_interrupt94:
;Slave.c,437 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,438 :: 		Tmp_Sec_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Sec_X1+0
;Slave.c,439 :: 		Tmp_Sec_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Sec_X10+0
;Slave.c,440 :: 		}
	GOTO       L_interrupt95
L_interrupt93:
;Slave.c,441 :: 		else if (BytesToReceive == 0x02)
	MOVF       _BytesToReceive+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt96
;Slave.c,443 :: 		BytesToReceive = 0x01;
	MOVLW      1
	MOVWF      _BytesToReceive+0
;Slave.c,444 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,445 :: 		if (ch > 59)
	MOVF       R1+0, 0
	SUBLW      59
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt97
;Slave.c,446 :: 		ch = 59;
	MOVLW      59
	MOVWF      _ch+0
L_interrupt97:
;Slave.c,447 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,448 :: 		Tmp_Min_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Min_X1+0
;Slave.c,449 :: 		Tmp_Min_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Min_X10+0
;Slave.c,450 :: 		}
	GOTO       L_interrupt98
L_interrupt96:
;Slave.c,451 :: 		else if (BytesToReceive == 0x01)
	MOVF       _BytesToReceive+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt99
;Slave.c,453 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,454 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,455 :: 		if (ch > 23)
	MOVF       R1+0, 0
	SUBLW      23
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt100
;Slave.c,456 :: 		ch = 23;
	MOVLW      23
	MOVWF      _ch+0
L_interrupt100:
;Slave.c,457 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,458 :: 		Tmp_Hour_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Hour_X1+0
;Slave.c,459 :: 		Tmp_Hour_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Hour_X10+0
;Slave.c,460 :: 		RTCSetupFlag = 1;
	BSF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,461 :: 		}
L_interrupt99:
L_interrupt98:
L_interrupt95:
L_interrupt92:
;Slave.c,462 :: 		}
L_interrupt86:
;Slave.c,463 :: 		}
L__interrupt134:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_UpdateLCD:

;Slave.c,465 :: 		void UpdateLCD()
;Slave.c,467 :: 		Lcd_Out(1, 1, "Time:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,468 :: 		Lcd_Chr(1, 6, (Hour_X10 + 0x30));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,469 :: 		Lcd_Chr(1, 7, (Hour_X1 + 0x30));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,470 :: 		Lcd_Chr(1, 8, ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,471 :: 		Lcd_Chr(1, 9, (Min_X10 + 0x30));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,472 :: 		Lcd_Chr(1, 10, (Min_X1 + 0x30));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,473 :: 		Lcd_Chr(1, 11, ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,474 :: 		Lcd_Chr(1, 12, (Sec_X10 + 0x30));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,475 :: 		Lcd_Chr(1, 13, (Sec_X1 + 0x30));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,476 :: 		if (Operation2 == 0x01)
	BTFSS      _Operation2+0, BitPos(_Operation2+0)
	GOTO       L_UpdateLCD101
;Slave.c,477 :: 		Lcd_Out(2, 1, "Operating");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_UpdateLCD102
L_UpdateLCD101:
;Slave.c,478 :: 		else if (Error == 0x01)
	BTFSS      _Error+0, BitPos(_Error+0)
	GOTO       L_UpdateLCD103
;Slave.c,479 :: 		Lcd_Out(2, 1, "Error    ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_UpdateLCD104
L_UpdateLCD103:
;Slave.c,481 :: 		Lcd_Out(2, 1, "         ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_UpdateLCD104:
L_UpdateLCD102:
;Slave.c,482 :: 		if (RampOpen2 == 0x01)
	BTFSS      _RampOpen2+0, BitPos(_RampOpen2+0)
	GOTO       L_UpdateLCD105
;Slave.c,483 :: 		Lcd_Out(2, 11, "Opened");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_UpdateLCD106
L_UpdateLCD105:
;Slave.c,485 :: 		Lcd_Out(2, 11, "Closed");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_UpdateLCD106:
;Slave.c,486 :: 		}
	RETURN
; end of _UpdateLCD

_init:

;Slave.c,487 :: 		void init()
;Slave.c,491 :: 		TRISA = 0x03;
	MOVLW      3
	MOVWF      TRISA+0
;Slave.c,493 :: 		TRISB = 0x3F;
	MOVLW      63
	MOVWF      TRISB+0
;Slave.c,494 :: 		TRISC = 0xC0; // pinovi 6 i 7 su vezani za RS232
	MOVLW      192
	MOVWF      TRISC+0
;Slave.c,496 :: 		TRISD = 0x0F; // pinovi 6 i 7 su vezani za RS232
	MOVLW      15
	MOVWF      TRISD+0
;Slave.c,498 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;Slave.c,499 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;Slave.c,500 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Slave.c,502 :: 		ADCON0 = 0x00;       //iskljucujemo A/D konverziju
	CLRF       ADCON0+0
;Slave.c,503 :: 		ADCON1 = 0b00000110; //svi digitalni pinovi
	MOVLW      6
	MOVWF      ADCON1+0
;Slave.c,505 :: 		INTCON = 0b11000000; // default
	MOVLW      192
	MOVWF      INTCON+0
;Slave.c,506 :: 		PIE1 = 0b00000000;   // default
	CLRF       PIE1+0
;Slave.c,508 :: 		T1CON = 0b00110000; // konfiguracija za Tajmer 1
	MOVLW      48
	MOVWF      T1CON+0
;Slave.c,510 :: 		TMR1H = 0x0B; // startne vrednosti tajmera 1
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,511 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,512 :: 		T1CON.TMR1ON = 1;
	BSF        T1CON+0, 0
;Slave.c,520 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,521 :: 		PIE1.TMR1IE = 1;
	BSF        PIE1+0, 0
;Slave.c,523 :: 		Uart1_Init(19200);
	MOVLW      64
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave.c,526 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;Slave.c,527 :: 		RCSTA.SPEN = 1;
	BSF        RCSTA+0, 7
;Slave.c,528 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;Slave.c,529 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;Slave.c,531 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;Slave.c,533 :: 		}
	RETURN
; end of _init
