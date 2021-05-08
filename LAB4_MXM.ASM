DATA SEGMENT
    R1 DW 03H 
    C1 DW 02H
    C2 DW 03H

    MA DB 01H,02H
       DB 03H,04H 
       DB 05H,06H 
    MB DB 01H,02H,03H
       DB 04H,05H,06H
    MC DB 9 DUP(?)                       
DATA ENDS

CODE SEGMENT
    ASSUME DS:DATA , CS:CODE  
    START: 
	MOV AX , DATA
	MOV DS , AX

	MOV AX , AX
	MOV BP , 0H 
	MOV DI , 0H
	MOV SI , 0H
	MOV CX , R1		
	MOV DH , 0H 

	FOR1: 
    	PUSH CX 
    	MOV CX,C2
    	FOR2:
    		PUSH CX
    		MOV CX,C1 
    		FOR3: 
        		MOV AL,MA[SI] 
        		IMUL MB[DI] 
        		ADD DH,AL
			    INC SI		    
        		ADD DI,C2     
        		LOOP FOR3 

		        POP CX
    		MOV MC[BP],DH     	
    		MOV DH,0H
    		INC BP
    		SUB SI,C1	
    		SUB DI,5H		
    		LOOP FOR2
    
    	POP CX
    	ADD SI , C1        
    	MOV DI , 0H			
    	LOOP FOR1 
    
INT 3
CODE ENDS
END START