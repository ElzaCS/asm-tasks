$NOMOD51

NAME	DOORLOOC

;assign values in data and bit address space
P0	DATA	080H
P1	DATA	090H
P2	DATA	0A0H
P3	DATA	0B0H
T0	BIT	0B0H.4
AC	BIT	0D0H.6
T1	BIT	0B0H.5
EA	BIT	0A8H.7
IE	DATA	0A8H
keycolumn1	BIT	0B0H.0
keycolumn2	BIT	0B0H.1
keycolumn3	BIT	0B0H.2
RD	BIT	0B0H.7
ES	BIT	0A8H.4
IP	DATA	0B8H
RI	BIT	098H.0
INT0	BIT	0B0H.2
CY	BIT	0D0H.7
TI	BIT	098H.1
INT1	BIT	0B0H.3
PS	BIT	0B8H.4
SP	DATA	081H
OV	BIT	0D0H.2
WR	BIT	0B0H.6
motorpin1	BIT	0B0H.3
motorpin2	BIT	0B0H.4
SBUF	DATA	099H
PCON	DATA	087H
SCON	DATA	098H
TMOD	DATA	089H
TCON	DATA	088H
IE0	BIT	088H.1
IE1	BIT	088H.3
B	DATA	0F0H
ACC	DATA	0E0H
ET0	BIT	0A8H.1
ET1	BIT	0A8H.3
TF0	BIT	088H.5
TF1	BIT	088H.7
RB8	BIT	098H.2
TH0	DATA	08CH
EX0	BIT	0A8H.0
IT0	BIT	088H.0
TH1	DATA	08DH
TB8	BIT	098H.3
EX1	BIT	0A8H.2
IT1	BIT	088H.2
P	BIT	0D0H.0
SM0	BIT	098H.7
TL0	DATA	08AH
SM1	BIT	098H.6
TL1	DATA	08BH
SM2	BIT	098H.5
en	BIT	0B0H.7
PT0	BIT	0B8H.1
PT1	BIT	0B8H.3
RS0	BIT	0D0H.3
keyrow1	BIT	0A0H.0
TR0	BIT	088H.4
RS1	BIT	0D0H.4
keyrow2	BIT	0A0H.1
TR1	BIT	088H.6
keyrow3	BIT	0A0H.2
PX0	BIT	0B8H.0
keyrow4	BIT	0A0H.3
PX1	BIT	0B8H.2
DPH	DATA	083H
DPL	DATA	082H
rs	BIT	0B0H.5
REN	BIT	098H.4
rw	BIT	0B0H.6
RXD	BIT	0B0H.0
TXD	BIT	0B0H.1
F0	BIT	0D0H.5
PSW	DATA	0D0H

;code segments
PR_main_DOORLOOC    SEGMENT CODE 
DT_main_DOORLOOC    SEGMENT DATA OVERLAYABLE 
PR_delay_DOORLOOC  SEGMENT CODE 
PR_lcdcmd_DOORLOOC SEGMENT CODE 
PR_lcddat_DOORLOOC SEGMENT CODE 
PR_lcddisplay_DOORLOOC                 SEGMENT CODE 
DT_lcddisplay_DOORLOOC                 SEGMENT DATA OVERLAYABLE 
PR_keypad_DOORLOOC  SEGMENT CODE 
PR_check_DOORLOOC   SEGMENT CODE 
CO_DOORLOOC         SEGMENT CODE 
?C_INITSEG           SEGMENT CODE 
DT_DOORLOOC         SEGMENT DATA 
	; ext declaractions for functions
	EXTRN	CODE (?C_STARTUP)
	EXTRN	CODE (?C?CLDOPTR)
	PUBLIC	pin
	PUBLIC	Epin
	PUBLIC	check
	PUBLIC	keypad
	PUBLIC	_lcddisplay
	PUBLIC	_lcddat
	PUBLIC	_lcdcmd
	PUBLIC	_delay
	PUBLIC	main

	RSEG  DT_main_DOORLOOC
main_label:
          temp_main:   DS   2

	RSEG  DT_lcddisplay_DOORLOOC
lcddisplay_label:
          temp:   DS   3
	ORG  3
          temp2:   DS   2

	RSEG  DT_DOORLOOC
           Epin:   DS   5
            pin:   DS   6

	RSEG  CO_DOORLOOC
S_ENTER:
	DB  'E' ,'N' ,'T' ,'E' ,'R' ,' ' ,'P' ,'I' ,'N' ,' ' 
	DB  'N' ,'U' ,'M' ,'B' ,'E' ,'R' ,000H

