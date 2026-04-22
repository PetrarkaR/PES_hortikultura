
_putConstString:

;Master.c,64 :: 		unsigned int putConstString(const char *s)
;Master.c,66 :: 		unsigned int ctr = 0;
	CLRF        putConstString_ctr_L0+0 
	CLRF        putConstString_ctr_L0+1 
;Master.c,67 :: 		while (*s)
L_putConstString0:
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
	GOTO        L_putConstString1
;Master.c,69 :: 		SPI_Ethernet_putByte(*s++);
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
;Master.c,70 :: 		ctr++;
	INFSNZ      putConstString_ctr_L0+0, 1 
	INCF        putConstString_ctr_L0+1, 1 
;Master.c,71 :: 		}
	GOTO        L_putConstString0
L_putConstString1:
;Master.c,72 :: 		return (ctr);
	MOVF        putConstString_ctr_L0+0, 0 
	MOVWF       R0 
	MOVF        putConstString_ctr_L0+1, 0 
	MOVWF       R1 
;Master.c,73 :: 		}
	RETURN      0
; end of _putConstString

_putString:

;Master.c,75 :: 		unsigned int putString(char *s)
;Master.c,77 :: 		unsigned int ctr = 0;
	CLRF        putString_ctr_L0+0 
	CLRF        putString_ctr_L0+1 
;Master.c,78 :: 		while (*s)
L_putString2:
	MOVFF       FARG_putString_s+0, FSR0L
	MOVFF       FARG_putString_s+1, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_putString3
;Master.c,80 :: 		SPI_Ethernet_putByte(*s++);
	MOVFF       FARG_putString_s+0, FSR0L
	MOVFF       FARG_putString_s+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_SPI_Ethernet_putByte_v+0 
	CALL        _SPI_Ethernet_putByte+0, 0
	INFSNZ      FARG_putString_s+0, 1 
	INCF        FARG_putString_s+1, 1 
;Master.c,81 :: 		ctr++;
	INFSNZ      putString_ctr_L0+0, 1 
	INCF        putString_ctr_L0+1, 1 
;Master.c,82 :: 		}
	GOTO        L_putString2
L_putString3:
;Master.c,83 :: 		return (ctr);
	MOVF        putString_ctr_L0+0, 0 
	MOVWF       R0 
	MOVF        putString_ctr_L0+1, 0 
	MOVWF       R1 
;Master.c,84 :: 		}
	RETURN      0
; end of _putString

_dodajUNiz:

;Master.c,86 :: 		void dodajUNiz(char *p_ch)
;Master.c,88 :: 		while ((*p_ch) != 0x00)
L_dodajUNiz4:
	MOVFF       FARG_dodajUNiz_p_ch+0, FSR0L
	MOVFF       FARG_dodajUNiz_p_ch+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_dodajUNiz5
;Master.c,90 :: 		niz[br_ch] = *p_ch;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVFF       FARG_dodajUNiz_p_ch+0, FSR0L
	MOVFF       FARG_dodajUNiz_p_ch+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Master.c,91 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,92 :: 		p_ch++;
	INFSNZ      FARG_dodajUNiz_p_ch+0, 1 
	INCF        FARG_dodajUNiz_p_ch+1, 1 
;Master.c,93 :: 		}
	GOTO        L_dodajUNiz4
L_dodajUNiz5:
;Master.c,94 :: 		}
	RETURN      0
; end of _dodajUNiz

_formirajNiz:

;Master.c,95 :: 		void formirajNiz()
;Master.c,98 :: 		unsigned char i = 0;
	CLRF        formirajNiz_i_L0+0 
;Master.c,100 :: 		br_ch = 0; // pozicioniranje na pocetak niza
	CLRF        _br_ch+0 
;Master.c,102 :: 		for (i = 0; i < 16; i++)
	CLRF        formirajNiz_i_L0+0 
L_formirajNiz6:
	MOVLW       16
	SUBWF       formirajNiz_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_formirajNiz7
;Master.c,104 :: 		if (Comm[i] == 1)
	MOVLW       _Comm+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR0H 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz9
;Master.c,106 :: 		dodajUNiz("Ramp:");
	MOVLW       ?lstr1_Master+0
	MOVWF       FARG_dodajUNiz_p_ch+0 
	MOVLW       hi_addr(?lstr1_Master+0)
	MOVWF       FARG_dodajUNiz_p_ch+1 
	CALL        _dodajUNiz+0, 0
