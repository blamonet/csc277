;Aaron Grant
;Looping, Jumping, and Cases Program
;Program 2
;CSC 277

.MODEL SMALL
.STACK 100H
.DATA
goodCt  db   0
good    db   10,13,'Good:$'
goodWd  db   1,'$'
OKCt    db   0
OK      db   10,13,'OK:$'
OKWd    db   4,'$'
poorCt  db   0
poor    db   10,13,'Poor:$'
poorWd  db   2,'$'
failCt  db   0
fail    db   10,13,'Fail:$'
failWd  db   3,'$'
spacer  db   10,13,'$'
message db  10,13,"Enter test scores or negative number to quit:$"

Header db   "Aaron Grant",10,13,"CSC 277 Program #2",10,13
       db   "Test Score  Histogram",10,13,"$"
TestMess db   10,13,10,13,"Analysis of Grades",'$'
ExitMess db   10,13,"End of Test Results!",13,10,'$'
.code
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
           call  indec         ; returns binary number in AX
           cmp   ax,0
           jl    endRead
;Check score range
           cmp    ax,54
           jg   	ckp     ; if > 54, go to ckp else failct++
; Here you know the test score was between 0-54
           inc    failct
           jmp    getNext
ckp:
           cmp    ax,69
           jg     dkp    ; if > 69, go to dkp else poorct++
           inc    poorCt
           jmp   getNext
dkp:
           cmp    ax,84
           jg     ekp    ; if > 84, go to dkp else OKct++
           inc    OKCt
           jmp   getNext
ekp:
           inc    goodCt  ;  > 84 goodct++
           jmp   getNext

Next:
           jmp   getNext
; Here a negative number has been input so print out histogram
EndRead:


; Print labels for output, displaying X & Y also
          lea      dx,TestMess
          mov      ah,9
          int      21h
          lea      dx,spacer
          mov      ah,9
          int      21h

          lea      dx,fail      ; loads label into dx to print
          mov      ah,9
          int      21h
          cmp      failCt,0     ; sees if there was a grade in this catagory
          jbe       STEP2       ; if below or equal to 0, jump to the next catagory
          mov      cl,failCt    ; else load cl with counter number
          mov      dx,offset failWd  ;load in character to print number of cases
          NEXTfail:             ; while cx > 0, keep going
          mov      ah,9
          int      21h
          LOOP NEXTfail
STEP2:
          lea      dx,poor
          mov      ah,9
          int      21h
          cmp      poorCt,0
          jbe       STEP3
          mov      cl,poorCt
          mov      dx,offset poorWd
          NEXTpoor:
          mov      ah,9
          int      21h
          LOOP NEXTpoor
STEP3:

          lea      dx,OK
          mov      ah,9
          int      21h
          cmp      OKCt,0
          jbe       STEP4
          mov      cl,OKCt
          mov      dx,offset OKWd
          NEXTOK:
          mov      ah,9
          int      21h
          LOOP NEXTOK
STEP4:
          lea      dx,good
          mov      ah,9
          int      21h
          cmp      goodCt,0
          jbe       STEP5
          mov      cl,goodCt
          mov      dx,offset goodWd
          NEXTgood:
          mov      ah,9
          int      21h
          LOOP NEXTgood
STEP5:


          lea      dx,exitmess
          mov      ah,9
          int      21h

; Exit to DOS using exitcode macro
          mov      ah,4ch
          int      21h
main endp
          INCLUDE  inDEC.ASM
          end  MAIN

