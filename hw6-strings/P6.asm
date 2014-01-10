;Aaron Grant
;CSC 277
;Program 6

.model small
.stack 100h
.data
			message1 db 'enter your 1st string to insert  : $'
                  message2 db 'enter your 2nd string : $'
                  message3 db 'enter the value you would like to insert at :  $'
                  message4 db 'the new string is : $'
                  spacer db 13, 10, '$'

                  str_  db 80 dup(?)
                  str_1 db 40 dup(?)
                  str_2 db 40 dup(?)
                  num dw ?

.code

start:
                mov ax, @data
                mov ds, ax

                push ds
		     pop es

p1:
                lea dx, message1
                mov ah, 9
		    int 21h

                lea di, str_1
                call read 


                lea dx, spacer          
                mov ah, 9
		    int 21h
        
p2:
                lea dx,message2
                mov ah,9
                int 21h
                lea di,str_2
                call read
                lea dx, spacer          
                mov ah, 9
		    int 21h


p3:
                lea dx,message3
                mov ah,9
                int 21h

		    call  indec
                mov num, ax
                call insert

                lea dx, spacer          
                mov ah, 9
		    int 21h
        
                lea dx, message4          
                mov ah, 9
		    int 21h

                mov dx, offset str_  
                mov ah,9
                int 21h

         ; exit to dos 
                mov ah,4ch
                int 21h

     include  insert.asm
     include  read.asm
     include  indec.asm
end start

