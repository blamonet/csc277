title First program for CSC 277

.MODEL SMALL
.STACK 100H
.DATA
goodCt  db   0
OKCt    db   0
poorCt  db   0
failCt  db   0
space   db   10,13,'$'
good    db   "A",'$'
OK      db   "B",'$'
poor    db   "C",'$'
fail    db   "F",'$'
message db  10,13,"Enter test scores or negative number to quit:",'$'

Header db   "Your Name Here",10,13,"CSC 277 Program #4",10,13
       db   "Test Score  Histogram",10,13,'$'
Histo  db   "Histogram",10,13,'$'
ExitMess db   10,13,"That's all folks!!",13,10,'$'
.code
EXTRN histogram : PROC
MAIN  PROC
; Initialize DS register
          mov   ax,@data      ;get data segment address
          mov   ds,ax         ; initialize DS
; Display Header
          lea   dx,Header     ; parameter to dos printstring
          mov   ah,9          ; printstring function #9
          int   21h           ; invoke printstring funtion
; Prompt user to input scores here
          lea   dx,message
          mov   ah,9
          int   21h
; Read in test scores until negative number input
getNext:
           lea      dx,space
           mov      ah,9
           int      21h

           call  indec         ; returns binary number in AX
           cmp   ax,0
           jl    endRead
;Check score range
           cmp    ax,55
           jnl    ckp
; Here you know the test score was between 0-54
           inc    failct
           jmp    getNext
ckp:
	     cmp    ax,69
	     jnl    ckp2
           inc   poorct
           jmp   getNext
ckp2:
           cmp   ax, 84
           jnl   ckp3
           inc   OKct
           jmp   getNext
ckp3:
	      inc   goodct
           jmp   getNext

Next:
           jmp   getNext
; Here a negative number has been input so print out histogram
EndRead:


; Print labels for output, displaying X & Y also
          lea      dx,histo
          mov      ah,9
          int      21h


          mov      al,failct
          cmp      al,0
          je       nextpoor
	    xor      cx,cx
          mov      cl,failct
          lea      dx,fail
	    call     histogram

          
nextpoor:
          mov      al,poorct
          cmp      al,0
          je       nextok
	    xor      cx,cx
          mov      cl,poorct
          lea      dx,poor
	    call     histogram

nextOK:
          mov      al,OKct
          cmp      al,0
          je       nextgood
	    xor      cx,cx
          mov      cl,OKct
          lea      dx,ok
	    call     histogram

nextgood:

          mov      al,goodct
          cmp      al,0
          je       endit
	    xor      cx,cx
          mov      cl,goodct
          lea      dx,good
	    call     histogram

endit:
   
          lea      dx,exitmess
          mov      ah,9
          int      21h
; Exit to DOS using exitcode macro
          mov      ah,4ch
          int      21h
main endp
include indec.asm
          end  MAIN
