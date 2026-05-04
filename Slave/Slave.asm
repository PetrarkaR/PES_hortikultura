
_transmit:

;Slave.c,213 :: 		void transmit(unsigned char DATA8b)
;Slave.c,217 :: 		TXREG = DATA8b;
	MOVF       FARG_transmit_DATA8b+0, 0
	MOVWF      TXREG+0
;Slave.c,219 :: 		while (!TXSTA.TRMT)
L_transmit0:
	BTFSC      TXSTA+0, 1
	GOTO       L_transmit1
;Slave.c,221 :: 		;
	GOTO       L_transmit0
L_transmit1:
;Slave.c,222 :: 		}
	RETURN
; end of _transmit

_DecodeTime:

;Slave.c,224 :: 		void DecodeTime()
;Slave.c,228 :: 		Seconds = (Sec_X10 << 4) + Sec_X1;
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
;Slave.c,230 :: 		Minutes = (Min_X10 << 4) + Min_X1;
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
;Slave.c,232 :: 		Hours = (Hour_X10 << 4) + Hour_X1;
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
;Slave.c,233 :: 		}
	RETURN
; end of _DecodeTime

_ReadADC:

;Slave.c,235 :: 		unsigned char ReadADC()
;Slave.c,239 :: 		ADCON0.GO_DONE = 1;
	BSF        ADCON0+0, 2
;Slave.c,241 :: 		while (ADCON0.GO_DONE)
L_ReadADC2:
	BTFSS      ADCON0+0, 2
	GOTO       L_ReadADC3
;Slave.c,243 :: 		;
	GOTO       L_ReadADC2
L_ReadADC3:
;Slave.c,245 :: 		return ADRESH;
	MOVF       ADRESH+0, 0
	MOVWF      R0+0
;Slave.c,246 :: 		}
	RETURN
; end of _ReadADC

_ProcessInputs:

;Slave.c,248 :: 		void ProcessInputs()
;Slave.c,254 :: 		TMP_Btn2 = TMP_Btn1;
	BTFSC      _TMP_Btn1+0, BitPos(_TMP_Btn1+0)
	GOTO       L__ProcessInputs138
	BCF        _TMP_Btn2+0, BitPos(_TMP_Btn2+0)
	GOTO       L__ProcessInputs139
L__ProcessInputs138:
	BSF        _TMP_Btn2+0, BitPos(_TMP_Btn2+0)
L__ProcessInputs139:
;Slave.c,256 :: 		if (PinManualBtn == 1)
	BTFSS      PORTB+0, 0
	GOTO       L_ProcessInputs4
;Slave.c,258 :: 		TMP_Btn1 = 1;
	BSF        _TMP_Btn1+0, BitPos(_TMP_Btn1+0)
	GOTO       L_ProcessInputs5
L_ProcessInputs4:
;Slave.c,262 :: 		TMP_Btn1 = 0;
	BCF        _TMP_Btn1+0, BitPos(_TMP_Btn1+0)
L_ProcessInputs5:
;Slave.c,264 :: 		if ((TMP_Btn2 == 0) && (TMP_Btn1 == 1))
	BTFSC      _TMP_Btn2+0, BitPos(_TMP_Btn2+0)
	GOTO       L_ProcessInputs8
	BTFSS      _TMP_Btn1+0, BitPos(_TMP_Btn1+0)
	GOTO       L_ProcessInputs8
L__ProcessInputs132:
;Slave.c,268 :: 		if (SystemOn == 1)
	BTFSS      _SystemOn+0, BitPos(_SystemOn+0)
	GOTO       L_ProcessInputs9
;Slave.c,272 :: 		if (WateringActive == 1)
	BTFSS      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_ProcessInputs10
;Slave.c,276 :: 		WateringActive = 0;
	BCF        _WateringActive+0, BitPos(_WateringActive+0)
;Slave.c,278 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,280 :: 		RemainingH = 0;
	CLRF       _RemainingH+0
;Slave.c,282 :: 		RemainingL = 0;
	CLRF       _RemainingL+0
;Slave.c,284 :: 		PinPump = 0;
	BCF        PORTA+0, 2
;Slave.c,286 :: 		AlarmActive = 0;
	BCF        _AlarmActive+0, BitPos(_AlarmActive+0)
;Slave.c,288 :: 		PinAlarm = 0;
	BCF        PORTA+0, 3
;Slave.c,290 :: 		}
	GOTO       L_ProcessInputs11
L_ProcessInputs10:
;Slave.c,296 :: 		WateringActive = 1;
	BSF        _WateringActive+0, BitPos(_WateringActive+0)
;Slave.c,298 :: 		ManualMode = 1;
	BSF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,300 :: 		RemainingH = ProgDurationH;
	MOVF       _ProgDurationH+0, 0
	MOVWF      _RemainingH+0
;Slave.c,302 :: 		RemainingL = ProgDurationL;
	MOVF       _ProgDurationL+0, 0
	MOVWF      _RemainingL+0
;Slave.c,304 :: 		PinPump = 1;
	BSF        PORTA+0, 2
;Slave.c,305 :: 		}
L_ProcessInputs11:
;Slave.c,306 :: 		}
L_ProcessInputs9:
;Slave.c,307 :: 		}
L_ProcessInputs8:
;Slave.c,311 :: 		FlowValue = ReadADC();
	CALL       _ReadADC+0
	MOVF       R0+0, 0
	MOVWF      _FlowValue+0
;Slave.c,315 :: 		if (WateringActive == 1)
	BTFSS      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_ProcessInputs12
;Slave.c,319 :: 		if ((FlowValue < FlowMin) || (FlowValue > FlowMax))
	MOVF       _FlowMin+0, 0
	SUBWF      _FlowValue+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__ProcessInputs131
	MOVF       _FlowValue+0, 0
	SUBWF      _FlowMax+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__ProcessInputs131
	GOTO       L_ProcessInputs15
L__ProcessInputs131:
;Slave.c,323 :: 		AlarmActive = 1;
	BSF        _AlarmActive+0, BitPos(_AlarmActive+0)
;Slave.c,325 :: 		PinAlarm = 1;
	BSF        PORTA+0, 3
;Slave.c,327 :: 		FlowOK = 0;
	BCF        _FlowOK+0, BitPos(_FlowOK+0)
;Slave.c,329 :: 		}
	GOTO       L_ProcessInputs16
