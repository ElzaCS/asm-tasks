data segment
N DB 05H
ARRAY DB 21H,12H,6H,11H,15H
data ends

code segment
assume cs:code, ds:data
start:
MOV AX,DATA
MOV DS,AX
DEC N

MOV CH,N
MOV AH, 00H
OUTERFOR: 
	MOV CL,N
	LEA SI,ARRAY
 
INNERFOR: 
	MOV AL,[SI]
	MOV BL,[SI+1]
	CMP AL,BL
	JC DOWN
	MOV DL,[SI+1]
	XCHG [SI],DL
	MOV [SI+1],DL
 
DOWN: 
	INC SI
	DEC CL
	JNZ INNERFOR
	DEC CH
	JNZ OUTERFOR

int 3H
code ends
end start