;Master.c,107 :: 		ByteToStr(i, txt);
	MOVF        formirajNiz_i_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       formirajNiz_txt_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(formirajNiz_txt_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;Master.c,108 :: 		dodajUNiz(txt); // ID broj
	MOVLW       formirajNiz_txt_L0+0
	MOVWF       FARG_dodajUNiz_p_ch+0 
	MOVLW       hi_addr(formirajNiz_txt_L0+0)
	MOVWF       FARG_dodajUNiz_p_ch+1 
	CALL        _dodajUNiz+0, 0
;Master.c,109 :: 		switch (Cmd[i])
	MOVLW       _Cmd+0
	MOVWF       FLOC__formirajNiz+0 
	MOVLW       hi_addr(_Cmd+0)
	MOVWF       FLOC__formirajNiz+1 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FLOC__formirajNiz+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FLOC__formirajNiz+1, 1 
	GOTO        L_formirajNiz10
;Master.c,112 :: 		case 0:
L_formirajNiz12:
;Master.c,113 :: 		dodajUNiz(" IDLE \n\n");
	MOVLW       ?lstr2_Master+0
	MOVWF       FARG_dodajUNiz_p_ch+0 
	MOVLW       hi_addr(?lstr2_Master+0)
	MOVWF       FARG_dodajUNiz_p_ch+1 
	CALL        _dodajUNiz+0, 0
;Master.c,114 :: 		break;
	GOTO        L_formirajNiz11
;Master.c,115 :: 		case 1:
L_formirajNiz13:
;Master.c,116 :: 		dodajUNiz(" VEHICLE ");
	MOVLW       ?lstr3_Master+0
	MOVWF       FARG_dodajUNiz_p_ch+0 
	MOVLW       hi_addr(?lstr3_Master+0)
	MOVWF       FARG_dodajUNiz_p_ch+1 
	CALL        _dodajUNiz+0, 0
;Master.c,117 :: 		break;
	GOTO        L_formirajNiz11
;Master.c,118 :: 		case 2:
L_formirajNiz14:
;Master.c,119 :: 		dodajUNiz(" TIME SET \n\n");
	MOVLW       ?lstr4_Master+0
	MOVWF       FARG_dodajUNiz_p_ch+0 
	MOVLW       hi_addr(?lstr4_Master+0)
	MOVWF       FARG_dodajUNiz_p_ch+1 
	CALL        _dodajUNiz+0, 0
;Master.c,120 :: 		break;
	GOTO        L_formirajNiz11
;Master.c,121 :: 		case 3:
L_formirajNiz15:
;Master.c,122 :: 		dodajUNiz(" NO CARDS \n\n");
	MOVLW       ?lstr5_Master+0
	MOVWF       FARG_dodajUNiz_p_ch+0 
	MOVLW       hi_addr(?lstr5_Master+0)
	MOVWF       FARG_dodajUNiz_p_ch+1 
	CALL        _dodajUNiz+0, 0
;Master.c,123 :: 		break;
	GOTO        L_formirajNiz11
;Master.c,124 :: 		default:
L_formirajNiz16:
;Master.c,125 :: 		break;
	GOTO        L_formirajNiz11
;Master.c,126 :: 		}
L_formirajNiz10:
	MOVFF       FLOC__formirajNiz+0, FSR0L
	MOVFF       FLOC__formirajNiz+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_formirajNiz12
	MOVFF       FLOC__formirajNiz+0, FSR0L
	MOVFF       FLOC__formirajNiz+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_formirajNiz13
	MOVFF       FLOC__formirajNiz+0, FSR0L
	MOVFF       FLOC__formirajNiz+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_formirajNiz14
	MOVFF       FLOC__formirajNiz+0, FSR0L
	MOVFF       FLOC__formirajNiz+1, FSR0H
	MOVF        POSTINC0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_formirajNiz15
	GOTO        L_formirajNiz16
L_formirajNiz11:
;Master.c,127 :: 		if (Cmd[i] == 1)
	MOVLW       _Cmd+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Cmd+0)
	MOVWF       FSR0H 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_formirajNiz17
;Master.c,129 :: 		pom_nula = 0x30;  // asci 0
	MOVLW       48
	MOVWF       _pom_nula+0 
;Master.c,130 :: 		pom_ch = Hour[i]; // ubacivanje sati
	MOVLW       _Hour+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Hour+0)
	MOVWF       FSR0H 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       _pom_ch+0 
;Master.c,131 :: 		pom_des = (pom_ch >> 4) + pom_nula;
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       48
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       _pom_des+0 
;Master.c,132 :: 		pom_jed = (pom_ch & 0x0F) + pom_nula;
	MOVLW       15
	ANDWF       R2, 0 
	MOVWF       _pom_jed+0 
	MOVLW       48
	ADDWF       _pom_jed+0, 1 
;Master.c,133 :: 		niz[br_ch] = pom_des;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Master.c,134 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,135 :: 		niz[br_ch] = pom_jed;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _pom_jed+0, 0 
	MOVWF       POSTINC1+0 
;Master.c,136 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,137 :: 		niz[br_ch] = ':';
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       58
	MOVWF       POSTINC1+0 
;Master.c,138 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,140 :: 		pom_ch = Min[i]; // ubacivanje minuta
	MOVLW       _Min+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Min+0)
	MOVWF       FSR0H 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       _pom_ch+0 
;Master.c,141 :: 		pom_des = (pom_ch >> 4) + pom_nula;
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        _pom_nula+0, 0 
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       _pom_des+0 
;Master.c,142 :: 		pom_jed = (pom_ch & 0x0F) + pom_nula;
	MOVLW       15
	ANDWF       R2, 0 
	MOVWF       _pom_jed+0 
	MOVF        _pom_nula+0, 0 
	ADDWF       _pom_jed+0, 1 
;Master.c,143 :: 		niz[br_ch] = pom_des;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Master.c,144 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,145 :: 		niz[br_ch] = pom_jed;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _pom_jed+0, 0 
	MOVWF       POSTINC1+0 
;Master.c,146 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,147 :: 		niz[br_ch] = ':';
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       58
	MOVWF       POSTINC1+0 
;Master.c,148 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,150 :: 		pom_ch = Sec[i]; // ubacivanje sekundi
	MOVLW       _Sec+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Sec+0)
	MOVWF       FSR0H 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       _pom_ch+0 
;Master.c,151 :: 		pom_des = (pom_ch >> 4) + pom_nula;
	MOVF        R2, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        _pom_nula+0, 0 
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       _pom_des+0 
;Master.c,152 :: 		pom_jed = (pom_ch & 0x0F) + pom_nula;
	MOVLW       15
	ANDWF       R2, 0 
	MOVWF       _pom_jed+0 
	MOVF        _pom_nula+0, 0 
	ADDWF       _pom_jed+0, 1 
