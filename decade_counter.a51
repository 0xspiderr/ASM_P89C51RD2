SEG_LOW EQU 1000h
SEG_HIGH EQU 1001h
CIRC_U9 EQU 1002h

ORG 0000h
LJMP MAIN

; adresa rutinei de tratare a intreruperii INT0
ORG 0003h
	PUSH ACC
	
	MOV A, P1 ; citesc valorile noi de la comutatoare
	MOV R2, A
	MOV DPTR, #CIRC_U9
	MOVX @DPTR, A ; suprascriu valoarea noua citita in circuitul U9
	
	MOV A, R2
	ANL A, #0Fh ; izolez byte-ul inferior(din SW1) in acumulator prin AND logic
	ACALL GET_7SEG ; apelez subrutina pentru conversia din BCD in cod 7 segmente
	MOV DPTR, #SEG_LOW
	MOVX @DPTR, A ; trimit valoarea la segementul inferior
	
	
	MOV A, R2
	SWAP A ; schimb ordinea primilor 4 biti superiori cu cei 4 biti inferiori
	ANL A, #0Fh
	ACALL GET_7SEG
	MOV DPTR, #SEG_HIGH
	MOVX @DPTR, A
	
	POP ACC
	RETI

; subrutina pentru a converti valoarea bcd la cod 7 segmente
GET_7SEG:
    INC A; Ajustare pentru MOVC (A incepe de la 0)
	; daca nu incrementam A si cifra de convertit era 0 atunci instructiunea MOVC ar fi indicat spre
	; instructiunea RET ci nu spre primul octet din tabela
    MOVC A, @A+PC
    RET
    DB 3Fh, 06h, 5Bh, 4Fh, 66h, 6Dh, 7Dh, 07h, 7Fh, 6Fh

MAIN:
	CLR IE.7	; dezactivarea globala a sist. de intreruperi
	SETB IE.0	; validarea cererii de intrerupere externa INT0
	SETB TCON.0 ; /INT0 activa pe front negativ
	SETB IE.7
	MOV A, P1	; citesc valorile de la portul 1 unde sunt comutatoarele conectate
	MOV DPTR, #CIRC_U9
	MOVX @DPTR, A ; stochez valoarea citita de la comutatoare in circuitul U9
	
	SJMP $
END