L_ProcessInputs15:
;Slave.c,335 :: 		AlarmActive = 0;
	BCF        _AlarmActive+0, BitPos(_AlarmActive+0)
;Slave.c,337 :: 		PinAlarm = 0;
	BCF        PORTA+0, 3
;Slave.c,339 :: 		FlowOK = 1;
	BSF        _FlowOK+0, BitPos(_FlowOK+0)
;Slave.c,340 :: 		}
L_ProcessInputs16:
;Slave.c,342 :: 		}
	GOTO       L_ProcessInputs17
L_ProcessInputs12:
;Slave.c,348 :: 		AlarmActive = 0;
	BCF        _AlarmActive+0, BitPos(_AlarmActive+0)
;Slave.c,350 :: 		PinAlarm = 0;
	BCF        PORTA+0, 3
;Slave.c,352 :: 		FlowOK = 1;
	BSF        _FlowOK+0, BitPos(_FlowOK+0)
;Slave.c,353 :: 		}
L_ProcessInputs17:
;Slave.c,357 :: 		SLAVE_ID = PORTD & 0x0F;
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      _SLAVE_ID+0
;Slave.c,361 :: 		if ((SystemOn == 1) && (WateringActive == 0))
	BTFSS      _SystemOn+0, BitPos(_SystemOn+0)
	GOTO       L_ProcessInputs20
	BTFSC      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_ProcessInputs20
L__ProcessInputs130:
;Slave.c,365 :: 		if ((Hour_X10 * 10 + Hour_X1 == ProgStartHour) &&
	MOVF       _Hour_X10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       _Hour_X1+0, 0
	ADDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R2+1
;Slave.c,367 :: 		(Min_X10 * 10 + Min_X1 == ProgStartMin) &&
	MOVLW      0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ProcessInputs140
	MOVF       _ProgStartHour+0, 0
	XORWF      R2+0, 0
L__ProcessInputs140:
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs23
	MOVF       _Min_X10+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8x8_U+0
	MOVF       _Min_X1+0, 0
	ADDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R2+1
	MOVLW      0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ProcessInputs141
	MOVF       _ProgStartMin+0, 0
	XORWF      R2+0, 0
L__ProcessInputs141:
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs23
;Slave.c,369 :: 		(Sec_X10 == 0) && (Sec_X1 == 0))
	MOVF       _Sec_X10+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs23
	MOVF       _Sec_X1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs23
L__ProcessInputs129:
;Slave.c,373 :: 		WateringActive = 1;
	BSF        _WateringActive+0, BitPos(_WateringActive+0)
;Slave.c,375 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,377 :: 		RemainingH = ProgDurationH;
	MOVF       _ProgDurationH+0, 0
	MOVWF      _RemainingH+0
;Slave.c,379 :: 		RemainingL = ProgDurationL;
	MOVF       _ProgDurationL+0, 0
	MOVWF      _RemainingL+0
;Slave.c,381 :: 		PinPump = 1;
	BSF        PORTA+0, 2
;Slave.c,382 :: 		}
L_ProcessInputs23:
;Slave.c,383 :: 		}
L_ProcessInputs20:
;Slave.c,387 :: 		if (WateringActive == 1)
	BTFSS      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_ProcessInputs24
;Slave.c,391 :: 		if ((RemainingH == 0) && (RemainingL == 0))
	MOVF       _RemainingH+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs27
	MOVF       _RemainingL+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_ProcessInputs27
L__ProcessInputs128:
;Slave.c,395 :: 		WateringActive = 0;
	BCF        _WateringActive+0, BitPos(_WateringActive+0)
;Slave.c,397 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,399 :: 		PinPump = 0;
	BCF        PORTA+0, 2
;Slave.c,401 :: 		AlarmActive = 0;
	BCF        _AlarmActive+0, BitPos(_AlarmActive+0)
;Slave.c,403 :: 		PinAlarm = 0;
	BCF        PORTA+0, 3
;Slave.c,405 :: 		}
	GOTO       L_ProcessInputs28
L_ProcessInputs27:
;Slave.c,411 :: 		if (RemainingL > 0)
	MOVF       _RemainingL+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_ProcessInputs29
;Slave.c,413 :: 		RemainingL--;
	DECF       _RemainingL+0, 1
	GOTO       L_ProcessInputs30
L_ProcessInputs29:
;Slave.c,419 :: 		RemainingL = 0xFF;
	MOVLW      255
	MOVWF      _RemainingL+0
;Slave.c,421 :: 		if (RemainingH > 0)
	MOVF       _RemainingH+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_ProcessInputs31
;Slave.c,423 :: 		RemainingH--;
	DECF       _RemainingH+0, 1
L_ProcessInputs31:
;Slave.c,424 :: 		}
L_ProcessInputs30:
;Slave.c,425 :: 		}
L_ProcessInputs28:
;Slave.c,426 :: 		}
L_ProcessInputs24:
;Slave.c,430 :: 		if (SystemOn == 1)
	BTFSS      _SystemOn+0, BitPos(_SystemOn+0)
	GOTO       L_ProcessInputs32
;Slave.c,432 :: 		PinStatusLED = 1;
	BSF        PORTA+0, 4
	GOTO       L_ProcessInputs33
L_ProcessInputs32:
;Slave.c,436 :: 		PinStatusLED = 0;
	BCF        PORTA+0, 4
L_ProcessInputs33:
;Slave.c,437 :: 		}
	RETURN
; end of _ProcessInputs

_main:

;Slave.c,439 :: 		void main()
;Slave.c,443 :: 		init();
	CALL       _init+0
;Slave.c,445 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Slave.c,447 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,449 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Slave.c,451 :: 		SLAVE_ID = PORTD & 0x0F;
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      _SLAVE_ID+0
;Slave.c,453 :: 		FlagDisp = 1;
	BSF        _FlagDisp+0, BitPos(_FlagDisp+0)
;Slave.c,455 :: 		while (1)
L_main34:
;Slave.c,461 :: 		if ((BytesToReceive > 0) && (Counter2 == 0))
	MOVF       _BytesToReceive+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_main38
	MOVF       _Counter2+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main38
L__main133:
;Slave.c,463 :: 		BytesToReceive = 0;
	CLRF       _BytesToReceive+0
L_main38:
;Slave.c,467 :: 		if (FlagDisp == 1)
	BTFSS      _FlagDisp+0, BitPos(_FlagDisp+0)
	GOTO       L_main39