;Master.c,153 :: 		niz[br_ch] = pom_des;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;Master.c,154 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,155 :: 		niz[br_ch] = pom_jed;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _pom_jed+0, 0 
	MOVWF       POSTINC1+0 
;Master.c,156 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,157 :: 		niz[br_ch] = ' ';
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       32
	MOVWF       POSTINC1+0 
;Master.c,158 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,160 :: 		pom_ch = Cat[i]; // ubacivanje kategorije vozila
	MOVLW       _Cat+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Cat+0)
	MOVWF       FSR0H 
	MOVF        formirajNiz_i_L0+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _pom_ch+0 
;Master.c,161 :: 		pom_des = 'K';
	MOVLW       75
	MOVWF       _pom_des+0 
;Master.c,162 :: 		pom_jed = (pom_ch & 0x0F) + pom_nula;
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       _pom_jed+0 
	MOVF        _pom_nula+0, 0 
	ADDWF       _pom_jed+0, 1 
;Master.c,163 :: 		niz[br_ch] = pom_des;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       75
	MOVWF       POSTINC1+0 
;Master.c,164 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,165 :: 		niz[br_ch] = pom_jed;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _pom_jed+0, 0 
	MOVWF       POSTINC1+0 
;Master.c,166 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,167 :: 		niz[br_ch] = '\n';
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       10
	MOVWF       POSTINC1+0 
;Master.c,168 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,169 :: 		niz[br_ch] = '\n';
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       10
	MOVWF       POSTINC1+0 
;Master.c,170 :: 		br_ch++;
	INCF        _br_ch+0, 1 
;Master.c,171 :: 		} //if
L_formirajNiz17:
;Master.c,172 :: 		}    // if
L_formirajNiz9:
;Master.c,102 :: 		for (i = 0; i < 16; i++)
	INCF        formirajNiz_i_L0+0, 1 
;Master.c,173 :: 		}       // for
	GOTO        L_formirajNiz6
L_formirajNiz7:
;Master.c,174 :: 		niz[br_ch] = 0x00;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _br_ch+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,175 :: 		br_ch++; // kraj stringa
	INCF        _br_ch+0, 1 
;Master.c,176 :: 		}
	RETURN      0
; end of _formirajNiz

_interrupt:

;Master.c,178 :: 		void interrupt()
;Master.c,181 :: 		if ((PIE1.TMR1IE == 1) && (PIR1.TMR1IF == 1))
	BTFSS       PIE1+0, 0 
	GOTO        L_interrupt20
	BTFSS       PIR1+0, 0 
	GOTO        L_interrupt20
L__interrupt99:
;Master.c,184 :: 		PIE1.TMR1IE = 1;
	BSF         PIE1+0, 0 
;Master.c,185 :: 		PIR1.TMR1IF = 0;
	BCF         PIR1+0, 0 
;Master.c,186 :: 		if (brojac == 0x04)
	MOVF        _brojac+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt21
;Master.c,188 :: 		brojac = 0x00;
	CLRF        _brojac+0 
;Master.c,189 :: 		Flag1 = 0x01; // podize se flag koji nam govori da je doslo vreme da se prozove rampa, koristimo ga u Main funkciji
	MOVLW       1
	MOVWF       _Flag1+0 
;Master.c,190 :: 		}
	GOTO        L_interrupt22
L_interrupt21:
;Master.c,193 :: 		brojac++;
	INCF        _brojac+0, 1 
;Master.c,194 :: 		}
L_interrupt22:
;Master.c,195 :: 		TMR1L = 0xB5;
	MOVLW       181
	MOVWF       TMR1L+0 
;Master.c,196 :: 		TMR1H = 0xB3;
	MOVLW       179
	MOVWF       TMR1H+0 
;Master.c,197 :: 		}
L_interrupt20:
;Master.c,199 :: 		if ((PIE1.RCIE) && (PIR1.RCIF))
	BTFSS       PIE1+0, 5 
	GOTO        L_interrupt25
	BTFSS       PIR1+0, 5 
	GOTO        L_interrupt25
L__interrupt98:
;Master.c,202 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;Master.c,204 :: 		ch = RCREG; //prima se bajt preko UART-a
	MOVF        RCREG+0, 0 
	MOVWF       R2 
;Master.c,205 :: 		if (OBB != 0x00)
	MOVF        _OBB+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt26
;Master.c,207 :: 		if (OBB == 0x05)
	MOVF        _OBB+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt27
;Master.c,209 :: 		Comm[RAMP_ID] = 1; // komunikacija je OK
	MOVLW       _Comm+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
;Master.c,210 :: 		if ((ch & 0xE0) == 0x00)
	MOVLW       224
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt28
;Master.c,212 :: 		OBB = 0x00;   // NO CARDS
	CLRF        _OBB+0 
;Master.c,213 :: 		Cmd[RAMP_ID] = 3;
	MOVLW       _Cmd+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cmd+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       3
	MOVWF       POSTINC1+0 
;Master.c,214 :: 		}
L_interrupt28:
;Master.c,215 :: 		if ((ch & 0xE0) == 0x20)
	MOVLW       224
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt29
;Master.c,216 :: 		OBB = 0x00; // IDLE
	CLRF        _OBB+0 
L_interrupt29:
;Master.c,217 :: 		if ((ch & 0xE0) == 0x40)
	MOVLW       224
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       64
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt30
;Master.c,219 :: 		OBB = 0x04;   // VEHICLE
	MOVLW       4
	MOVWF       _OBB+0 
;Master.c,220 :: 		Cmd[RAMP_ID] = 1;
	MOVLW       _Cmd+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cmd+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
