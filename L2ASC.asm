data segment
	N DB 03H
	NW DW 03H
	ARRAY DB 21H,12H,6H
	msg_1 db 'Enter the N: $'
	msg_2 DB "Byee!$"
data ends

code segment
assume cs:code, ds:data
start:
MOV AX,DATA
MOV DS,AX
	LEA SI,ARRAY

	;get N!!!

	lea DX,msg_1
	call printf
	CALL read_8bit
	mov N, al
	mov NW, ax

	;get array!!!

	mov cl, 0
	INPUTFOR:
		lea DX,msg_1
		call printf
		CALL read_8bit
		mov [SI], ax
		inc si
		inc cl
		cmp cl, N
		jl INPUTFOR

	; sorting !!!
xor dx, dx		
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

	; output printing !!!
lea DX,msg_2
call printf
	xor dx, dx
	mov ax, 9H		
	mov cl, 0
	mov cx, 0H
	LEA SI,ARRAY
;print array
OUTPUTFOR:
		push cx
		lea DX,msg_2
		call printf
		mov dx, [si]
		CALL print_8bit
		pop cx
		inc cx
		inc si
		cmp cx, NW
		jl OUTPUTFOR
JMP EXIT

printf proc near
	push DX

	MOV dl, 10	; new line
	MOV ah, 02h
	INT 21h
	MOV dl, 13
	MOV ah, 02h
	INT 21h

	pop DX
	mov AH,09h
	int 21h
	ret
printf endp

read_8bit proc near	
	mov AH,01h		
	int 21h
	sub AL,30h
	mov BL,AL	

	mov AH,01h		
	int 21h
	sub AL,30h
	mov AH,BL
	AAD	
			
	ret
read_8bit endp

print_8bit proc near	
	push DX

	MOV dl, 10	; new line
	MOV ah, 02h
	INT 21h
	MOV dl, 13
	MOV ah, 02h
	INT 21h

	pop DX
	mov ax,0000h
	mov al,dl
	mov bx,0010d
	mov CX,0000h
	
	Loop_push:
		mov DX,0000h
		div BX
		push DX
		inc CX
		cmp AX,0000h
	JNE Loop_push
	
	Loop_pop:
		pop DX
		add dx,0030h	
		mov ah,02h		
		int 21h
	loop Loop_pop
	
	mov dl,' '		
	mov ah,02h
	int 21h
	
	ret	
print_8bit endp

EXIT:
	int 3H
	code ends
	end start