; Aaron Grant
; CSC 277
; Program #7

.MODEL  small
.DATA
highest dw   ?
.code
	PUBLIC findmax
     findmax   PROC

     push bp
     mov bp, sp
     push ax
     push bx
     push cx
     push dx 


     mov cx, [bp+6]
     mov bx, [bp+8]

	mov ax, [bx]
	add bx, 2
 
next:
     cmp  [bx], ax
     ja higher
     jmp next1
higher:
     mov ax, [bx]
     jmp next1
next1:
     add bx, 2
     loop next




     mov bx, [bp+4]
     mov [bx], ax

     pop dx
     pop cx
     pop bx
     pop ax
     pop bp
ret 6


     findmax   ENDP
END