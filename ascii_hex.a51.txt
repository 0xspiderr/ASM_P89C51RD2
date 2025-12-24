ORG 1000h         

MAIN:
    MOV DPTR, #1000h 
    MOVX A, @DPTR       
    CLR C              
    SUBB A, #30h        
    CJNE A, #0Ah, CHECK_NUM_OR_LETTER
	
CHECK_NUM_OR_LETTER:
    JC STORE_RESULT     
    SUBB A, #07h        

STORE_RESULT:
    MOV DPTR, #1001h    
    MOVX @DPTR, A       

    SJMP $              
END