;Slave.c,471 :: 		FlagDisp = 0;
	BCF        _FlagDisp+0, BitPos(_FlagDisp+0)
;Slave.c,473 :: 		UpdateLCD();
	CALL       _UpdateLCD+0
;Slave.c,474 :: 		}
L_main39:
;Slave.c,478 :: 		if (RTCSetupFlag == 1)
	BTFSS      _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
	GOTO       L_main40
;Slave.c,482 :: 		RTCSetupFlag = 0;
	BCF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,484 :: 		Sec_X1 = Tmp_Sec_X1;
	MOVF       _Tmp_Sec_X1+0, 0
	MOVWF      _Sec_X1+0
;Slave.c,486 :: 		Sec_X10 = Tmp_Sec_X10;
	MOVF       _Tmp_Sec_X10+0, 0
	MOVWF      _Sec_X10+0
;Slave.c,488 :: 		Min_X1 = Tmp_Min_X1;
	MOVF       _Tmp_Min_X1+0, 0
	MOVWF      _Min_X1+0
;Slave.c,490 :: 		Min_X10 = Tmp_Min_X10;
	MOVF       _Tmp_Min_X10+0, 0
	MOVWF      _Min_X10+0
;Slave.c,492 :: 		Hour_X1 = Tmp_Hour_X1;
	MOVF       _Tmp_Hour_X1+0, 0
	MOVWF      _Hour_X1+0
;Slave.c,494 :: 		Hour_X10 = Tmp_Hour_X10;
	MOVF       _Tmp_Hour_X10+0, 0
	MOVWF      _Hour_X10+0
;Slave.c,496 :: 		SendStatus();
	CALL       _SendStatus+0
;Slave.c,497 :: 		}
L_main40:
;Slave.c,501 :: 		if (FlowSetupFlag == 1)
	BTFSS      _FlowSetupFlag+0, BitPos(_FlowSetupFlag+0)
	GOTO       L_main41
;Slave.c,505 :: 		FlowSetupFlag = 0;
	BCF        _FlowSetupFlag+0, BitPos(_FlowSetupFlag+0)
;Slave.c,507 :: 		FlowMin = Tmp_FlowMin;
	MOVF       _Tmp_FlowMin+0, 0
	MOVWF      _FlowMin+0
;Slave.c,509 :: 		FlowMax = Tmp_FlowMax;
	MOVF       _Tmp_FlowMax+0, 0
	MOVWF      _FlowMax+0
;Slave.c,511 :: 		SendStatus();
	CALL       _SendStatus+0
;Slave.c,512 :: 		}
L_main41:
;Slave.c,516 :: 		if (ProgSetupFlag == 1)
	BTFSS      _ProgSetupFlag+0, BitPos(_ProgSetupFlag+0)
	GOTO       L_main42
;Slave.c,520 :: 		ProgSetupFlag = 0;
	BCF        _ProgSetupFlag+0, BitPos(_ProgSetupFlag+0)
;Slave.c,522 :: 		ProgramMode = Tmp_ProgramMode;
	MOVF       _Tmp_ProgramMode+0, 0
	MOVWF      _ProgramMode+0
;Slave.c,524 :: 		ProgStartHour = Tmp_ProgStartHour;
	MOVF       _Tmp_ProgStartHour+0, 0
	MOVWF      _ProgStartHour+0
;Slave.c,526 :: 		ProgStartMin = Tmp_ProgStartMin;
	MOVF       _Tmp_ProgStartMin+0, 0
	MOVWF      _ProgStartMin+0
;Slave.c,528 :: 		ProgDurationH = Tmp_ProgDurationH;
	MOVF       _Tmp_ProgDurationH+0, 0
	MOVWF      _ProgDurationH+0
;Slave.c,530 :: 		ProgDurationL = Tmp_ProgDurationL;
	MOVF       _Tmp_ProgDurationL+0, 0
	MOVWF      _ProgDurationL+0
;Slave.c,532 :: 		SendStatus();
	CALL       _SendStatus+0
;Slave.c,533 :: 		}
L_main42:
;Slave.c,537 :: 		if (GardenSetupFlag == 1)
	BTFSS      _GardenSetupFlag+0, BitPos(_GardenSetupFlag+0)
	GOTO       L_main43
;Slave.c,541 :: 		GardenSetupFlag = 0;
	BCF        _GardenSetupFlag+0, BitPos(_GardenSetupFlag+0)
;Slave.c,543 :: 		ProgramMode = Tmp_ProgramMode;
	MOVF       _Tmp_ProgramMode+0, 0
	MOVWF      _ProgramMode+0
;Slave.c,545 :: 		SendStatus();
	CALL       _SendStatus+0
;Slave.c,546 :: 		}
L_main43:
;Slave.c,550 :: 		if (CallFlag == 1)
	BTFSS      _CallFlag+0, BitPos(_CallFlag+0)
	GOTO       L_main44
;Slave.c,554 :: 		CallFlag = 0;
	BCF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,556 :: 		SendStatus();
	CALL       _SendStatus+0
;Slave.c,557 :: 		}
L_main44:
;Slave.c,558 :: 		}
	GOTO       L_main34
;Slave.c,559 :: 		}
	GOTO       $+0
; end of _main

_IncrementTime:

;Slave.c,561 :: 		void IncrementTime()
;Slave.c,565 :: 		if (Sec_X1 >= 9)
	MOVLW      9
	SUBWF      _Sec_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime45
;Slave.c,569 :: 		Sec_X1 = 0;
	CLRF       _Sec_X1+0
;Slave.c,571 :: 		if (Sec_X10 >= 5)
	MOVLW      5
	SUBWF      _Sec_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime46
;Slave.c,575 :: 		Sec_X10 = 0;
	CLRF       _Sec_X10+0
;Slave.c,579 :: 		if (Min_X1 >= 9)
	MOVLW      9
	SUBWF      _Min_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime47
;Slave.c,583 :: 		Min_X1 = 0;
	CLRF       _Min_X1+0
;Slave.c,585 :: 		if (Min_X10 >= 5)
	MOVLW      5
	SUBWF      _Min_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_IncrementTime48
;Slave.c,589 :: 		Min_X10 = 0;
	CLRF       _Min_X10+0
;Slave.c,593 :: 		if ((Hour_X1 >= 9) || ((Hour_X10 >= 2) && (Hour_X1 >= 3)))
	MOVLW      9
	SUBWF      _Hour_X1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__IncrementTime134
	MOVLW      2
	SUBWF      _Hour_X10+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime135
	MOVLW      3
	SUBWF      _Hour_X1+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__IncrementTime135
	GOTO       L__IncrementTime134
