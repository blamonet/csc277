.MODEL SMALL
.STACK 100H
.DATA
PROMPT   db  10,13,"Please input a positive #, or negative # to exit: $"
Exitmess db  10,13,10,13,"The End. . .$"
PosMess  db  10,13,10,13,"What base would you like to convert to: $"
Spacer   db  10,13,'$'
Header db   "Aaron Grant",10,13,"CSC 277 Program #5",10,13
       db   "Stack Program",10,13,'$'
Number   dw  ?
Base     dw  ?
dividend dw  ?
ct	   db 0
 
.code
MAIN  PROC
	mov   ax,@data  ;get data segment address
	mov   ds,ax     ; initialize DS


	mov   dx,offset Header
	mov   ah,9
	int   21h       ; display string
	mov   dx,offset spacer
	mov   ah,9
	int   21h       ; display string

GetInput:
	mov   ah,9          ; print string funtion
	mov   dx,offset PROMPT ;DS:DX points to string
	int   21h
	call  indec   ;Returns # in AX



IF_:
        CMP   AX,0      ; Is # < 0?
        JL    EXITLOOP  ; yes so exit loop

THEN:
	mov   Number, ax
	mov   dividend, ax

tryagain:
	mov   dx,offset PosMess
	mov   ah,9
	int   21h       ; display string
	call  indec
      cmp   ax, 9h    ; if base zero, try again
      ja    tryagain  
      cmp   ax, 1h    ; if base one, try again
      jbe   tryagain
	mov   Base, ax


divagain:
	xor   dx, dx
	mov   bx, Base
	mov   ax, dividend
	div   bx
	mov   bx, dx
	push  bx
	mov   dividend, ax
	
	mov   al, ct
	add   al, 1h
	mov   ct, al

	mov   ax, dividend
	cmp   ax, 0h
	je    printstack ; jump on zero
	jmp   divagain

printstack:
	mov   ah,9          ; print string funtion
	mov   dx,offset spacer  ;DS:DX points to string
	int   21h
	xor   cx, cx
	mov   cl, ct
	mov   bp, sp

printagain:
     	mov   ax, [bp]
	add   bp, 2h
	call  outdec
loop printagain

	mov   ct, 0h
	mov   ah,9          ; print string funtion
	mov   dx,offset spacer  ;DS:DX points to string
	int   21h
	mov   ah,9          ; print string funtion
	mov   dx,offset spacer  ;DS:DX points to string
	int   21h
	jmp   GetInput  ;DO NOT FORGET THIS STEP

EXITLOOP:
; Display message using DOS function 9, then repeat
	mov   ah,9          ; print string funtion
	mov   dx,offset EXITMESS  ;DS:DX points to string
	int   21h

; Exit to DOS
     mov   ah,4Ch
     int   21h
main endp
     include  indec.asm
     include  outdec.asm
     end   MAIN