;Master.c,221 :: 		}
L_interrupt30:
;Master.c,222 :: 		if ((ch & 0xE0) == 0x60)
	MOVLW       224
	ANDWF       R2, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       96
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt31
;Master.c,224 :: 		OBB = 0x00;  // RTC
	CLRF        _OBB+0 
;Master.c,225 :: 		Cmd[RAMP_ID] = 2;
	MOVLW       _Cmd+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cmd+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       2
	MOVWF       POSTINC1+0 
;Master.c,226 :: 		}
L_interrupt31:
;Master.c,227 :: 		}
	GOTO        L_interrupt32
L_interrupt27:
;Master.c,230 :: 		switch (OBB)
	GOTO        L_interrupt33
;Master.c,233 :: 		case 4:
L_interrupt35:
;Master.c,234 :: 		Sec[RAMP_ID] = ch;
	MOVLW       _Sec+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Sec+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
;Master.c,235 :: 		break; //ch_sec=ch;
	GOTO        L_interrupt34
;Master.c,236 :: 		case 3:
L_interrupt36:
;Master.c,237 :: 		Min[RAMP_ID] = ch;
	MOVLW       _Min+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Min+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
;Master.c,238 :: 		break; //ch_min=ch;
	GOTO        L_interrupt34
;Master.c,239 :: 		case 2:
L_interrupt37:
;Master.c,240 :: 		Hour[RAMP_ID] = ch;
	MOVLW       _Hour+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Hour+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
;Master.c,241 :: 		break; //ch_hour=ch;
	GOTO        L_interrupt34
;Master.c,242 :: 		case 1:
L_interrupt38:
;Master.c,243 :: 		Cat[RAMP_ID] = ch;
	MOVLW       _Cat+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cat+0)
	MOVWF       FSR1H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
;Master.c,244 :: 		break; //ch_cat=ch;
	GOTO        L_interrupt34
;Master.c,245 :: 		default:
L_interrupt39:
;Master.c,246 :: 		break;
	GOTO        L_interrupt34
;Master.c,247 :: 		}
L_interrupt33:
	MOVF        _OBB+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt35
	MOVF        _OBB+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt36
	MOVF        _OBB+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt37
	MOVF        _OBB+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt38
	GOTO        L_interrupt39
L_interrupt34:
;Master.c,248 :: 		OBB--;
	DECF        _OBB+0, 1 
;Master.c,249 :: 		}
L_interrupt32:
;Master.c,250 :: 		}
L_interrupt26:
;Master.c,251 :: 		} //  if ((PIE1.RCIE) && (PIR1.RCIF)){
L_interrupt25:
;Master.c,252 :: 		} //void interrupt ()
L__interrupt101:
	RETFIE      1
; end of _interrupt

_UpdateLCD:

;Master.c,254 :: 		void UpdateLCD()
;Master.c,256 :: 		int i = 0;
	CLRF        UpdateLCD_i_L0+0 
	CLRF        UpdateLCD_i_L0+1 
;Master.c,257 :: 		Lcd_Out(1, 1, "Operation    ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Master+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Master+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Master.c,258 :: 		for (i = 0; i <= 15; i++)
	CLRF        UpdateLCD_i_L0+0 
	CLRF        UpdateLCD_i_L0+1 
L_UpdateLCD40:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       UpdateLCD_i_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__UpdateLCD102
	MOVF        UpdateLCD_i_L0+0, 0 
	SUBLW       15
L__UpdateLCD102:
	BTFSS       STATUS+0, 0 
	GOTO        L_UpdateLCD41
;Master.c,260 :: 		if (Operation[i] == 1)
	MOVLW       _Operation+0
	ADDWF       UpdateLCD_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Operation+0)
	ADDWFC      UpdateLCD_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_UpdateLCD43
;Master.c,261 :: 		Lcd_Chr(2, 16 - i, '1');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        UpdateLCD_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	GOTO        L_UpdateLCD44
L_UpdateLCD43:
;Master.c,263 :: 		Lcd_Chr(2, 16 - i, '0');
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        UpdateLCD_i_L0+0, 0 
	SUBLW       16
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_UpdateLCD44:
;Master.c,258 :: 		for (i = 0; i <= 15; i++)
	INFSNZ      UpdateLCD_i_L0+0, 1 
	INCF        UpdateLCD_i_L0+1, 1 
;Master.c,264 :: 		}
	GOTO        L_UpdateLCD40
L_UpdateLCD41:
;Master.c,265 :: 		}
	RETURN      0
; end of _UpdateLCD

_SPI_Ethernet_UserTCP:

;Master.c,267 :: 		unsigned int SPI_Ethernet_UserTCP(unsigned char *remoteHost, unsigned int remotePort, unsigned int localPort, unsigned int reqLength, char *canClose)
;Master.c,270 :: 		unsigned int len = 0; // my reply length
	CLRF        SPI_Ethernet_UserTCP_len_L0+0 
	CLRF        SPI_Ethernet_UserTCP_len_L0+1 
;Master.c,272 :: 		if (localPort != 80)
	MOVLW       0
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP103
	MOVLW       80
	XORWF       FARG_SPI_Ethernet_UserTCP_localPort+0, 0 
L__SPI_Ethernet_UserTCP103:
	BTFSC       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP45
;Master.c,273 :: 		return (0);
	CLRF        R0 
	CLRF        R1 
	RETURN      0
L_SPI_Ethernet_UserTCP45:
;Master.c,274 :: 		PORTA.F4 = 1;
	BSF         PORTA+0, 4 
;Master.c,276 :: 		for (i = 0; i < 10; i++)
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP46:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP104
	MOVLW       10
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP104:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP47
;Master.c,277 :: 		getRequest[i] = SPI_Ethernet_getByte();
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
;Master.c,276 :: 		for (i = 0; i < 10; i++)
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;Master.c,277 :: 		getRequest[i] = SPI_Ethernet_getByte();
	GOTO        L_SPI_Ethernet_UserTCP46
