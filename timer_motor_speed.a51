Lab 3 pb3.
N_HIGH EQU 3Ch ; octetul high al constantei TH0 
N_LOW  EQU 0B0h ; octetul low al constantei TL0

ORG 0000h
    LJMP MAIN

ORG 0100h
MAIN:
    CLR EA ; dezactivare globala intreruperi pentru configurare
    MOV TMOD, #51h ; setarea timer 1 mod 1 si timer 0 mod 1

    MOV TH1, #00h
    MOV TL1, #00h

    MOV TH0, #N_HIGH
    MOV TL0, #N_LOW

    SETB TCON.6 ; pornire numarare impulsuri de la motor T1/P3.5
    SETB TCON.4 ; pornire fereastra de timp de 50ms

WAIT_GATE:
    JNB TCON.5, WAIT_GATE ; asteapta pana cand TF0 devine 1

    ; oprirea numaratorilor
    CLR TCON.4 ; oprire temporizator
    CLR TCON.5 ; oprire numarator impulsuri motor
    CLR TCON.6 ; resetare fanion depasire 

    MOV DPTR, #1000h ; incarcare adresa destinatie conform cerintei 
    MOV A, TH1       
    MOVX @DPTR, A    
    
    INC DPTR         
    MOV A, TL1 
    MOVX @DPTR, A 

    SJMP $ 
END