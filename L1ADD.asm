data segment
	a dw 12H
	b dw 10H
	vsum dw ?
	vdiff dw ?
	vquo dw ?
	vprod dw ?
	msg_1 db 'Enter the N: $'
	msg_2 DB "Byee!$"
data ends

code segment
assume cs:code, ds:data
start:
	mov ax, data
	mov ds, ax

	; input a
	lea DX,msg_1
	call printf
	CALL read_8bit
	mov a, ax

	; input b
	lea DX,msg_1
	call printf
	CALL read_8bit
	mov b, ax

	CALL ADDITION
	mov dx, vsum
	call print_8bit

	CALL SUBTRACTION
	mov dx, vdiff
	call print_8bit

	CALL MULTIPLY
	mov dx, vprod
	call print_8bit

	CALL DIVIDE
	mov dx, vquo
	call print_8bit

	lea DX,msg_2
	call printf

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

ADDITION PROC
	mov ax, a
	mov bx, b
	add ax, bx
	mov vsum, ax
	RET
ADDITION ENDP

SUBTRACTION PROC
	mov ax, a
	mov bx, b
	sub ax, bx
	mov vdiff, ax
	RET
SUBTRACTION ENDP

DIVIDE PROC
	mov ax, a
	xor dx, dx
	mov bx, b
	div bx
	mov vquo, ax
	RET
DIVIDE ENDP

MULTIPLY PROC
	mov ax, a
	mov bx, b
	mul bx
	mov vprod, ax
	RET
MULTIPLY ENDP

EXIT:
	int 3H
	code ends
	end start
