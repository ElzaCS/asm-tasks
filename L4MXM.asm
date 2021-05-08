DATA SEGMENT
    R1 DW 03H 
    C1 DW 02H
    C2 DW 03H

    MA DB 01H,02H
       DB 03H,04H 
       DB 05H,06H 
    MB DB 01H,02H,03H
       DB 04H,05H,06H
    MC DB 9 DUP(?)                       
    msg_A db 'Enter A: $'
    msg_B db 'Enter B: $'
    msg_1 db 'Enter the N: $'
    msg_2 DB "Byee!$"
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA , CS:CODE  
    START: 
	MOV AX , DATA
	MOV DS , AX

	MOV AX , AX
	MOV BP , 0H 
	MOV DI , 0H
	MOV SI , 0H
	MOV CX , R1		
	MOV DH , 0H 

    ; get input !!!
    push si
    LEA SI, MA
    lea DX,msg_A
    call printf
    push ax
        mov ax, R1
        mul c1
    mov cx, ax
    INPUTA:
        push cx
        lea DX,msg_1
        call printf
        CALL read_8bit
        mov [SI], ax
        inc si
        pop cx
        dec cx
        cmp cx, 0H
        jne INPUTA

    LEA SI, MB
    lea DX,msg_B
    call printf
    mov ax, C1
    mul c2
    mov cx, ax
    INPUTB:
        push cx
        lea DX,msg_1
        call printf
        CALL read_8bit
        mov [SI], ax
        inc si
        pop cx
        dec cx
        cmp cx, 0H
        jne INPUTB

    ; multiplication !!!
    MOV AX , AX
    MOV BP , 0H 
    MOV DI , 0H
    MOV SI , 0H
    MOV CX , R1     
    MOV DH , 0H 

    ;xor dx, dx      

	FOR1: 
    	PUSH CX 
    	MOV CX,C2
    	FOR2:
    		PUSH CX
    		MOV CX,C1 
    		FOR3: 
        		MOV AL,MA[SI] 
        		IMUL MB[DI] 
        		ADD DH,AL
			    INC SI		    
        		ADD DI,C2     
        		LOOP FOR3 

		        POP CX
    		MOV MC[BP],DH     	
    		MOV DH,0H
    		INC BP
    		SUB SI,C1	
    		SUB DI,5H		
    		LOOP FOR2
    
    	POP CX
    	ADD SI , C1        
    	MOV DI , 0H			
    	LOOP FOR1 

; output printing !!!
lea DX,msg_2
call printf
    xor dx, dx
    mov ax, 9H      
    mov cl, 0
    mov ax, r1
        mul c2
        mov cx, ax
    LEA SI,MC
;print array
OUTPUTFOR:
        push cx
        lea DX,msg_2
        call printf
        mov dx, [si]
        CALL print_8bit
        pop cx
        dec cx
        inc si
        cmp cx, 0h
        jne OUTPUTFOR
JMP EXIT

printf proc near
    push DX

    MOV dl, 10  ; new line
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

    MOV dl, 10  ; new line
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
    INT 3
    CODE ENDS
    END START