L_SPI_Ethernet_UserTCP47:
;Master.c,278 :: 		getRequest[i] = 0;
	MOVLW       _getRequest+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,280 :: 		if (memcmp(getRequest, httpMethod, 5))
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
	GOTO        L_SPI_Ethernet_UserTCP49
;Master.c,281 :: 		return (0);
	CLRF        R0 
	CLRF        R1 
	RETURN      0
L_SPI_Ethernet_UserTCP49:
;Master.c,284 :: 		if (getRequest[5] == 's')
	MOVF        _getRequest+5, 0 
	XORLW       115
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP50
;Master.c,288 :: 		if (((getRequest[6] & 0xF0) == 0x30) && ((getRequest[7] & 0xF0) == 0x30) &&
	MOVLW       240
	ANDWF       _getRequest+6, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP53
	MOVLW       240
	ANDWF       _getRequest+7, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP53
;Master.c,289 :: 		((getRequest[8] & 0xF0) == 0x30) && ((getRequest[9] & 0xF0) == 0x30))
	MOVLW       240
	ANDWF       _getRequest+8, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP53
	MOVLW       240
	ANDWF       _getRequest+9, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP53
L__SPI_Ethernet_UserTCP100:
;Master.c,292 :: 		for (i = 0; i < 16; i++)
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP54:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP105
	MOVLW       16
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP105:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP55
;Master.c,293 :: 		Operation[i] = 0x00;
	MOVLW       _Operation+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Operation+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,292 :: 		for (i = 0; i < 16; i++)
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;Master.c,293 :: 		Operation[i] = 0x00;
	GOTO        L_SPI_Ethernet_UserTCP54
L_SPI_Ethernet_UserTCP55:
;Master.c,295 :: 		if ((getRequest[6] & 0x08) == 0x08)
	MOVLW       8
	ANDWF       _getRequest+6, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP57
;Master.c,296 :: 		Operation[15] = 0x01;
	MOVLW       1
	MOVWF       _Operation+15 
L_SPI_Ethernet_UserTCP57:
;Master.c,297 :: 		if ((getRequest[6] & 0x04) == 0x04)
	MOVLW       4
	ANDWF       _getRequest+6, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP58
;Master.c,298 :: 		Operation[14] = 0x01;
	MOVLW       1
	MOVWF       _Operation+14 
L_SPI_Ethernet_UserTCP58:
;Master.c,299 :: 		if ((getRequest[6] & 0x02) == 0x02)
	MOVLW       2
	ANDWF       _getRequest+6, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP59
;Master.c,300 :: 		Operation[13] = 0x01;
	MOVLW       1
	MOVWF       _Operation+13 
L_SPI_Ethernet_UserTCP59:
;Master.c,301 :: 		if ((getRequest[6] & 0x01) == 0x01)
	MOVLW       1
	ANDWF       _getRequest+6, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP60
;Master.c,302 :: 		Operation[12] = 0x01;
	MOVLW       1
	MOVWF       _Operation+12 
L_SPI_Ethernet_UserTCP60:
;Master.c,303 :: 		if ((getRequest[7] & 0x08) == 0x08)
	MOVLW       8
	ANDWF       _getRequest+7, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP61
;Master.c,304 :: 		Operation[11] = 0x01;
	MOVLW       1
	MOVWF       _Operation+11 
L_SPI_Ethernet_UserTCP61:
;Master.c,305 :: 		if ((getRequest[7] & 0x04) == 0x04)
	MOVLW       4
	ANDWF       _getRequest+7, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP62
;Master.c,306 :: 		Operation[10] = 0x01;
	MOVLW       1
	MOVWF       _Operation+10 
L_SPI_Ethernet_UserTCP62:
;Master.c,307 :: 		if ((getRequest[7] & 0x02) == 0x02)
	MOVLW       2
	ANDWF       _getRequest+7, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP63
;Master.c,308 :: 		Operation[9] = 0x01;
	MOVLW       1
	MOVWF       _Operation+9 
L_SPI_Ethernet_UserTCP63:
;Master.c,309 :: 		if ((getRequest[7] & 0x01) == 0x01)
	MOVLW       1
	ANDWF       _getRequest+7, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP64
;Master.c,310 :: 		Operation[8] = 0x01;
	MOVLW       1
	MOVWF       _Operation+8 
L_SPI_Ethernet_UserTCP64:
;Master.c,311 :: 		if ((getRequest[8] & 0x08) == 0x08)
	MOVLW       8
	ANDWF       _getRequest+8, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP65
;Master.c,312 :: 		Operation[7] = 0x01;
	MOVLW       1
	MOVWF       _Operation+7 
L_SPI_Ethernet_UserTCP65:
;Master.c,313 :: 		if ((getRequest[8] & 0x04) == 0x04)
	MOVLW       4
	ANDWF       _getRequest+8, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP66
;Master.c,314 :: 		Operation[6] = 0x01;
	MOVLW       1
	MOVWF       _Operation+6 
L_SPI_Ethernet_UserTCP66:
;Master.c,315 :: 		if ((getRequest[8] & 0x02) == 0x02)
	MOVLW       2
	ANDWF       _getRequest+8, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP67
;Master.c,316 :: 		Operation[5] = 0x01;
	MOVLW       1
	MOVWF       _Operation+5 
L_SPI_Ethernet_UserTCP67:
;Master.c,317 :: 		if ((getRequest[8] & 0x01) == 0x01)
	MOVLW       1
	ANDWF       _getRequest+8, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP68