L__IncrementTime135:
	GOTO       L_IncrementTime53
L__IncrementTime134:
;Slave.c,597 :: 		Hour_X1 = 0;
	CLRF       _Hour_X1+0
;Slave.c,599 :: 		if (Hour_X10 == 2)
	MOVF       _Hour_X10+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_IncrementTime54
;Slave.c,603 :: 		Hour_X10 = 0;
	CLRF       _Hour_X10+0
;Slave.c,605 :: 		}
	GOTO       L_IncrementTime55
L_IncrementTime54:
;Slave.c,609 :: 		Hour_X10++;
	INCF       _Hour_X10+0, 1
L_IncrementTime55:
;Slave.c,611 :: 		}
	GOTO       L_IncrementTime56
L_IncrementTime53:
;Slave.c,615 :: 		Hour_X1++;
	INCF       _Hour_X1+0, 1
L_IncrementTime56:
;Slave.c,619 :: 		}
	GOTO       L_IncrementTime57
L_IncrementTime48:
;Slave.c,623 :: 		Min_X10++;
	INCF       _Min_X10+0, 1
L_IncrementTime57:
;Slave.c,625 :: 		}
	GOTO       L_IncrementTime58
L_IncrementTime47:
;Slave.c,629 :: 		Min_X1++;
	INCF       _Min_X1+0, 1
L_IncrementTime58:
;Slave.c,633 :: 		}
	GOTO       L_IncrementTime59
L_IncrementTime46:
;Slave.c,637 :: 		Sec_X10++;
	INCF       _Sec_X10+0, 1
L_IncrementTime59:
;Slave.c,639 :: 		}
	GOTO       L_IncrementTime60
L_IncrementTime45:
;Slave.c,643 :: 		Sec_X1++;
	INCF       _Sec_X1+0, 1
L_IncrementTime60:
;Slave.c,644 :: 		}
	RETURN
; end of _IncrementTime

_ConvertTime:

;Slave.c,646 :: 		void ConvertTime(unsigned char ch)
;Slave.c,650 :: 		X1 = ch;
	MOVF       FARG_ConvertTime_ch+0, 0
	MOVWF      _X1+0
;Slave.c,652 :: 		X10 = 0x00;
	CLRF       _X10+0
;Slave.c,654 :: 		while (X1 > 9)
L_ConvertTime61:
	MOVF       _X1+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_ConvertTime62
;Slave.c,658 :: 		X1 = X1 - 10;
	MOVLW      10
	SUBWF      _X1+0, 1
;Slave.c,660 :: 		X10++;
	INCF       _X10+0, 1
;Slave.c,661 :: 		}
	GOTO       L_ConvertTime61
L_ConvertTime62:
;Slave.c,662 :: 		}
	RETURN
; end of _ConvertTime

_HexDigit:

;Slave.c,664 :: 		unsigned char HexDigit(unsigned char val)
;Slave.c,668 :: 		val = val & 0x0F;
	MOVLW      15
	ANDWF      FARG_HexDigit_val+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      FARG_HexDigit_val+0
;Slave.c,670 :: 		if (val < 10)
	MOVLW      10
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_HexDigit63
;Slave.c,672 :: 		return val + '0';
	MOVLW      48
	ADDWF      FARG_HexDigit_val+0, 0
	MOVWF      R0+0
	RETURN
L_HexDigit63:
;Slave.c,674 :: 		return val + 'A' - 10;
	MOVLW      65
	ADDWF      FARG_HexDigit_val+0, 0
	MOVWF      R0+0
	MOVLW      10
	SUBWF      R0+0, 1
;Slave.c,675 :: 		}
	RETURN
; end of _HexDigit

_LcdByteHex:

;Slave.c,677 :: 		void LcdByteHex(unsigned char row, unsigned char col, unsigned char val)
;Slave.c,681 :: 		Lcd_Chr(row, col, HexDigit(val >> 4));
	MOVF       FARG_LcdByteHex_val+0, 0
	MOVWF      FARG_HexDigit_val+0
	RRF        FARG_HexDigit_val+0, 1
	BCF        FARG_HexDigit_val+0, 7
	RRF        FARG_HexDigit_val+0, 1
	BCF        FARG_HexDigit_val+0, 7
	RRF        FARG_HexDigit_val+0, 1
	BCF        FARG_HexDigit_val+0, 7
	RRF        FARG_HexDigit_val+0, 1
	BCF        FARG_HexDigit_val+0, 7
	CALL       _HexDigit+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVF       FARG_LcdByteHex_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_LcdByteHex_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	CALL       _Lcd_Chr+0
;Slave.c,683 :: 		Lcd_Chr(row, col + 1, HexDigit(val));
	MOVF       FARG_LcdByteHex_val+0, 0
	MOVWF      FARG_HexDigit_val+0
	CALL       _HexDigit+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVF       FARG_LcdByteHex_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	INCF       FARG_LcdByteHex_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	CALL       _Lcd_Chr+0
;Slave.c,684 :: 		}
	RETURN
; end of _LcdByteHex

_LcdByteDec2:

;Slave.c,686 :: 		void LcdByteDec2(unsigned char row, unsigned char col, unsigned char val)
;Slave.c,692 :: 		unsigned char tens = 0x00;
	CLRF       LcdByteDec2_tens_L0+0
;Slave.c,693 :: 		ones = val  ;
	MOVF       FARG_LcdByteDec2_val+0, 0
	MOVWF      LcdByteDec2_ones_L0+0
;Slave.c,694 :: 		while (ones > 9)
L_LcdByteDec264:
	MOVF       LcdByteDec2_ones_L0+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_LcdByteDec265
;Slave.c,698 :: 		ones = ones - 10;
	MOVLW      10
	SUBWF      LcdByteDec2_ones_L0+0, 1
;Slave.c,700 :: 		tens++;
	INCF       LcdByteDec2_tens_L0+0, 1
;Slave.c,701 :: 		}
	GOTO       L_LcdByteDec264
L_LcdByteDec265:
;Slave.c,703 :: 		Lcd_Chr(row, col, tens + '0');
	MOVF       FARG_LcdByteDec2_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_LcdByteDec2_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      LcdByteDec2_tens_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,705 :: 		Lcd_Chr(row, col + 1, ones + '0');
	MOVF       FARG_LcdByteDec2_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	INCF       FARG_LcdByteDec2_col+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      LcdByteDec2_ones_L0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,706 :: 		}
	RETURN