S_CORRECT:
	DB  'P' ,'I' ,'N' ,' ' ,'C' ,'O' ,'R' ,'R' ,'E' ,'C' 
	DB  'T' ,000H

S_OPEN:
	DB  'D' ,'O' ,'O' ,'R' ,' ' ,'O' ,'P' ,'E' ,'N' ,'E' 
	DB  'D' ,000H

S_WRONG:
	DB  'W' ,'R' ,'O' ,'N' ,'G' ,' ' ,'P' ,'I' ,'N' ,000H


	RSEG  ?C_INITSEG
	DB	006H
	DB	pin
	DB  '1' ,'2' ,'3' ,'4' ,'5' ,000H


; void main()
	RSEG  PR_main_DOORLOOC
main:
	USING	0
	; lcdcmd(0x0F); LINE # 38
	MOV  	R7,#0FH
	LCALL	_lcdcmd
	MOV  	R7,#038H
	LCALL	_lcdcmd
	MOV  	R7,#01H
	LCALL	_lcdcmd
	
WHILE_1:	; while (1) LINE # 44
	CLR  	A
	MOV  	temp_main,A
	MOV  	temp_main+01H,A
	MOV  	R7,#080H
	LCALL	_lcdcmd
	; lcddisplay("ENTER PIN NUMBER"); LINE # 46
	MOV  	R3,#0FFH
	MOV  	R2,#HIGH (S_ENTER)
	MOV  	R1,#LOW (S_ENTER)
	LCALL	_lcddisplay
	; delay(1000); LINE # 47
	LCALL	L_DELAY
	MOV  	R7,#0C0H
	LCALL	_lcdcmd
	
PIN_NE_ZERO:	; while (pin[i] != '\0') LINE # 49
	MOV  	A,#LOW (pin)
	ADD  	A,temp_main+01H
	MOV  	R0,A
	MOV  	A,@R0
	JZ   	L_CHECK

	; Epin[i] = keypad();	; LINE # 51
	LCALL	keypad
	MOV  	A,#LOW (Epin)
	ADD  	A,temp_main+01H
	MOV  	R0,A
	MOV  	@R0,AR7
	; delay(1000);	; LINE # 52
	LCALL	L_DELAY
	; i++;	; LINE # 53
	INC  	temp_main+01H
	MOV  	A,temp_main+01H
	JNZ  	PIN_NE_ZERO
	INC  	temp_main
WHILE_1_TERMINATE:			; LINE # 54
	SJMP 	PIN_NE_ZERO
L_CHECK:				; check();	; LINE # 55
	LCALL	check
	SJMP 	WHILE_1
; END OF main

; void delay(unsigned int j)
	RSEG  PR_delay_DOORLOOC
L_X_EQ_1:
	USING	0
L2_X_EQ_1:
	MOV  	R7,#02AH
	LCALL	_lcddat
L_DELAY:
	MOV  	R7,#0E8H
	MOV  	R6,#03H
_delay:
	USING	0			; LINE # 60
	CLR  	A
	MOV  	R5,A
	MOV  	R4,A
L2_DELAY:
	CLR  	C
	MOV  	A,R5
	SUBB 	A,R7
	MOV  	A,R4
	SUBB 	A,R6
	JNC  	L7_DELAY

	CLR  	A	; LINE # 64
	MOV  	R3,A
	MOV  	R2,A
L3_DELAY:
	INC  	R3
	CJNE 	R3,#00H,L4_DELAY
	INC  	R2
L4_DELAY:
	MOV  	A,R3
	XRL  	A,#0AH
	ORL  	A,R2
	JNZ  	L3_DELAY

L5_DELAY:		; LINE # 67
	INC  	R5
	CJNE 	R5,#00H,L6_DELAY
	INC  	R4
L6_DELAY:
	SJMP 	L2_DELAY

L7_DELAY: 	; LINE # 68
	RET  	
; END OF _delay


; void lcdcmd(unsigned char A)
	RSEG  PR_lcdcmd_DOORLOOC
_lcdcmd:
	USING	0	; LINE # 71
	MOV  	P1,R7	
	CLR  	rs		;     rs = 0;
	CLR  	rw		;     rw = 0;
	SETB 	en		;     en = 1;
	LCALL	L_DELAY	;     en = 1;
	CLR  	en		;     en = 0; 
	RET  			; LINE # 79