;Master.c,318 :: 		Operation[4] = 0x01;
	MOVLW       1
	MOVWF       _Operation+4 
L_SPI_Ethernet_UserTCP68:
;Master.c,319 :: 		if ((getRequest[9] & 0x08) == 0x08)
	MOVLW       8
	ANDWF       _getRequest+9, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       8
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP69
;Master.c,320 :: 		Operation[3] = 0x01;
	MOVLW       1
	MOVWF       _Operation+3 
L_SPI_Ethernet_UserTCP69:
;Master.c,321 :: 		if ((getRequest[9] & 0x04) == 0x04)
	MOVLW       4
	ANDWF       _getRequest+9, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP70
;Master.c,322 :: 		Operation[2] = 0x01;
	MOVLW       1
	MOVWF       _Operation+2 
L_SPI_Ethernet_UserTCP70:
;Master.c,323 :: 		if ((getRequest[9] & 0x02) == 0x02)
	MOVLW       2
	ANDWF       _getRequest+9, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP71
;Master.c,324 :: 		Operation[1] = 0x01;
	MOVLW       1
	MOVWF       _Operation+1 
L_SPI_Ethernet_UserTCP71:
;Master.c,325 :: 		if ((getRequest[9] & 0x01) == 0x01)
	MOVLW       1
	ANDWF       _getRequest+9, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP72
;Master.c,326 :: 		Operation[0] = 0x01;
	MOVLW       1
	MOVWF       _Operation+0 
L_SPI_Ethernet_UserTCP72:
;Master.c,328 :: 		} //  if (((getRequest[6]& 0xF0) ....
L_SPI_Ethernet_UserTCP53:
;Master.c,329 :: 		}    // if (getRequest[5]==0x73)
L_SPI_Ethernet_UserTCP50:
;Master.c,330 :: 		if (getRequest[5] == 'r')
	MOVF        _getRequest+5, 0 
	XORLW       114
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP73
;Master.c,333 :: 		Flag2 = 0x01;
	MOVLW       1
	MOVWF       _Flag2+0 
;Master.c,335 :: 		seconds = getRequest[6]; //nova vrednost za sekunde
	MOVF        _getRequest+6, 0 
	MOVWF       _seconds+0 
;Master.c,336 :: 		minutes = getRequest[7]; // nova vrednost za minute
	MOVF        _getRequest+7, 0 
	MOVWF       _minutes+0 
;Master.c,337 :: 		hours = getRequest[8];   // nova vrednost za sate
	MOVF        _getRequest+8, 0 
	MOVWF       _hours+0 
;Master.c,338 :: 		}
L_SPI_Ethernet_UserTCP73:
;Master.c,339 :: 		if (len == 0)
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP106
	MOVLW       0
	XORWF       SPI_Ethernet_UserTCP_len_L0+0, 0 
L__SPI_Ethernet_UserTCP106:
	BTFSS       STATUS+0, 2 
	GOTO        L_SPI_Ethernet_UserTCP74
;Master.c,341 :: 		FormirajNiz();
	CALL        _formirajNiz+0, 0
;Master.c,342 :: 		len = putConstString(httpHeader); // HTTP header
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
;Master.c,343 :: 		len += putConstString(httpMimeTypeHTML);
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
;Master.c,344 :: 		len += putString(niz); // with HTML MIME type
	MOVLW       _niz+0
	MOVWF       FARG_putString_s+0 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FARG_putString_s+1 
	CALL        _putString+0, 0
	MOVF        R0, 0 
	ADDWF       SPI_Ethernet_UserTCP_len_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      SPI_Ethernet_UserTCP_len_L0+1, 1 
;Master.c,345 :: 		for (i = 0; i < 16; i++)
	CLRF        SPI_Ethernet_UserTCP_i_L0+0 
	CLRF        SPI_Ethernet_UserTCP_i_L0+1 
L_SPI_Ethernet_UserTCP75:
	MOVLW       0
	SUBWF       SPI_Ethernet_UserTCP_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__SPI_Ethernet_UserTCP107
	MOVLW       16
	SUBWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
L__SPI_Ethernet_UserTCP107:
	BTFSC       STATUS+0, 0 
	GOTO        L_SPI_Ethernet_UserTCP76
;Master.c,347 :: 		Comm[i] = 0x00;
	MOVLW       _Comm+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,348 :: 		Cmd[i] = 0x00;
	MOVLW       _Cmd+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cmd+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,349 :: 		Cat[i] = 0x00;
	MOVLW       _Cat+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cat+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,350 :: 		Hour[i] = 0x00;
	MOVLW       _Hour+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Hour+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,351 :: 		Min[i] = 0x00;
	MOVLW       _Min+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Min+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,352 :: 		Sec[i] = 0x00;
	MOVLW       _Sec+0
	ADDWF       SPI_Ethernet_UserTCP_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Sec+0)
	ADDWFC      SPI_Ethernet_UserTCP_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Master.c,345 :: 		for (i = 0; i < 16; i++)
	INFSNZ      SPI_Ethernet_UserTCP_i_L0+0, 1 
	INCF        SPI_Ethernet_UserTCP_i_L0+1, 1 
;Master.c,353 :: 		}
	GOTO        L_SPI_Ethernet_UserTCP75
L_SPI_Ethernet_UserTCP76:
;Master.c,354 :: 		}             //  if(len == 0)
L_SPI_Ethernet_UserTCP74:
;Master.c,355 :: 		return (len); // return to the library with the number of bytes to transmit
	MOVF        SPI_Ethernet_UserTCP_len_L0+0, 0 
	MOVWF       R0 
	MOVF        SPI_Ethernet_UserTCP_len_L0+1, 0 
	MOVWF       R1 