; end of _LcdByteDec2

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Slave.c,708 :: 		void interrupt()
;Slave.c,714 :: 		if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1))
	BTFSS      PIE1+0, 0
	GOTO       L_interrupt68
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt68
L__interrupt137:
;Slave.c,718 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,722 :: 		if (Counter == 9)
	MOVF       _Counter+0, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt69
;Slave.c,726 :: 		Counter = 0;
	CLRF       _Counter+0
;Slave.c,728 :: 		IncrementTime();
	CALL       _IncrementTime+0
;Slave.c,730 :: 		DecodeTime();
	CALL       _DecodeTime+0
;Slave.c,732 :: 		ProcessInputs();
	CALL       _ProcessInputs+0
;Slave.c,734 :: 		FlagDisp = 1;
	BSF        _FlagDisp+0, BitPos(_FlagDisp+0)
;Slave.c,736 :: 		}
	GOTO       L_interrupt70
L_interrupt69:
;Slave.c,740 :: 		Counter++;
	INCF       _Counter+0, 1
L_interrupt70:
;Slave.c,744 :: 		if (Counter2 > 0)
	MOVF       _Counter2+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt71
;Slave.c,746 :: 		Counter2--;
	DECF       _Counter2+0, 1
	GOTO       L_interrupt72
L_interrupt71:
;Slave.c,750 :: 		Counter2 = 0;
	CLRF       _Counter2+0
L_interrupt72:
;Slave.c,752 :: 		TMR1H = 0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,754 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,755 :: 		}
L_interrupt68:
;Slave.c,775 :: 		if ((PIE1.RCIE) && (PIR1.RCIF))
	BTFSS      PIE1+0, 5
	GOTO       L_interrupt75
	BTFSS      PIR1+0, 5
	GOTO       L_interrupt75
L__interrupt136:
;Slave.c,779 :: 		ch = RCREG;
	MOVF       RCREG+0, 0
	MOVWF      _ch+0
;Slave.c,781 :: 		PIR1.RCIF = 0;
	BCF        PIR1+0, 5
;Slave.c,783 :: 		if (BytesToReceive == 0x00)
	MOVF       _BytesToReceive+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt76
;Slave.c,787 :: 		if ((ch & CMD_ID_MASK) == SLAVE_ID)
	MOVLW      15
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORWF      _SLAVE_ID+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt77
;Slave.c,791 :: 		Command = ch;
	MOVF       _ch+0, 0
	MOVWF      _Command+0
;Slave.c,793 :: 		if ((ch & CMD_TYPE_MASK) == STATUS_CODE)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      32
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt78
;Slave.c,797 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,799 :: 		CallFlag = 1;
	BSF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,801 :: 		}
	GOTO       L_interrupt79
L_interrupt78:
;Slave.c,803 :: 		else if ((ch & CMD_TYPE_MASK) == RTC_CODE)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      96
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt80
;Slave.c,807 :: 		BytesToReceive = RTC_BYTES;  // 3
	MOVLW      3
	MOVWF      _BytesToReceive+0
;Slave.c,809 :: 		Counter2 = 3;
	MOVLW      3
	MOVWF      _Counter2+0
;Slave.c,811 :: 		}
	GOTO       L_interrupt81
L_interrupt80:
;Slave.c,813 :: 		else if ((ch & CMD_TYPE_MASK) == GARDEN_CODE)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt82
;Slave.c,817 :: 		BytesToReceive = GARDEN_BYTES;  // 1
	MOVLW      1
	MOVWF      _BytesToReceive+0
;Slave.c,819 :: 		Counter2 = 3;
	MOVLW      3
	MOVWF      _Counter2+0
;Slave.c,821 :: 		}
	GOTO       L_interrupt83
L_interrupt82:
;Slave.c,823 :: 		else if ((ch & CMD_TYPE_MASK) == MODE_CODE)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt84
;Slave.c,827 :: 		BytesToReceive = MODE_BYTES;  // 5
	MOVLW      5
	MOVWF      _BytesToReceive+0
;Slave.c,829 :: 		Counter2 = 5;
	MOVLW      5
	MOVWF      _Counter2+0
;Slave.c,831 :: 		}
	GOTO       L_interrupt85
L_interrupt84:
;Slave.c,833 :: 		else if ((ch & CMD_TYPE_MASK) == CONTROL_CODE)
	MOVLW      224
	ANDWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      192
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt86
;Slave.c,837 :: 		BytesToReceive = CONTROL_BYTES;  // 1
	MOVLW      1
	MOVWF      _BytesToReceive+0
;Slave.c,839 :: 		Counter2 = 3;
	MOVLW      3
	MOVWF      _Counter2+0
;Slave.c,840 :: 		}
L_interrupt86:
L_interrupt85:
L_interrupt83:
L_interrupt81:
L_interrupt79:
;Slave.c,841 :: 		}
L_interrupt77:
;Slave.c,843 :: 		}
	GOTO       L_interrupt87
L_interrupt76:
;Slave.c,845 :: 		else if (BytesToReceive == 0x05)
	MOVF       _BytesToReceive+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt88
;Slave.c,849 :: 		BytesToReceive = 0x04;
	MOVLW      4
	MOVWF      _BytesToReceive+0
;Slave.c,851 :: 		Tmp_ProgramMode = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgramMode+0
;Slave.c,853 :: 		}
	GOTO       L_interrupt89
L_interrupt88:
;Slave.c,855 :: 		else if (BytesToReceive == 0x04)
	MOVF       _BytesToReceive+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt90
;Slave.c,859 :: 		BytesToReceive = 0x03;
	MOVLW      3
	MOVWF      _BytesToReceive+0
;Slave.c,861 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,863 :: 		if (ch > 23)
	MOVF       R1+0, 0
	SUBLW      23
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt91
;Slave.c,865 :: 		ch = 23;
	MOVLW      23
	MOVWF      _ch+0
L_interrupt91:
;Slave.c,867 :: 		Tmp_ProgStartHour = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgStartHour+0
;Slave.c,869 :: 		}
	GOTO       L_interrupt92
L_interrupt90:
;Slave.c,871 :: 		else if (BytesToReceive == 0x03)
	MOVF       _BytesToReceive+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt93
