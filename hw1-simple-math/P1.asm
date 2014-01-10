title First program for CSC 277

.MODEL SMALL
.STACK 100H
.DATA

result  dw   ?     ;Reserved storage for result of calculation X + 2y + 1
Header  db   "Aaron Grant",10,13,"CSC 277 Program #1",10,13
        db   "Simple Arithmetic",10,13,"$"
slashn  db   10,13,"$" 
entern  db   10,13,"Enter X : ","$"
entern2 db   10,13,"Enter Y : ","$"
sumtext db   10,13,"Given X = "
X       db   ?
        db   " and given Y = "
Y       db   ?
        db   ", the result of calculation : X + 2 * Y + 1 = ","$"


.code
MAIN  PROC
; Initialize DS register
          mov   ax,@data      ;get data segment address
          mov   ds,ax         ; initialize DS
; Display Header
          lea   dx,Header     ; parameter to dos printstring
          mov   ah,9          ; printstring function #9
          int   21h           ; invoke printstring funtion


; Prompt user to input X & Y here
          lea   dx,entern     ; Enter X
          mov   ah,9          ; printstring function #9
          int   21h           ; invoke printstring funtion
          mov   ah,1
          int   21h           ; ASCII # returned in AL reg.
          mov   X,al          ; save ASCII for output later

          lea   dx,entern2    ; Enter Y
          mov   ah,9          ; printstring function #9
          int   21h           ; invoke printstring funtion
          mov   ah,1
          int   21h           ; ASCII # returned in AL reg.
          mov   Y,al          ; save ASCII for output later

; Read in X, and store at X
          mov   al,X
          sub   al,30h        ; since we have a character 3x, subtract 30h to leave the x part
          mov   bl,al

          mov   al,Y
          sub   al,30h

          add   bl,al         ; add x to y
          add   bl,al         ; add previous to y
          add   bl,1          ; add previous to 1
          mov   ah,0          ; clear ah
          mov   al,bl         ; move contents of bl to al
          mov   result,ax     ; move ax to memory



; Print labels for output, displaying X & Y also

          lea   dx,sumtext    ; Equation Print
          mov   ah,9          ; printstring function #9
          int   21h           ; invoke printstring funtion

; Print calculated result using procedure outdec included below.
; Outdec will covert the word in the AX register to a character string
; and display it on the crt.
          mov   ax,result
          call  outdec

; Exit to DOS using exitcode macro
          EXITCODE
main endp
          INCLUDE  OUTDEC.ASM
          end  MAIN
