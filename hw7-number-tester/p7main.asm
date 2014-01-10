         .MODEL small
         .stack 256
	  .286
Write2File  MACRO   count,string
	  pusha    
	  mov     ah,40h            ; DOS write function.
	  mov     bx,1              ; file handle for standard screen output
	  mov     cx,count          ;# characters to output
	  mov     dx,offset string  ; string to output
	  int     21h
	  popa
	  ENDM    Write2File
         EXTRN   FINDMAX: PROC   ; Declare in near code segmen
         .DATA
list      DW      50 dup (?)
max       DW      ?
count     DW      9
prompt    db      10,13,'Loading List from data file or keyboard, NEGATIVE NUMBER STOPS READ:',10,13
lenprompt EQU     $ - prompt
maxlab    db      10,13,'The largest number in the list is: '
maxlen    EQU     $ - maxlab
crlf      db      10,13
TestLab   db      10,13,'Testing to see if your procedure changed values of '
          db      'registers: BX, CX & BP',10,13
Testlen   EQU     $-TESTLAB
Before   db       'BEFORE call: '
beforelen  EQU    $- before
After     db      'AFTER call: '
afterlen  EQU     $-AFTER

;
; This is a simple example of a main program that calls FINDMAX,
; A NEAR subroutine written by students as program assignment #7.
;
; Parameters to this subroutine are passed on the stack and include:
;      THE ADDRESS OF THE LIST OF NUMBERS TO BE SEARCHED (pushed first)
;      THE COUNT OF NUMBERS  IN THE LIST (pushed second)
;      THE ADDRESS OF THE LOCATION WHERE THE FINDMAX PROCEDURE WILL STORE
;                     THE LARGEST NUMBER IN THE LIST.
;

         .CODE

start:   mov     ax,@data          ; Load segment location into
         mov     ds,ax             ;    DS register

         Write2File   lenprompt,prompt
         
; Load Table with data
         lea     bx,list
         xor     cx,cx
next:
         Write2File 2,crlf   ;go to new line for next number input
         call    indec       ; get next number input
         cmp     ax,0        ; negative number used to signal stop
         js      done
         mov     [bx],ax     ; store input number in table
         add     bx,2        ; update pointer to next record
         inc     cx          ; increment count
         jmp     next
done:
         mov     count,cx    ; store count

 ; Print contents of some registers before call, then after to verify
 ; findmax doesn't modify register contents.
         Write2File     Testlen,TestLab
         Write2File     beforelen,before
         mov    ax,bx
         call   outdec
         mov    ax,cx
         call   outdec
         mov    ax,bp
         call   outdec
         Write2File  2,crlf

 ;Push parameters and call procedure FINDMAX
         lea     ax,list          ; Place address of the list on stack.
         push    ax
         mov     ax,count         ; Store count next.
         push    ax
         lea     ax,max           ; Last value push on stack address of maxval
         push    ax
; This call to your subroutine is commented out now, so you can verify that the main
; program works and loads a table with numbers.  After you have completed the
; procedure findmax, REMOVE THE COMMENT ; BEFORE THE NEXT LINE.
         call    findmax


 ; Print contents of some registers AFTER call, to see if modified
         Write2File     Testlen,TestLab
         Write2File     afterlen,after
         mov    ax,bx
         call   outdec
         mov    ax,cx
         call   outdec
         mov    ax,bp
         call   outdec
         Write2File  2,crlf

; Write out the value returned by findmax
         Write2File  maxlen,maxlab
         mov     ax,max
         call    outdec
         Write2File  2,crlf

; Logical end of main program
         mov     ax,04C00h         ; Terminate with exit code 0
         int     21h               ; Call DOS