;Slave.c,875 :: 		if ((Command & CMD_TYPE_MASK) == RTC_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      96
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt94
;Slave.c,879 :: 		BytesToReceive = 0x02;
	MOVLW      2
	MOVWF      _BytesToReceive+0
;Slave.c,881 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,883 :: 		if (ch > 23)
	MOVF       R1+0, 0
	SUBLW      23
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt95
;Slave.c,885 :: 		ch = 23;
	MOVLW      23
	MOVWF      _ch+0
L_interrupt95:
;Slave.c,887 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,889 :: 		Tmp_Hour_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Hour_X1+0
;Slave.c,891 :: 		Tmp_Hour_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Hour_X10+0
;Slave.c,893 :: 		}
	GOTO       L_interrupt96
L_interrupt94:
;Slave.c,895 :: 		else if ((Command & CMD_TYPE_MASK) == MODE_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt97
;Slave.c,899 :: 		BytesToReceive = 0x02;
	MOVLW      2
	MOVWF      _BytesToReceive+0
;Slave.c,901 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,903 :: 		if (ch > 59)
	MOVF       R1+0, 0
	SUBLW      59
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt98
;Slave.c,905 :: 		ch = 59;
	MOVLW      59
	MOVWF      _ch+0
L_interrupt98:
;Slave.c,907 :: 		Tmp_ProgStartMin = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgStartMin+0
;Slave.c,908 :: 		}
L_interrupt97:
L_interrupt96:
;Slave.c,910 :: 		}
	GOTO       L_interrupt99
L_interrupt93:
;Slave.c,912 :: 		else if (BytesToReceive == 0x02)
	MOVF       _BytesToReceive+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt100
;Slave.c,916 :: 		if ((Command & CMD_TYPE_MASK) == RTC_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      96
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt101
;Slave.c,920 :: 		BytesToReceive = 0x01;
	MOVLW      1
	MOVWF      _BytesToReceive+0
;Slave.c,922 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,924 :: 		if (ch > 59)
	MOVF       R1+0, 0
	SUBLW      59
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt102
;Slave.c,926 :: 		ch = 59;
	MOVLW      59
	MOVWF      _ch+0
L_interrupt102:
;Slave.c,928 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,930 :: 		Tmp_Min_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Min_X1+0
;Slave.c,932 :: 		Tmp_Min_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Min_X10+0
;Slave.c,934 :: 		}
	GOTO       L_interrupt103
L_interrupt101:
;Slave.c,936 :: 		else if ((Command & CMD_TYPE_MASK) == MODE_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt104
;Slave.c,940 :: 		BytesToReceive = 0x01;
	MOVLW      1
	MOVWF      _BytesToReceive+0
;Slave.c,942 :: 		Tmp_ProgDurationH = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgDurationH+0
;Slave.c,943 :: 		}
L_interrupt104:
L_interrupt103:
;Slave.c,945 :: 		}
	GOTO       L_interrupt105
L_interrupt100:
;Slave.c,947 :: 		else if (BytesToReceive == 0x01)
	MOVF       _BytesToReceive+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt106
;Slave.c,951 :: 		if ((Command & CMD_TYPE_MASK) == RTC_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      96
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt107
;Slave.c,955 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,957 :: 		ch = ch - 0x30;
	MOVLW      48
	SUBWF      _ch+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _ch+0
;Slave.c,959 :: 		if (ch > 59)
	MOVF       R1+0, 0
	SUBLW      59
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt108
;Slave.c,961 :: 		ch = 59;
	MOVLW      59
	MOVWF      _ch+0
L_interrupt108:
;Slave.c,963 :: 		ConvertTime(ch);
	MOVF       _ch+0, 0
	MOVWF      FARG_ConvertTime_ch+0
	CALL       _ConvertTime+0
;Slave.c,965 :: 		Tmp_Sec_X1 = X1;
	MOVF       _X1+0, 0
	MOVWF      _Tmp_Sec_X1+0
;Slave.c,967 :: 		Tmp_Sec_X10 = X10;
	MOVF       _X10+0, 0
	MOVWF      _Tmp_Sec_X10+0
;Slave.c,969 :: 		RTCSetupFlag = 1;
	BSF        _RTCSetupFlag+0, BitPos(_RTCSetupFlag+0)
;Slave.c,971 :: 		}
	GOTO       L_interrupt109
L_interrupt107:
;Slave.c,973 :: 		else if ((Command & CMD_TYPE_MASK) == MODE_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      160
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt110
;Slave.c,977 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,979 :: 		Tmp_ProgDurationL = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgDurationL+0
;Slave.c,981 :: 		ProgSetupFlag = 1;
	BSF        _ProgSetupFlag+0, BitPos(_ProgSetupFlag+0)
;Slave.c,983 :: 		}
	GOTO       L_interrupt111
L_interrupt110:
;Slave.c,985 :: 		else if ((Command & CMD_TYPE_MASK) == CONTROL_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      192
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt112
;Slave.c,989 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,991 :: 		ControlByte = ch;
	MOVF       _ch+0, 0
	MOVWF      _ControlByte+0
;Slave.c,993 :: 		if (ControlByte == 0xFF) {
	MOVF       _ch+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt113
;Slave.c,994 :: 		SystemOn = 1;
	BSF        _SystemOn+0, BitPos(_SystemOn+0)
;Slave.c,995 :: 		if (WateringActive == 0) {
	BTFSC      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_interrupt114
;Slave.c,996 :: 		WateringActive = 1;
	BSF        _WateringActive+0, BitPos(_WateringActive+0)
;Slave.c,997 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,998 :: 		RemainingH = 0;
	CLRF       _RemainingH+0
;Slave.c,999 :: 		RemainingL = 0xB4; //180s
	MOVLW      180
	MOVWF      _RemainingL+0
;Slave.c,1000 :: 		PinPump = 1;
	BSF        PORTA+0, 2
;Slave.c,1001 :: 		}
L_interrupt114:
;Slave.c,1002 :: 		}
	GOTO       L_interrupt115
L_interrupt113:
;Slave.c,1004 :: 		SystemOn = 0;
	BCF        _SystemOn+0, BitPos(_SystemOn+0)
;Slave.c,1005 :: 		WateringActive = 0;
	BCF        _WateringActive+0, BitPos(_WateringActive+0)
;Slave.c,1006 :: 		ManualMode = 0;
	BCF        _ManualMode+0, BitPos(_ManualMode+0)
;Slave.c,1007 :: 		RemainingH = 0;
	CLRF       _RemainingH+0
;Slave.c,1008 :: 		RemainingL = 0;
	CLRF       _RemainingL+0
;Slave.c,1009 :: 		PinPump = 0;
	BCF        PORTA+0, 2
;Slave.c,1010 :: 		AlarmActive = 0;
	BCF        _AlarmActive+0, BitPos(_AlarmActive+0)
;Slave.c,1011 :: 		PinAlarm = 0;
	BCF        PORTA+0, 3
;Slave.c,1012 :: 		}
L_interrupt115:
;Slave.c,1013 :: 		CallFlag = 1;
	BSF        _CallFlag+0, BitPos(_CallFlag+0)
