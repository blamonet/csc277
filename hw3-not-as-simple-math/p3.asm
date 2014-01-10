; Aaron Grant
; CSC 277
; Assignment 3 - Using Mul and Div to compute change totals

.MODEL SMALL
.STACK 100H

.DATA
Qs      DB      0
Dimes   DB      0
Ns      DB      0
Ps      DB      0
coins   DB      0
total   DB      0
coins2  DB      0
divv    DB      0
MSG1    DB      '. Total amount of change is $'
MSG2    DB      'The number of input coins is $'
MSG3    DB      10,13,'Quarter = $'
MSG4    DB      10,13,'Dimes = $'
MSG5    DB      10,13,'Nickles = $'
MSG6    DB      10,13,'Pennies = $'
MSG7    DB      10,13,'Total Coins = $'
crlf    DB      10,13,'$'


.CODE
main proc
;initialize DS
        MOV AX, @DATA
        MOV DS, AX

;quarter
        call  input_char
        mov   Qs,al 
        add   coins,al
        mov   bl,25
        mul   bl
        add   total,al

;dimes
        call  input_char
        mov   Dimes,al 
        add   coins,al
        mov   al,Dimes
        mov   bl,10
        mul   bl
        add   total,al

;nickles
        call  input_char
        mov   Ns,al 
        add   coins,al
        mov   al,Ns
        mov   bl,5
        mul   bl
        add   total,al

;pennies
        call  input_char
        mov   Ps,al 
        add   coins,al
        add   total,al

;print total coins
        mov   dx,offset crlf
        call  PrintString
        mov   dx,offset msg2
        mov   al,coins
        call  PrintString
        Call  Outdec

;print total value
        mov   dx,offset msg1
        mov   al,total
        call  PrintString
        Call  Outdec

;new coin configuration
        mov   al, total
        mov   bl, 25
        div   bl
        mov   total,ah
        add   coins2,al
        mov   divv,al
        mov   ax,0
        mov   dx,offset msg3
        mov   al,divv
        call  PrintString
        Call  Outdec

        mov   al, total
        mov   bl, 10
        div   bl
        mov   total,ah
        add   coins2,al
        mov   divv,al
        mov   ax,0
        mov   dx,offset msg4
        mov   al,divv
        call  PrintString
        Call  Outdec

        mov   al, total
        mov   bl, 5
        div   bl
        mov   total,ah
        add   coins2,al
        mov   divv,al
        mov   ax,0
        mov   dx,offset msg5
        mov   al,divv
        call  PrintString
        Call  Outdec

        mov   al, total
        mov   bl, 1
        div   bl
        mov   total,ah
        add   coins2,al
        mov   divv,al
        mov   ax,0
        mov   dx,offset msg6
        mov   al,divv
        call  PrintString
        Call  Outdec

        mov   dx,offset msg7
        mov   al,coins2
        call  PrintString
        Call  Outdec

;exit to DOS
    mov     ax,4c00h    ;Returns control to DOS
    int     21h         ;MUST be here! Program will crash without it!

main endp

PrintString  proc
    push  ax      ; save register modified
    mov   ah,9
    int   21h
    pop   ax
    ret
PrintString endp

input_char proc
     ;reads a number in range -32768 to 32767
     ;input: none
     ;output: AX = binary equivalent of number
             PUSH    BX              ;save registers used            
             PUSH    CX      
             PUSH    DX
     ;print prompt
     @BEGIN:
             MOV     AH,2
             MOV     DL,'?'
             INT     21H             ;print '?'
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
input_char endp

OUTDEC  PROC

    ;prints AX as a signed decimal integer
    ;input: AX
    ;output: none
            PUSH    AX              ;save registers
            PUSH    BX
            PUSH    CX
            PUSH    DX              
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

    END  main