; END OF _lcdcmd


; void lcddat(unsigned char i)
	RSEG  PR_lcddat_DOORLOOC
_lcddat:
	USING	0			; LINE # 83
	MOV  	P1,R7		;     P1 = i;
	SETB 	rs			;     rs = 1;
	CLR  	rw			;     rw = 0;
	SETB 	en			;     en = 1;	
	LCALL	L_DELAY		;     en = 1;
	CLR  	en			;     en = 1;
	RET  	
; END OF _lcddat


; void lcddisplay(unsigned char *q)
	RSEG  PR_lcddisplay_DOORLOOC
_lcddisplay:
	USING	0	; LINE # 95
	MOV  	temp,R3
	MOV  	temp+01H,R2
	MOV  	temp+02H,R1		; LINE # 96
		
	;     for (k = 0; q[k] != '\0'; k++) LINE # 98
	CLR  	A
	MOV  	temp2,A
	MOV  	temp2+01H,A
L1_LCD:
	MOV  	R3,temp
	MOV  	R2,temp+01H
	MOV  	R1,temp+02H
	MOV  	DPL,temp2+01H
	MOV  	DPH,temp2
	LCALL	?C?CLDOPTR
	MOV  	R7,A
	JZ   	L3_DELAY

	; lcddat(q[k]);	LINE # 100
	LCALL	_lcddat

	INC  	temp2+01H
	MOV  	A,temp2+01H
	JNZ  	L1_LCD
	INC  	temp2
L2_LCD:
	SJMP 	L1_LCD
L3_LCD:		; delay(10000);	LINE # 102
	MOV  	R7,#010H
	MOV  	R6,#027H
	LJMP 	_delay
; END OF _lcddisplay


; char keypad()
	RSEG  PR_keypad_DOORLOOC
keypad:
	USING	0	
	CLR  	A		; int x = 0; LINE # 109
	MOV  	R7,A
	MOV  	R6,A
WHILE_X_0:		;     while (x == 0); LINE # 110
	MOV  	A,R7
	ORL  	A,R6
	JZ   	$ + 5H
	LJMP 	L12_KEYS

	; assign values for first row
	CLR  	keyrow1		; keyrow1 = 0; LINE # 113
	SETB 	keyrow2		; keyrow2 = 1; 
	SETB 	keyrow3		; keyrow3 = 1; 
	SETB 	keyrow4		; keyrow4 = 1; 
	JB   	keycolumn1,L1_KEYS		; if (keycolumn1 == 0)
	LCALL	L_X_EQ_1
	MOV  	R7,#031H
	RET  	

L1_KEYS:
	JB   	keycolumn2,L2_KEYS		; if (keycolumn2 == 0)	LINE # 124
	LCALL	L_X_EQ_1
	MOV  	R7,#032H
	RET  	
L2_KEYS:
	JB   	keycolumn3,L3_KEYS		; if (keycolumn3 == 0)	LINE # 131
	LCALL	L2_X_EQ_1
	MOV  	R7,#033H
	RET  	
	
L3_KEYS:
	;         // assign values for second row
	SETB 	keyrow1		; keyrow1 = 1; LINE # 139
	CLR  	keyrow2 	; keyrow2 = 0; 
	SETB 	keyrow3 	; keyrow3 = 1; 
	SETB 	keyrow4 	; keyrow4 = 1; 
	JB   	keycolumn1,L4_KEYS 		; if (keycolumn1 == 0)	
	LCALL	L2_X_EQ_1
	MOV  	R7,#034H
	RET  	
	
L4_KEYS:
	JB   	keycolumn2,L5_KEYS		; if (keycolumn2 == 0)	LINE # 151
	LCALL	L2_X_EQ_1
	MOV  	R7,#035H
	RET  	
	
L5_KEYS:
	JB   	keycolumn3,L6_KEYS		; if (keycolumn3 == 0)	LINE # 158
	LCALL	L2_X_EQ_1
	MOV  	R7,#036H
	RET  	

L6_KEYS:
	;assign values for third row
	SETB 	keyrow1	; keyrow1 = 1;	LINE # 167
	SETB 	keyrow2	; keyrow2 = 1;	
	CLR  	keyrow3	; keyrow3 = 0;	
	SETB 	keyrow4	; keyrow4 = 1;	
	JB   	keycolumn1,L7_KEYS	;  if (keycolumn1 == 0)	
	LCALL	L2_X_EQ_1
	MOV  	R7,#037H
	RET  	

