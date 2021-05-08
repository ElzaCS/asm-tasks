.MODEL SMALL
.STACK 100H
.DATA
	strA DB 0DH DUP("$")
	strB DB 0DH DUP("$")
	C DB 0DH DUP("$")
.CODE
MAIN PROC
	MOV AX,@DATA
        MOV DS,AX
        LEA SI,strA
INPUTA:
        INT 21H
        CMP AL,0DH
        JE NEXT1
        MOV [SI],AL
        INC SI
        JMP INPUTA
NEXT1:   
	MOV AL,"$"
        MOV [SI],AL     
        LEA SI,strB
INPUTB:
        INT 21H
        CMP AL,0DH
        JE NEXT2
        MOV [SI],AL
        INC SI
        JMP INPUTB    
NEXT2:
	MOV AL,"$"
        MOV [SI],AL
	LEA SI,strA
	PUSH 0H
CHECK:
	MOV AL,[SI]
	CMP AL,"$"
	JE PRINT
	INC SI
	LEA DI,strB
NEXTB:
	MOV BL,[DI]
	CMP BL,"$"
	JE WRITE
	CMP AL,BL
	JE CHECK
	INC DI
	JMP NEXTB
WRITE:
	LEA DI,C
	POP DX
	ADD DI,DX
	MOV [DI],AL
	INC DX
	PUSH DX
	JMP CHECK
PRINT:
	LEA DI,C
	MOV BL,"$"
	POP DX
	ADD DI,DX
        MOV [DI],BL
	MOV AH,09H
	LEA DX,C
	INT 21H
EXIT:
	MOV AH,4CH
	INT 21H
MAIN ENDP
END MAIN
	
