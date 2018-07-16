.MODEL SMALL
.STACK 100H

.DATA    

MSG1 DB '                .....BIENVENUE.....$'                            ;
MSG2 DB 'Les Regles : $'                                                  ;
MSG3 DB '*. Pour chaque reponse juste vous gagnez 1 point.$'              ;
MSG4 DB '*. Pour chaque reponse juste vous perdez 1 point.$'              ;
MSG5 DB 'Qliquez sur Entrer pour commencer le quiz : $'                   ;
MSG6 DB 'Reponse Juste....$'                                              ;
MSG7 DB 'Reponse Fausse....$'                                             ;
MSG8 DB 'Vous avez bien termine votre Quiz.$'                             ;
MSG9 DB 'Votre nombre total de point est : $'                             ;
MSG10 DB 'Cliquez sur 1 pour Recommencer le Quiz ou 0 pour Quitter.$'     ;
MSG11 DB '                    ***Merci! ***$'                             ;
Q1 DB '1. 2+3=?$'                                                         ;
QA1 DB '   a) 5    b) 6    c) 7$'                                         ;
Q2 DB '2. 5+6=?$'                                                         ;   -On declare des variable qui vont contenir les chaines de caracteres
QA2 DB '   a) 10    b) 11    c) 12$'                                      ;
Q3 DB '3. 15-12=?$'                                                       ;     que nous allons utiliser dans le quiz
QA3 DB '   a) 5    b) 1    c) 3$'                                         ;
Q4 DB '4. 3*6=?$'                                                         ;
QA4 DB '   a) 10    b) 18    c) 12$'                                      ;
Q5 DB '5. 6/3=?$'                                                         ;
QA5 DB '   a) 2    b) 1    c) 12$'                                        ;
Q6 DB '6. 8-8=?$'                                                         ;
QA6 DB '   a) -1    b) -2    c) 0$'                                       ;
Q7 DB '7. 3*12=?$'                                                        ;
QA7 DB '   a) 33    b) 36    c) 38$'                                      ;
Q8 DB '8. 9*9=?$'                                                         ;
QA8 DB '   a) 72    b) 91    c) 81$'                                      ;
Q9 DB '9. 11+13=?$'                                                       ;
QA9 DB '   a) 24    b) 26    c) 19$'                                      ;
Q10 DB '10. 56/8=?$'                                                      ;
QA10 DB '   a) 7    b) 9    c) 6$'                                        ;
.CODE
MAIN PROC 
    
    MOV AX,@DATA
	MOV DS,AX
    
	LEA DX,MSG1    ;
	MOV AH,9       ;  On afficher "BIENVENUE"
	INT 21H        ;
	
	CALL NL
    
	LEA DX,MSG2    ;
	MOV AH,9       ;  
	INT 21H        ;
                   ;
	CALL NL        ;
                   ;
	LEA DX,MSG3    ;
	MOV AH,9       ;  On affiche les regles du quiz.
	INT 21H        ;
                   ;
    CALL NL        ;
                   ;
	LEA DX,MSG4    ;
	MOV AH,9       ;  
	INT 21H        ;
	
	START:
	MOV BL, 0      ;  Le registre BL va contenir le score, donc on va l'initialiser a 0.
    CALL NL        ;
    
	LEA DX,MSG5    ;
	MOV AH,9       ;  On demande a l'utilisateur de tapez ENTRER pour commencer.
	INT 21H        ;
	
	
	MOV AH, 1      ;  On lit une valeur entree par le clavier
	INT 21H        ;
	
	CMP AL, 0DH    ;  
	JE QSN1        ;  Si l'utilisateur a tape ENTRER on passe a la question 1 "QSN1", sinon on lui demande de taper ENTRER a nouveau.
	JNE START      ;
	
	QSN1:          ;  Question 1 : 
	CALL NL        ;
                   ;
	LEA DX,Q1      ;     - On afficher la question 1.
	MOV AH,9       ;
	INT 21H        ;
	               ;
	CALL NL        ;
                   ;
	LEA DX,QA1     ;     -On afficher les choix de reponse de la question 1.
	MOV AH,9       ;
	INT 21H        ;
	               ;
	CALL NL        ;
                   ;
	MOV AH, 1      ;     -On lit une valeur saisie par le clavier.
	INT 21H        ;
	CMP AL, 'a'    ;
	JE QSN2        ;     -Si la valeur est egale a la reponse correcte en passe a "QSN2", si la reponse est fausse on passe a "QSNW2" 
    JNE QSNW2      ;
	
	
	
	
	
	QSN2:          ;    Question 2 (avec une reponse CORRECTE a la question precedente "1"):
	CALL NL        ;
                   ;
	LEA DX,MSG6    ;      -On afficher que la reponse a la question 1 est CORRECTE.
	MOV AH,9       ;
	INT 21H        ;
	               ;
	INC BL         ;      -On INCREMENTE le score par 1 point.
	CALL NL        ;
                   ;
	CALL QN2       ;      -On afficher la question 2 et les choix de reponse.
	               ;
	CALL INPUT     ;      -On lit une valeur saisie par le clavier.
	               ;
	CMP AL, 'b'    ;
	JE QSN3        ;      -Si la valeur est egale a la reponse correcte en passe a "QSN3", si la reponse est fausse on passe a "QSNW3"
	JNE QSNW3      ;
	 
	 
	 
	 
	QSNW2:         ;    Question 2 (avec une reponse FAUSSE a la question precedente "1"):
	CALL NL        ;
                   ;
	LEA DX,MSG7    ;      -On afficher que la reponse a la question 1 est FAUSSE.
	MOV AH,9       ;
	INT 21H        ;
	               ;
	DEC BL         ;      -On DECREMENTE le score par 1 point.
	CALL NL        ;
                   ;
	CALL QN2       ;      -On afficher la question 2 et les choix de reponse.
	CALL INPUT     ;      -On lit une valeur saisie par le clavier.
	               ;
	CMP AL, 'b'    ;
	JE QSN3        ;      -Si la valeur est egale a la reponse correcte en passe a "QSN3", si la reponse est fausse on passe a "QSNW3"
	JNE QSNW3      ;
	
	
	QSN3:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL    

    
	CALL QN3 
	CALL INPUT
	
	CMP AL, 'c'
	JE QSN4
	JNE QSNW4
	
	QSNW3:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN3
	CALL INPUT
	
	CMP AL, 'c'
	JE QSN4 
	JNE QSNW4
	
	QSN4:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN4 
	CALL INPUT
	
	CMP AL, 'b'
	JE QSN5
	JNE QSNW5
	
	QSNW4:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN4 
	CALL INPUT
	
	CMP AL, 'b'
	JE QSN5 
	JNE QSNW5
	
	QSN5:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN5 
	
	CALL INPUT
	
	CMP AL, 'a'
	JE QSN6
	JNE QSNW6
	
	QSNW5:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN5 
	CALL INPUT
	
	CMP AL, 'a'
	JE QSN6 
	JNE QSNW6
	
	QSN6:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN6 
	
	CALL INPUT
	
	CMP AL, 'c'
	JE QSN7
	JNE QSNW7
	
	QSNW6:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN6 
	CALL INPUT
	
	CMP AL, 'c'
	JE QSN7 
	JNE QSNW7
	
	QSN7:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN7
	CALL INPUT
	
	CMP AL, 'b'
	JE QSN8
	JNE QSNW8
	
	QSNW7:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN7 
	CALL INPUT
	
	CMP AL, 'b'
	JE QSN8 
	JNE QSNW8
	
	QSN8:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN8 
	CALL INPUT
	
	CMP AL, 'c'
	JE QSN9
	JNE QSNW9
	
	QSNW8:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN8 
	CALL INPUT
	
	CMP AL, 'c'
	JE QSN9 
	JNE QSNW9
	
	QSN9:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN9 
	CALL INPUT
	
	CMP AL, 'a'
	JE QSN10
	JNE QSNW10
	
	QSNW9:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN9 
	CALL INPUT
	
	CMP AL, 'a'
	JE QSN10 
	JNE QSNW10
	
	QSN10:
	CALL NL
    
	LEA DX,MSG6
	MOV AH,9
	INT 21H
	
	INC BL
	CALL NL
    
	CALL QN10 
	CALL INPUT
	
	CMP AL, 'a'
	JE EXIT
	JNE EXITW
	
	QSNW10:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
    
	CALL QN10 
	CALL INPUT
	
	CMP AL, 'a'
	JE EXIT 
	JNE EXITW
	
	EXIT:
	CALL NL 
    
	LEA DX,MSG6     
	MOV AH,9        
	INT 21H        
	
	INC BL
	CALL NL
	CALL NL
    
	LEA DX,MSG8
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,MSG9
	MOV AH,9
	INT 21H
	
    MOV BH,00
    CMP BX,0F6h     ;pour comparer avec -10 en fait un complement a 2
    JL CONTINUE     ;si BL est inferieur a (-10)ca2 = F6
    NOT BL          ;donc BL est entre 0 et 10 (positive) alors
    INC BL          ;on saute a continue pour traiter les nombre positifs
    JMP NEGATIVE    ;sinon on saute au traitement des negatifs
	
	CONTINUE:       ;traiter le score positif
	ADD BL, 48      ;on ajoute 48 pour convertir du ASCII au decimal
	
	CMP BL,57       ;comparer avec 9 pour traiter le 10 en autre maniere
	JG TEN          ;on saute a la fonction qui traite le 10
	MOV AH, 2
	MOV DL, BL
	INT 21H
	JMP EXIT1
	
	NEGATIVE:       ;traitement des nombres negatifs
	ADD BL, 48      ;convertion du ASCII au decimal
	
	MOV AH,2
	MOV DL,"-"
	INT 21H
	
	CMP BL,57       ;comme on a vu c'est pour traiter le -10 
	JG TEN
	
	MOV AH, 2
	MOV DL, BL
	INT 21H
	JMP EXIT1
	
	EXITW:
	CALL NL
    
	LEA DX,MSG7
	MOV AH,9
	INT 21H
	
	DEC BL
	CALL NL
	CALL NL  

    
	LEA DX,MSG8
	MOV AH,9
	INT 21H 
	
	CALL NL
    CALL NL
    
	LEA DX,MSG9
	MOV AH,9
	INT 21H
	
	MOV BH,00       
    CMP BX,0F6h
    JL CONTINUEW    ;c'est la meme chose comme CONTINUE
    NOT BL
    INC BL
    JMP NEGATIVE
	
	CONTINUEW:	
	ADD BL,48
	MOV AH,2
	MOV DL, BL
	INT 21H
	
	JMP EXIT1
	
	TEN:            ;
	MOV AH,2        ;
	MOV DL,"1"      ;
	INT 21H         ;  -Procedure qui permet d'afficher 10 : concatenation de 1 et 0
	MOV DL,"0"      ;
	INT 21H         ;
	JMP EXIT1       ;
	
	NL:             ;
	MOV AH,2        ;
	MOV DL, 0AH     ;
	INT 21H         ;   -Procedure qui permet de faire un saut a la ligne.
    MOV DL, 0DH     ;
    INT 21H         ;
    RET             ;
    
    QN2:            ;
    LEA DX,Q2       ;
	MOV AH,9        ;
	INT 21H         ;
	                ;  -Procedure pour la question 2: permet d'afficher la question et les choix de reponse.
	CALL NL         ;
                    ;
	LEA DX,QA2      ;  NB: on va creer la meme procedure pour chaque question. 
	MOV AH,9        ;
	INT 21H         ;
	RET             ;
	
	QN3:
    LEA DX,Q3
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA3
	MOV AH,9
	INT 21H
	RET
	
	QN4:
    LEA DX,Q4
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA4
	MOV AH,9
	INT 21H
	RET
	
	QN5:
    LEA DX,Q5
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA5
	MOV AH,9
	INT 21H
	RET 
	
	QN6:
    LEA DX,Q6
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA6
	MOV AH,9
	INT 21H
	RET
	
	QN7:
    LEA DX,Q7
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA7
	MOV AH,9
	INT 21H
	RET 
	
	QN8:
    LEA DX,Q8
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA8
	MOV AH,9
	INT 21H
	RET  
	
	QN9:
    LEA DX,Q9
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA9
	MOV AH,9
	INT 21H
	RET 
	
	QN10:
    LEA DX,Q10
	MOV AH,9
	INT 21H
	
	CALL NL
    
	LEA DX,QA10
	MOV AH,9
	INT 21H
	RET  
	
	INPUT:            ;
	CALL NL           ;
                      ; -Procedure qui permet de lire une valeur entree par le clavier
	MOV AH, 1         ;
	INT 21H           ;
	RET               ;
	
	
	EXIT1:            ;
	CALL NL           ;
	CALL NL           ;
	                  ;
	LEA DX,MSG10      ; 
	MOV AH,9          ;  -On demande a l'utilisateur de taper 1 pour recommencer le Quiz ou 0 pour terminer.
	INT 21H           ;
	                  ;
	MOV AH,1          ;  -Input par clavier
	INT 21H           ;
	                  ;
	CMP AL,'1'        ;  -Si la valeur donnee par l'utilisateur est 1 on revient a START , si n'est pas egale a 0 on revient a EXIT1
	JE START          ;
    CMP AL,'0'        ;      pour que l'utilisateur donne 1 ou 0.
    JNE EXIT1         ;
	                  ;
	CALL NL           ;
	CALL NL           ;
	                  ;
	LEA DX,MSG11      ;  -Si on est arrive a cette etape, donc l'utilisateur a tape 0, on va afficher "Merci"
	MOV AH,9          ;
	INT 21H           ;
	                  ;
	MOV AH, 4CH       ;
	INT 21H           ;
	
	MAIN ENDP
END MAIN