;Master.c,356 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserTCP

_SPI_Ethernet_UserUDP:

;Master.c,359 :: 		unsigned int reqLength, TEthPktFlags *flags)
;Master.c,362 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;Master.c,363 :: 		}
	RETURN      0
; end of _SPI_Ethernet_UserUDP

_init_variables:

;Master.c,364 :: 		void init_variables()
;Master.c,366 :: 		br_ch = 0x00;
	CLRF        _br_ch+0 
;Master.c,367 :: 		OBB = 0x00;
	CLRF        _OBB+0 
;Master.c,368 :: 		Flag1 = 0x00;
	CLRF        _Flag1+0 
;Master.c,369 :: 		Flag2 = 0x00;
	CLRF        _Flag2+0 
;Master.c,370 :: 		Flag3 = 0x00;
	CLRF        _Flag3+0 
;Master.c,371 :: 		brojac = 0x00;
	CLRF        _brojac+0 
;Master.c,372 :: 		RAMP_ID = 0x0F;
	MOVLW       15
	MOVWF       _RAMP_ID+0 
;Master.c,373 :: 		for (i = 0; i < 150; i++)
	CLRF        _i+0 
L_init_variables78:
	MOVLW       150
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_init_variables79
;Master.c,374 :: 		niz[i] = 0x00;
	MOVLW       _niz+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_niz+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,373 :: 		for (i = 0; i < 150; i++)
	INCF        _i+0, 1 
;Master.c,374 :: 		niz[i] = 0x00;
	GOTO        L_init_variables78
L_init_variables79:
;Master.c,375 :: 		for (i = 0; i < 16; i++)
	CLRF        _i+0 
L_init_variables81:
	MOVLW       16
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_init_variables82
;Master.c,377 :: 		Operation[i] = 0x00;
	MOVLW       _Operation+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Operation+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,378 :: 		Comm[i] = 0x00;
	MOVLW       _Comm+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Comm+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,379 :: 		Cmd[i] = 0x00;
	MOVLW       _Cmd+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cmd+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,380 :: 		Cat[i] = 0x00;
	MOVLW       _Cat+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Cat+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,381 :: 		Hour[i] = 0x00;
	MOVLW       _Hour+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Hour+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,382 :: 		Min[i] = 0x00;
	MOVLW       _Min+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Min+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,383 :: 		Sec[i] = 0x00;
	MOVLW       _Sec+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_Sec+0)
	MOVWF       FSR1H 
	MOVF        _i+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Master.c,375 :: 		for (i = 0; i < 16; i++)
	INCF        _i+0, 1 
;Master.c,384 :: 		}
	GOTO        L_init_variables81
L_init_variables82:
;Master.c,385 :: 		}
	RETURN      0
; end of _init_variables

_init:

;Master.c,387 :: 		void init()
;Master.c,390 :: 		PIR1 = 0b00000000; // flegovi prijema preko UART-a
	CLRF        PIR1+0 
;Master.c,391 :: 		PIE1 = 0b00100001; // dozvola prekida za UART, RCIE, TMR1IE
	MOVLW       33
	MOVWF       PIE1+0 
;Master.c,395 :: 		T1CON = 0b10110000; // konfiguracija za tajmer1
	MOVLW       176
	MOVWF       T1CON+0 
;Master.c,396 :: 		T1CON.TMR1ON = 1;
	BSF         T1CON+0, 0 
;Master.c,402 :: 		TMR1L = 0xB5;
	MOVLW       181
	MOVWF       TMR1L+0 
;Master.c,403 :: 		TMR1H = 0xB3;
	MOVLW       179
	MOVWF       TMR1H+0 
;Master.c,405 :: 		INTCON = 0b01000000; // periferijski interapt
	MOVLW       64
	MOVWF       INTCON+0 
;Master.c,406 :: 		INTCON.GIE = 1;      // globalna dozvola prekida
	BSF         INTCON+0, 7 
;Master.c,409 :: 		TRISA = 0x00;
	CLRF        TRISA+0 
;Master.c,411 :: 		TRISB = 0x0F; // ostali pinovi PORTB su izlazi
	MOVLW       15
	MOVWF       TRISB+0 
;Master.c,412 :: 		TRISC = 0xD0; // 0b11010000; // ovo je OK
	MOVLW       208
	MOVWF       TRISC+0 
;Master.c,414 :: 		PORTA = 0x00;
	CLRF        PORTA+0 
;Master.c,415 :: 		PORTB = 0x00;
	CLRF        PORTB+0 
;Master.c,416 :: 		PORTC = 0x00;
	CLRF        PORTC+0 
;Master.c,418 :: 		ADCON0 = 0x00; // iskljucujemo A/D konverziju
	CLRF        ADCON0+0 
;Master.c,419 :: 		ADCON1 = 0x0F; // svi digitalni
	MOVLW       15
	MOVWF       ADCON1+0 
;Master.c,422 :: 		UART1_Init(19200);
	MOVLW       80
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;Master.c,424 :: 		TXSTA.TXEN = 1;
	BSF         TXSTA+0, 5 
;Master.c,425 :: 		RCSTA.SPEN = 1;
	BSF         RCSTA+0, 7 
;Master.c,426 :: 		RCSTA.CREN = 1;
	BSF         RCSTA+0, 4 
;Master.c,428 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;Master.c,429 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Master.c,430 :: 		UpdateLCD();
	CALL        _UpdateLCD+0, 0
;Master.c,432 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV64, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       2
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Master.c,433 :: 		SPI_Ethernet_Init(myMacAddr, myIpAddr, SPI_Ethernet_FULLDUPLEX); // inicijalizujemo Ethernet port
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
;Master.c,434 :: 		}
	RETURN      0
