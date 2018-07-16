.MODEL SMALL
.STACK 100H
.DATA

M0 DB "             ***Additions sous assembleur***$"
M1 DB "Pour Addition,ecrire       :`1'$" 
M5 DB "Entrer 2 nombers pour Addition: $"
M9 DB "Choiser une option : $" 
M10 DB "Resultat en decimal est     : $"
M11 DB "                  ***Merci***$" 
M12 DB "Entrer une option valide : $"
M13 DB "Resultat en binaire est     : $" 
M16 DB "Pur une autre essaye entrer :`1'$"
M17 DB "Pour QUITTER, entrer  :`2'$"
M18 DB "Entrer non valide. $"

.CODE
MAIN PROC
    
    MOV AX,@DATA             ; initialisation des chaine des characteres
   
    MOV DS,AX
    
    LEA DX,M0               ; affichage de premiere chaine M0
    MOV AH,9
    INT 21H 
    
    START:
    
    CALL NL                          ; retourne a la ligne
    CALL NL
    
    LEA DX,M1                         ; affichage de deuxieme chaine M1
    MOV AH,9
    INT 21H
    
    CALL NL
    CALL NL  
    
    CALC:
    
    MOV AH,1
    INT 21H
    MOV BL,AL                        ;Si utilisateur entrer 1, aller a 'ADDD'
    
    CALL NL
    CALL NL
    
    
    CMP BL,'1'
    JE ADDD
    
    LEA DX,M12
    MOV AH,9
    INT 21H
    
    JMP CALC
 
    
    ADDD:
    
    LEA DX,M5
    MOV AH,9                    ; Affichage de chaine M5 
    INT 21H 
    
    MOV AH,1                    ; demander des valeur a l'utilisateur
    INT 21H
    MOV BL,AL
    
    MOV AH,2                     ; stockage de premiere valeur dans BL
    MOV DL,'+'
    INT 21H
           
    MOV AH,1       
    INT 21H                       ; stockage de deuxieme valeur dans CL
    MOV CL,AL
    
    ADD BL,CL
    MOV BH,BL                      ;Effectuer addition entre BL et CL, si resultat plus grand que 9 aller a I
    SUB BL,48
    CMP BL,'9'
    JG I
    
    CALL NL
    CALL NL
    
    CALL DR
    
    MOV AH,2                     ; affichage de resultat en decimal
    MOV DL,BL
    INT 21H
    
    CALL NL
    CALL BR  
    
    CALL NL                      ;affichage de resultat en benaire
    CALL NL
    
    LEA DX,M16
    MOV AH,9
    INT 21H
    CALL NL
    LEA DX,M17
    MOV AH,9
    INT 21H
    CALL NL
    LEA DX,M9
    MOV AH,9
    INT 21H
    
    MOV AH,1                       ; affichage des choix 
    INT 21H 
                                   ; si choix d;utilisateur est 1 essayer a nouveau 
                                   ;si choix d'utilisateur est 2 quitter
    MOV BL,AL
    CMP BL,'1'
    JE START
    
    CALL NL
    CALL NL
    
    CALL TNX
    
    JMP EXIT
    
    
    
    
    
   
    
    NL:
    MOV AH,2
    MOV DL,13                               ;fonction de retour a la ligne
    INT 21H
    MOV DL,10
    INT 21H
    RET
    
    TNX:
    
    LEA DX,M11
    MOV AH,9                                  ;affichage de chaine M11
    INT 21H
    RET 
    
    DR: 
    
    LEA DX,M10
    MOV AH,9                                   ;affichage de M10
    INT 21H
    
    RET 
    
    BR:
    
    LEA DX,M13
    MOV AH,9                                    ;affichage de M13
    INT 21H 
   
    SUB BL,48
    
    MOV CX,8
    TOP:
    SHL BL,1
    JC ONE 
    
    MOV AH,2                                  ;calcule de resultat binaire
    MOV DL,'0'
    INT 21H
    
    LOOP TOP
    JMP NEXT
    
    ONE:
    MOV AH,2
    MOV DL,'1'
    INT 21H
    
    LOOP TOP
    
    NEXT:
    
    RET
    
    
    
    I: 
    CALL NL
    CALL NL
    
    LEA DX,M18
    MOV AH,9
    INT 21H                              ;affichage de M18
    CALL NL
    
    JMP ADDD
    
    J: 
    CALL NL
    CALL NL
    
    LEA DX,M18
    MOV AH,9
    INT 21H
    CALL NL
    

    
    K: 
    CALL NL
    CALL NL
                                             ;affichage de M18
    LEA DX,M18
    MOV AH,9
    INT 21H 
    CALL NL
    
   
    
    L: 
    CALL NL
    CALL NL
    
    LEA DX,M18
    MOV AH,9                                 ;affichage de M18
    INT 21H
    CALL NL
    


    EXIT:
    MOV AH,4CH
    INT 21H
    
    MAIN ENDP
END MAIN