;*****************************************************
OUTDEC  PROC
    ;prints AX as a signed decimal integer
    ;input: AX
    ;output: none
            PUSH    AX              ;save registers
            PUSH    BX
            PUSH    CX
            PUSH    DX              
            push    ax    
   ; print a blank space first
            mov    ah,2
            mov    dl,' '
            int    21h
            pop    ax

    ;if AX < 0
            OR      AX,AX           ;AX < 0?
            JGE     @END_IF1        ;no, > 0
    ;then
            PUSH    AX              ;save number
            MOV     DL,'-'          ;get '-'
            MOV     AH,2            ;print char fcn
            INT     21H             ;print '-'
            POP     AX              ;get AX back
            NEG     AX              ;AX = -AX               
    @END_IF1:
    ;get decimal digits
            XOR     CX,CX           ;CX counts digits                 
            MOV     BX,10D          ;BX has divisor
    @REPEAT1:
            XOR     DX,DX           ;prepare high part of dividend  
            DIV     BX              ;AX = quotient, DX = remainder
            PUSH    DX              ;save remainder on stack
            INC     CX              ;count = count + 1
    ;until
            OR      AX,AX           ;quotient = 0?
            JNE     @REPEAT1        ;no, keep going
    ;convert digits to characters and print
            MOV     AH,2            ;print char fcn
    ;for count times do
    @PRINT_LOOP:
            POP     DX              ;digit in DL
            OR      DL,30H          ;convert to character
            INT     21H             ;print digit
            LOOP    @PRINT_LOOP     ;loop until done
    ;end_for
            POP     DX              ;restore registers
            POP     CX
            POP     BX
            POP     AX
            RET
    OUTDEC  ENDP

;*******************************************************
INDEC   PROC
     ;reads a number in range -32768 to 32767
     ;input: none
     ;output: AX = binary equivalent of number
             PUSH    BX              ;save registers used            
             PUSH    CX      
             PUSH    DX
     ;print prompt
     @BEGIN:
; skip prompt here reading from data file
;            MOV     AH,2
;             MOV     DL,'?'
;             INT     21H             ;print '?'
     ;total = 0
             XOR     BX,BX           ;BX holds total
     ;negative = false
             XOR     CX,CX           ;CX holds sign
     ;read a character
             MOV     AH,1
             INT     21H             ;character in AL
     ;case character of

             CMP     AL,'-'          ;minus sign?
             JE      @MINUS          ;yes, set sign
             CMP     AL,'+'          ;plus sign?
             JE      @PLUS           ;yes, get another char
             JMP     @REPEAT2        ;start processing chars
     @MINUS:
             MOV     CX,1            ;negative = true
     @PLUS:
             INT     21H             ;read a char
     ;end_case
     @REPEAT2:
     ;if character is between '0' and '9'
             CMP     AL,'0'          ;char >= '0'?
             JNGE    @NOT_DIGIT      ;illegal char
             CMP     AL,'9'          ;char <= '9'?
             JNLE    @NOT_DIGIT      ;no, illegal char
     ;then convert character to a digit
             AND     AX,000FH        ;convert to digit
             PUSH    AX              ;save on stack
     ;total = total*10 + digit
             MOV     AX,10           ;get 10
             MUL     BX              ;AX = total*10
             POP     BX              ;retrieve digit
             ADD     BX,AX           ;total = total*10 + digit
     ;read a character
             MOV     AH,1
             INT     21H     
             CMP     AL,0DH          ;CR?
             JNE     @REPEAT2        ;no, keep going
     ;until CR
             MOV     AX,BX           ;store number in AX
     ;if negative
             OR      CX,CX           ;negative number?
             JE      @EXIT           ;no, exit
     ;then
             NEG     AX              ;yes, negate
     ;end_if
     @EXIT:
             POP     DX              ;restore registers
             POP     CX                                      
             POP     BX
             RET                     ;and return

     ;here if illegal character entered
     @NOT_DIGIT:
             MOV     AH,2            ;go to a new line
             MOV     DL,0DH
             INT     21H
             MOV     DL,0AH
             INT     21H
             JMP     @BEGIN	     ;go to beginning		
     INDEC   ENDP

         END     start