L7_KEYS:
	JB   	keycolumn2,L8_KEYS	; if (keycolumn2 == 0)	LINE # 178
	LCALL	L2_X_EQ_1
	MOV  	R7,#038H
	RET  	

L8_KEYS:
	JB   	keycolumn3,L9_KEYS	; if (keycolumn3 == 0)	LINE # 185
	LCALL	L2_X_EQ_1
	MOV  	R7,#039H
	RET  	

L9_KEYS:
	;assign values for forth row
	SETB 	keyrow1	; keyrow1 = 1;	LINE # 194
	SETB 	keyrow2	; keyrow2 = 1;	
	SETB 	keyrow3	; keyrow3 = 1;	
	CLR  	keyrow4	; keyrow4 = 0;	
	JB   	keycolumn1,L10_KEYS	;   if (keycolumn1 == 0) 
	LCALL	L2_X_EQ_1
	MOV  	R7,#02AH
	RET  	

L10_KEYS:
	JB   	keycolumn2,L11_KEYS	; if (keycolumn2 == 0)	LINE # 206
	LCALL	L2_X_EQ_1
	MOV  	R7,#030H
	RET  	

L11_KEYS:
	JNB  	keycolumn3,$ + 6H	; if (keycolumn3 == 0)	LINE # 213
	LJMP 	WHILE_X_0
	LCALL	L2_X_EQ_1
	MOV  	R7,#023H
	RET  	

L12_KEYS:
	MOV  	R7,#023H	; return '#';	LINE # 221

L13_KEYS:
	RET  	
; END OF keypad

; void check()
	RSEG  PR_check_DOORLOOC
check:
	USING	0
	;  compare the input value with the assign password value
	;  if (pin[0] == Epin[0] && pin[1] == Epin[1] && pin[2] == Epin[2] && pin[3] == Epin[3] && pin[4] == Epin[4])
	; LINE # 229
	MOV  	A,pin
	XRL  	A,Epin
	JNZ  	CHECK_ELSE
	MOV  	A,pin+01H
	XRL  	A,Epin+01H
	JNZ  	CHECK_ELSE
	MOV  	A,pin+02H
	XRL  	A,Epin+02H
	JNZ  	CHECK_ELSE
	MOV  	A,pin+03H
	XRL  	A,Epin+03H
	JNZ  	CHECK_ELSE
	MOV  	A,pin+04H
	XRL  	A,Epin+04H
	JNZ  	CHECK_ELSE

	LCALL	L_DELAY	;         delay(1000);			; LINE # 231
	MOV  	R7,#01H 
	LCALL	_lcdcmd
	MOV  	R7,#081H
	LCALL	_lcdcmd
	; show pin is correct, lcddisplay("PIN CORRECT"); LINE # 235
	MOV  	R3,#0FFH
	MOV  	R2,#HIGH (S_CORRECT)
	MOV  	R1,#LOW (S_CORRECT)
	LCALL	_lcddisplay
	LCALL	L_DELAY	
	SETB 	motorpin1 ;  door motor will run;         motorpin1 = 1;			; LINE # 238
	CLR  	motorpin2 ;  motorpin2 = 0;			; LINE # 239
	MOV  	R7,#0C1H 
	LCALL	_lcdcmd
	; show the door is unlocked, lcddisplay("DOOR OPENED");	LINE # 242
	MOV  	R3,#0FFH
	MOV  	R2,#HIGH (S_OPEN)
	MOV  	R1,#LOW (S_OPEN)
	LCALL	_lcddisplay
	MOV  	R7,#010H
	MOV  	R6,#027H
	LCALL	_delay
	SETB 	motorpin1	;         motorpin1 = 1;			; LINE # 244
	CLR  	motorpin2	;         motorpin2 = 0;			; LINE # 245
	SJMP 	L1_CHECK
CHECK_ELSE:		;     else
	MOV  	R7,#01H	
	LCALL	_lcdcmd	; lcdcmd(0x01); LINE # 250
	MOV  	R7,#080H
	LCALL	_lcdcmd
	; lcddisplay("WRONG PIN"); LINE # 252
	MOV  	R3,#0FFH
	MOV  	R2,#HIGH (S_WRONG)
	MOV  	R1,#LOW (S_WRONG)
	LCALL	_lcddisplay
	LCALL	L_DELAY

L1_CHECK:
	MOV  	R7,#01H
	LCALL	_lcdcmd
	RET  	
; END OF check

	END
