Data Segment
  str1 db '12345','$'  
  strlen1 dw $-str1
  ans dw ?
Data Ends

Code Segment
  Assume cs:code, ds:data

  Begin:
    mov ax, data
    mov ds, ax

    lea si, str1
    lea di, str1

    add di, strlen1
    add di, -2

CHECK:
        MOV AL,[SI]
        MOV BL, [DI]

        PUSH DX
        MOV DL, BL
        call print_8bit
        POP DX

        CMP BL,AL
        JNE NOTPALINDROME

        INC SI
        DEC DI
        CMP SI,DI
        JL CHECK
  MOV ANS, 1
  JMP EXIT

NOTPALINDROME:
  MOV ANS, 0   
JMP EXIT

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

Code Ends
End Begin
