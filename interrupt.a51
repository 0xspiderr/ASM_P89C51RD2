ORG 0000h
LJMP MAIN

; adresa de start a rutinei de tratare a intreruperii INT0
ORG 0003h
	PUSH ACC
	MOV DPTR, #1000h
	MOVX A, @DPTR
	ADD A, #01h
	DA A ; ajustez valoarea acumulatorului sa corespunda la BCD
	MOVX @DPTR, A
	
	JNC DONE_LOW ; daca bitul de carry nu e setat, rutina de tratare a intreruperii e gata
	
	INC DPTR ; daca bitul de carry e setat atunci trec la octetul superior
	MOVX A, @DPTR
	ADDC A, #00h ; adun carry-ul
	DA A
	
	JNC DONE_HIGH ; daca bitul de carry nu e setat pentru byte-ul superior, rutina e gata
	
	; resetare daca este overflow(s-a depasit 9999)
	MOV A, #00h
	MOVX @DPTR, A
	MOV DPTR, #1000h
	MOVX @DPTR, A
	
	POP ACC
	RETI
	
	
; adresa de start a rutinei de tratare a intreruperii INT1
ORG 0013h
	; resetarea valorilor de la adresele de memorie 1000h si 1001h
	PUSH ACC
	MOV A, #00h
	MOV DPTR, #1000h
	MOVX @DPTR, A
	INC DPTR
	MOVX @DPTR, A
	POP ACC
	RETI

DONE_LOW:
	POP ACC
	RETI

DONE_HIGH:
	MOVX @DPTR, A
	POP ACC
	RETI

MAIN:
	CLR IE.7	; dezactivarea globala a sist. de intreruperi
	SETB IE.0	; validarea cererii de intrerupere externa INT0
	SETB TCON.0 ; /INT0 activa pe front negativ
	CLR IP.0 	; setare prioritate nivel 0
	SETB IE.2	; validarea cererii de intrerupere externa INT1
	SETB TCON.2 ; /INT1 activa pe front negativ
	SETB IP.2	; setare prioritate nivel 1(trebuie sa fie > decat prioritatea lui INT0)
	SETB IE.7	; reactivarea globala a sist. de intreruperi
	SJMP $		; bucla infinita pt a astepta intreruperile
END
