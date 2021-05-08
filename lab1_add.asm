data segment
a dw 12H
b dw 10H
vsum dw ?
vdiff dw ?
vquo dw ?
vprod dw ?
data ends

code segment
assume cs:code, ds:data
start:
mov ax, data
mov ds, ax
mov ax, a
mov bx, b
add ax, bx
mov vsum, ax

mov ax, a
sub ax, bx
mov vdiff, ax

mov ax, a
div bx
mov vquo, ax

mov ax, a
mov bx, b
mul bx
mov vprod, ax

int 3H
code ends
end start
