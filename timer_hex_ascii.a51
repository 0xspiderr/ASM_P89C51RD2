N_OMPS EQU 0E0h
N_OMS EQU 0B1h
CC_TMOD EQU 01h ; comanda TMOD pt timer 0, mod de functionare 1

ORG 0000h
	LJMP MAIN

; adresa rutinei de tratare a intreruperii pt timer 0
ORG 000Bh
	CLR TCON.4 ; oprire timer 0
	MOV TL0, #N_OMPS
	MOV TH0, #N_OMS
	SETB TCON.4
	
	MOV A, P1 ; citirea valorii de la portul 1
	PUSH ACC
	
	SWAP A ; interschimbarea primilor 4 biti
	ACALL CONV_HEX ; convertire din hex in ascii
	MOV DPTR, #1000h
	MOVX @DPTR, A
	
	POP ACC
	ACALL CONV_HEX;
	INC DPTR
	MOVX @DPTR, A
	
	RETI
	
CONV_HEX:
	ANL A, #0Fh ; izolarea byte-ului inferior prin AND logic
	CJNE A, #0Ah, VERIF ; comparare daca e < 10 sau mai mare ca 10

VERIF:
	JC CIFRA; daca bitul de carry e setat pe 1 inseamna ca avem o cifra 0-9
	ADD A, #37h ; daca A >= 10 adaug 37h pentru litere
	RET

CIFRA:
	ADD A, #30h ; DACA A < 10 adaug 30h pt cifre
	RET

MAIN:
	CLR IE.7
	MOV TMOD, #CC_TMOD ; setarea modului de lucru
	MOV TL0, #N_OMPS
	MOV TH0, #N_OMS
	SETB IE.1 ; validarea intreruperii timer 0
	SETB TCON.4 ; pornire timer 0
	SETB IE.7
	
	SJMP $
END