; end of _init

_transmit:

;Master.c,436 :: 		void transmit(unsigned char DATA8b)
;Master.c,438 :: 		TXREG = DATA8b;
	MOVF        FARG_transmit_DATA8b+0, 0 
	MOVWF       TXREG+0 
;Master.c,439 :: 		while (!TXSTA.TRMT)
L_transmit84:
	BTFSC       TXSTA+0, 1 
	GOTO        L_transmit85
;Master.c,440 :: 		;
	GOTO        L_transmit84
L_transmit85:
;Master.c,441 :: 		}
	RETURN      0
; end of _transmit

_main:

;Master.c,443 :: 		void main(void)
;Master.c,446 :: 		unsigned char ByteX = 0x00;
	CLRF        main_ByteX_L0+0 
;Master.c,448 :: 		init();
	CALL        _init+0, 0
;Master.c,449 :: 		init_variables();
	CALL        _init_variables+0, 0
;Master.c,451 :: 		while (1)
L_main86:
;Master.c,453 :: 		SPI_Ethernet_doPacket();
	CALL        _SPI_Ethernet_doPacket+0, 0
;Master.c,454 :: 		if (Flag1 == 0x01)
	MOVF        _Flag1+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main88
;Master.c,456 :: 		Flag1 = 0x00; // vratimo FLAG1 na nulu
	CLRF        _Flag1+0 
;Master.c,457 :: 		RAMP_ID++;    // biramo sledeci slejv
	INCF        _RAMP_ID+0, 1 
;Master.c,458 :: 		if (RAMP_ID == 0x10)
	MOVF        _RAMP_ID+0, 0 
	XORLW       16
	BTFSS       STATUS+0, 2 
	GOTO        L_main89
;Master.c,460 :: 		RAMP_ID = 0x00;
	CLRF        _RAMP_ID+0 
;Master.c,461 :: 		PORTA.F4 = 1; //pali se dioda na svake 2 sekunde, 16x125ms=2s
	BSF         PORTA+0, 4 
;Master.c,462 :: 		if (Flag3 == 0x01)
	MOVF        _Flag3+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main90
;Master.c,464 :: 		Flag3 = 0x00;
	CLRF        _Flag3+0 
;Master.c,465 :: 		Flag2 = 0x00;
	CLRF        _Flag2+0 
;Master.c,466 :: 		}
	GOTO        L_main91
L_main90:
;Master.c,469 :: 		else if (Flag2 == 0x01)
	MOVF        _Flag2+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main92
;Master.c,470 :: 		Flag3 = 0x01;
	MOVLW       1
	MOVWF       _Flag3+0 
L_main92:
L_main91:
;Master.c,471 :: 		UpdateLCD();
	CALL        _UpdateLCD+0, 0
;Master.c,472 :: 		}
	GOTO        L_main93
L_main89:
;Master.c,474 :: 		PORTA.F4 = 0;
	BCF         PORTA+0, 4 
L_main93:
;Master.c,476 :: 		if (Flag3 == 0x00)
	MOVF        _Flag3+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main94
;Master.c,478 :: 		DR = 1;
	BSF         PORTA+0, 5 
;Master.c,479 :: 		if (Operation[RAMP_ID] == 0x01)
	MOVLW       _Operation+0
	MOVWF       FSR0L 
	MOVLW       hi_addr(_Operation+0)
	MOVWF       FSR0H 
	MOVF        _RAMP_ID+0, 0 
	ADDWF       FSR0L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main95
;Master.c,480 :: 		ByteX = 0x30 + RAMP_ID;
	MOVF        _RAMP_ID+0, 0 
	ADDLW       48
	MOVWF       main_ByteX_L0+0 
	GOTO        L_main96
L_main95:
;Master.c,482 :: 		ByteX = 0x20 + RAMP_ID;
	MOVF        _RAMP_ID+0, 0 
	ADDLW       32
	MOVWF       main_ByteX_L0+0 
L_main96:
;Master.c,483 :: 		transmit(ByteX);
	MOVF        main_ByteX_L0+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,484 :: 		DR = 0;
	BCF         PORTA+0, 5 
;Master.c,485 :: 		OBB = 0x05; //OBB (ocekivani broj bajtova) postavlja se na 5,
	MOVLW       5
	MOVWF       _OBB+0 
;Master.c,487 :: 		} // if (Flag3==0x00
	GOTO        L_main97
L_main94:
;Master.c,490 :: 		DR = 1;
	BSF         PORTA+0, 5 
;Master.c,491 :: 		ByteX = 0x70 + RAMP_ID;
	MOVF        _RAMP_ID+0, 0 
	ADDLW       112
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       main_ByteX_L0+0 
;Master.c,492 :: 		transmit(ByteX); // komandni
	MOVF        R0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,493 :: 		transmit(seconds);
	MOVF        _seconds+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,494 :: 		transmit(minutes);
	MOVF        _minutes+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,495 :: 		transmit(hours);
	MOVF        _hours+0, 0 
	MOVWF       FARG_transmit_DATA8b+0 
	CALL        _transmit+0, 0
;Master.c,496 :: 		DR = 0;
	BCF         PORTA+0, 5 
;Master.c,497 :: 		OBB = 0x05; // opet se OBB postavlja na 5 jer posle ovoga slede potvrde ispravnog pode�avanja sata
	MOVLW       5
	MOVWF       _OBB+0 
;Master.c,498 :: 		}              //else
L_main97:
;Master.c,499 :: 		}                 // od Flag1==1
L_main88:
;Master.c,500 :: 		}                    // while (1)
	GOTO        L_main86
;Master.c,501 :: 		}
	GOTO        $+0
; end of _main
