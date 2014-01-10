                insert proc
                push ax
                push si
                push di

                lea si, str_2
                lea di, str_

		    cmp num, 0h
		    je c1


                xor ax, ax



i2:
                cld
                movsb
                inc ax
                cmp ax, num
                je c1
                jmp i2
c1:
                mov si, offset str_1
i1:
                cmp byte ptr [si], '$'
                je c2
                movsb
                jmp i1
c2:
                lea si, str_2
                add si, num                
c3:
                movsb
                cmp byte ptr [di], '$'
                je end_
                jmp c3

c0:
		    mov si, offset str_1   
c0a:
                movsb
                jmp c0a

end_:
                pop di
                pop si
                pop ax
                ret
                 
                insert endp