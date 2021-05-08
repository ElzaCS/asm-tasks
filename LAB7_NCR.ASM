Data Segment
  n dw 4
  r dw 2
  ans dw ?
Data Ends

Code Segment
  Assume cs:code, ds:data
  Begin:
    mov ax, data
    mov ds, ax

   mov AX, N
   MOV BX, R
   CALL NCR
   JMP exit

NCR PROC
  CMP BX,00
  JNE checkncn
  ADD ans,01
  RET

  checkncn:
    CMP BX,AX
    JNE checknc1
    ADD ans,01
    RET
  checknc1:
    CMP BX,1
    JNE checkncn1
    ADD ans,AX
    RET
  checkncn1:
    DEC AX
    CMP BX,AX
    JNE default
    INC AX
    ADD ans,AX
    RET
  default:
    PUSH AX
    PUSH BX
    CALL NCR
    POP BX
    POP AX

    DEC BX
    PUSH AX
    PUSH BX
    CALL NCR
    POP BX
    POP AX
    RET
  ncr endp


EXIT:

Code Ends
End Begin