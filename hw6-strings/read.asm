        read proc
                push ax
                cld
                mov ah,1
                int 21h
whileit:
                cmp al,0dh
                je endit 
                stosb

                int 21h
                jmp whileit

endit:
                mov al, '$'
                stosb
                pop ax                
                ret
                                
        read endp