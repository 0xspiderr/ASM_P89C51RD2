ORG 0000h
    LJMP MAIN

ORG 0100h
MAIN:
    MOV TMOD, #09h ; configurarea timer-ului 0 pe modul 1

    MOV TH0, #00h       
    MOV TL0, #00h
	
WAIT_ZERO:
    JB P3.2, WAIT_ZERO  ; Daca pinul e deja 1, asteptam sa fie 0
	
WAIT_ONE:
    JNB P3.2, WAIT_ONE  ; asteptam pana cand pinul devine 1 (inceputul lui T)
    SETB TCON.4 ; pornire timer 0
	
WAIT_END:
    JB P3.2, WAIT_END   ; asteptare front cazator
    CLR TCON.4          ; oprire timer

	
    MOV DPTR, #1000h
    MOV A, TH0          
    MOVX @DPTR, A       
    INC DPTR
    MOV A, TL0          
    MOVX @DPTR, A

    SJMP $
END