;Slave.c,1014 :: 		}
	GOTO       L_interrupt116
L_interrupt112:
;Slave.c,1016 :: 		else if ((Command & CMD_TYPE_MASK) == GARDEN_CODE)
	MOVLW      224
	ANDWF      _Command+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      128
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt117
;Slave.c,1020 :: 		BytesToReceive = 0x00;
	CLRF       _BytesToReceive+0
;Slave.c,1022 :: 		Tmp_ProgramMode = ch;
	MOVF       _ch+0, 0
	MOVWF      _Tmp_ProgramMode+0
;Slave.c,1024 :: 		GardenSetupFlag = 1;
	BSF        _GardenSetupFlag+0, BitPos(_GardenSetupFlag+0)
;Slave.c,1026 :: 		}
L_interrupt117:
L_interrupt116:
L_interrupt111:
L_interrupt109:
;Slave.c,1027 :: 		}
L_interrupt106:
L_interrupt105:
L_interrupt99:
L_interrupt92:
L_interrupt89:
L_interrupt87:
;Slave.c,1028 :: 		}
L_interrupt75:
;Slave.c,1029 :: 		}
L__interrupt142:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_UpdateLCD:

;Slave.c,1031 :: 		void UpdateLCD()
;Slave.c,1035 :: 		unsigned char DispH = 0x00;
	CLRF       UpdateLCD_DispH_L0+0
;Slave.c,1037 :: 		unsigned char DispL = 0x00;
	CLRF       UpdateLCD_DispL_L0+0
