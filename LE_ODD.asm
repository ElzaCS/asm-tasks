.MODEL SMALL
.STACK 100H
.DATA
	STR1 DB 0DH DUP("$")
	ANS DB 0DH DUP("$")

.CODE
MAIN PROC
	MOV AX,@DATA
        MOV DS,AX
        
        LEA SI,STR1
        MOV CL,0H
INPUT:
        INT 21H
        CMP AL,0DH
        JE INNEXT1
        MOV [SI],AL
        INC SI
        INC CL
        JMP INPUT
        MOV AL,"$"
        MOV [SI],AL
INNEXT1:        
        LEA SI,STR1
        LEA DI,ANS
TRAVERSE:
	MOV DL,[SI]
	CMP DL,"$"
	JE NEXT2
	INC SI
	JMP TRAVERSE
NEXT2:
	DEC SI
        MOV DL,01H
        INC CL
CHECK:
	TEST DL,1
	JZ SKIP
	MOV BL,[SI]
	MOV [DI],BL
	INC DI
SKIP:
	DEC SI
	INC DL
	CMP DL,CL
	JNE CHECK
PRINT:
	MOV BL,"$"
        MOV [DI],BL
	MOV AH,09H
	LEA DX,ans
	INT 21H
EXIT:
	MOV AH,4CH
	INT 21H
MAIN ENDP
END MAIN
	