;Slave.c,1041 :: 		Lcd_Chr(1, 1, Hour_X10 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1043 :: 		Lcd_Chr(1, 2, Hour_X1 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Hour_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1045 :: 		Lcd_Chr(1, 3, ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1047 :: 		Lcd_Chr(1, 4, Min_X10 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1049 :: 		Lcd_Chr(1, 5, Min_X1 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Min_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1051 :: 		Lcd_Chr(1, 6, ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1053 :: 		Lcd_Chr(1, 7, Sec_X10 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X10+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1055 :: 		Lcd_Chr(1, 8, Sec_X1 + '0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _Sec_X1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1059 :: 		Lcd_Chr(1, 9, ' ');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1061 :: 		Lcd_Chr(1, 10, ' ');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1063 :: 		LcdByteDec2(1, 11, ProgStartHour);
	MOVLW      1
	MOVWF      FARG_LcdByteDec2_row+0
	MOVLW      11
	MOVWF      FARG_LcdByteDec2_col+0
	MOVF       _ProgStartHour+0, 0
	MOVWF      FARG_LcdByteDec2_val+0
	CALL       _LcdByteDec2+0
;Slave.c,1065 :: 		Lcd_Chr(1, 13, ':');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1067 :: 		LcdByteDec2(1, 14, ProgStartMin);
	MOVLW      1
	MOVWF      FARG_LcdByteDec2_row+0
	MOVLW      14
	MOVWF      FARG_LcdByteDec2_col+0
	MOVF       _ProgStartMin+0, 0
	MOVWF      FARG_LcdByteDec2_val+0
	CALL       _LcdByteDec2+0
;Slave.c,1071 :: 		if (WateringActive == 1)
	BTFSS      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_UpdateLCD118
;Slave.c,1073 :: 		Lcd_Chr(1, 16, 'P');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      80
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD119
L_UpdateLCD118:
;Slave.c,1077 :: 		Lcd_Chr(1, 16, ' ');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD119:
;Slave.c,1081 :: 		if (WateringActive == 1)
	BTFSS      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_UpdateLCD120
;Slave.c,1085 :: 		DispH = RemainingH;
	MOVF       _RemainingH+0, 0
	MOVWF      UpdateLCD_DispH_L0+0
;Slave.c,1087 :: 		DispL = RemainingL;
	MOVF       _RemainingL+0, 0
	MOVWF      UpdateLCD_DispL_L0+0
;Slave.c,1089 :: 		}
	GOTO       L_UpdateLCD121
L_UpdateLCD120:
;Slave.c,1095 :: 		DispH = ProgDurationH;
	MOVF       _ProgDurationH+0, 0
	MOVWF      UpdateLCD_DispH_L0+0
;Slave.c,1097 :: 		DispL = ProgDurationL;
	MOVF       _ProgDurationL+0, 0
	MOVWF      UpdateLCD_DispL_L0+0
;Slave.c,1098 :: 		}
L_UpdateLCD121:
;Slave.c,1100 :: 		Lcd_Chr(2, 1, 'D');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      68
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1102 :: 		Lcd_Chr(2, 2, ':');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1104 :: 		LcdByteHex(2, 3, DispH);
	MOVLW      2
	MOVWF      FARG_LcdByteHex_row+0
	MOVLW      3
	MOVWF      FARG_LcdByteHex_col+0
	MOVF       UpdateLCD_DispH_L0+0, 0
	MOVWF      FARG_LcdByteHex_val+0
	CALL       _LcdByteHex+0
;Slave.c,1106 :: 		LcdByteHex(2, 5, DispL);
	MOVLW      2
	MOVWF      FARG_LcdByteHex_row+0
	MOVLW      5
	MOVWF      FARG_LcdByteHex_col+0
	MOVF       UpdateLCD_DispL_L0+0, 0
	MOVWF      FARG_LcdByteHex_val+0
	CALL       _LcdByteHex+0
;Slave.c,1108 :: 		Lcd_Chr(2, 7, ' ');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1110 :: 		Lcd_Chr(2, 8, 'F');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      70
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1112 :: 		Lcd_Chr(2, 9, ':');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Slave.c,1114 :: 		LcdByteHex(2, 10, FlowValue);
	MOVLW      2
	MOVWF      FARG_LcdByteHex_row+0
	MOVLW      10
	MOVWF      FARG_LcdByteHex_col+0
	MOVF       _FlowValue+0, 0
	MOVWF      FARG_LcdByteHex_val+0
	CALL       _LcdByteHex+0
;Slave.c,1116 :: 		Lcd_Out(2, 12, "    ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Slave+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Slave.c,1118 :: 		if (AlarmActive == 1)
	BTFSS      _AlarmActive+0, BitPos(_AlarmActive+0)
	GOTO       L_UpdateLCD122
;Slave.c,1120 :: 		Lcd_Chr(2, 16, 'A');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      65
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	GOTO       L_UpdateLCD123
L_UpdateLCD122:
;Slave.c,1124 :: 		Lcd_Chr(2, 16, ' ');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      32
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
L_UpdateLCD123:
;Slave.c,1125 :: 		}
	RETURN
; end of _UpdateLCD

_Message_StoM:

;Slave.c,1127 :: 		void Message_StoM()
;Slave.c,1131 :: 		BAJT1 = STATUS_CODE | SLAVE_ID;
	MOVLW      32
	IORWF      _SLAVE_ID+0, 0
	MOVWF      _BAJT1+0
;Slave.c,1133 :: 		BAJT2 = 0x00;
	CLRF       _BAJT2+0
;Slave.c,1135 :: 		if (SystemOn == 1)
	BTFSS      _SystemOn+0, BitPos(_SystemOn+0)
	GOTO       L_Message_StoM124
;Slave.c,1137 :: 		BAJT2 = BAJT2 | STATUS_SYSTEM_BIT;
	BSF        _BAJT2+0, 7
L_Message_StoM124:
;Slave.c,1139 :: 		if (WateringActive == 1)
	BTFSS      _WateringActive+0, BitPos(_WateringActive+0)
	GOTO       L_Message_StoM125
;Slave.c,1141 :: 		BAJT2 = BAJT2 | STATUS_WATER_BIT;
	BSF        _BAJT2+0, 6
L_Message_StoM125:
;Slave.c,1143 :: 		if (AlarmActive == 1)
	BTFSS      _AlarmActive+0, BitPos(_AlarmActive+0)
	GOTO       L_Message_StoM126
;Slave.c,1145 :: 		BAJT2 = BAJT2 | STATUS_ALARM_BIT;
	BSF        _BAJT2+0, 5
L_Message_StoM126:
;Slave.c,1147 :: 		if (ManualMode == 1)
	BTFSS      _ManualMode+0, BitPos(_ManualMode+0)
	GOTO       L_Message_StoM127
;Slave.c,1149 :: 		BAJT2 = BAJT2 | STATUS_MANUAL_BIT;
	BSF        _BAJT2+0, 4
L_Message_StoM127:
;Slave.c,1150 :: 		}
	RETURN
; end of _Message_StoM

_SendStatus:

;Slave.c,1152 :: 		void SendStatus()
;Slave.c,1156 :: 		Message_StoM();
	CALL       _Message_StoM+0
;Slave.c,1158 :: 		DR = 1;
	BSF        PORTC+0, 5
;Slave.c,1160 :: 		transmit(BAJT1);
	MOVF       _BAJT1+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,1162 :: 		transmit(BAJT2);
	MOVF       _BAJT2+0, 0
	MOVWF      FARG_transmit_DATA8b+0
	CALL       _transmit+0
;Slave.c,1164 :: 		DR = 0;
	BCF        PORTC+0, 5
;Slave.c,1165 :: 		}
	RETURN
; end of _SendStatus

_init:

;Slave.c,1167 :: 		void init()
;Slave.c,1171 :: 		TRISA = 0x03;
	MOVLW      3
	MOVWF      TRISA+0
;Slave.c,1173 :: 		TRISB = 0xFF;
	MOVLW      255
	MOVWF      TRISB+0
;Slave.c,1175 :: 		TRISC = 0xC0;
	MOVLW      192
	MOVWF      TRISC+0
;Slave.c,1177 :: 		TRISD = 0x0F;
	MOVLW      15
	MOVWF      TRISD+0
;Slave.c,1179 :: 		TRISE = 0x00;
	CLRF       TRISE+0
;Slave.c,1181 :: 		PORTA = 0x00;
	CLRF       PORTA+0
;Slave.c,1183 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;Slave.c,1185 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;Slave.c,1187 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;Slave.c,1189 :: 		PORTE = 0x00;
	CLRF       PORTE+0
;Slave.c,1191 :: 		ADCON1 = 0b00001110; // AN0 analogni, ostali digitalni, left justified
	MOVLW      14
	MOVWF      ADCON1+0
;Slave.c,1193 :: 		ADCON0 = 0b10000001; // Fosc/32, kanal AN0, ADC ukljucen
	MOVLW      129
	MOVWF      ADCON0+0
;Slave.c,1195 :: 		INTCON = 0b11000000;
	MOVLW      192
	MOVWF      INTCON+0
;Slave.c,1197 :: 		PIE1 = 0b00000000;
	CLRF       PIE1+0
;Slave.c,1199 :: 		T1CON = 0b00110000;
	MOVLW      48
	MOVWF      T1CON+0
;Slave.c,1201 :: 		TMR1H = 0x0B;
	MOVLW      11
	MOVWF      TMR1H+0
;Slave.c,1203 :: 		TMR1L = 0xDC;
	MOVLW      220
	MOVWF      TMR1L+0
;Slave.c,1205 :: 		T1CON.TMR1ON = 1;
	BSF        T1CON+0, 0
;Slave.c,1211 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;Slave.c,1213 :: 		PIE1.TMR1IE = 1;
	BSF        PIE1+0, 0
;Slave.c,1215 :: 		Uart1_Init(UART_BAUD_RATE);
	MOVLW      64
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;Slave.c,1217 :: 		TXSTA.TXEN = 1;
	BSF        TXSTA+0, 5
;Slave.c,1219 :: 		RCSTA.SPEN = 1;
	BSF        RCSTA+0, 7
;Slave.c,1221 :: 		RCSTA.CREN = 1;
	BSF        RCSTA+0, 4
;Slave.c,1223 :: 		PIE1.RCIE = 1;
	BSF        PIE1+0, 5
;Slave.c,1225 :: 		INTCON.GIE = 1;
	BSF        INTCON+0, 7
;Slave.c,1226 :: 		}
	RETURN
; end of _init
