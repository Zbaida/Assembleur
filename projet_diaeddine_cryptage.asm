;Ce programme est un mini decrypteur qui demande a l'utlisateur de saisir la nature de
;decryptage ensuite entre la chaine de caractere  
;les types de decryptages demandes sur le menu sont 3 types anciennes :
;1) inverser la chaine de caractere 

;les 2options suivants fonctionnent seulement pour les caracteres minuscules 

;2) le code cesar, consiste a decaler chaque caractere de la chaine avec le decalage
;entre par l'utilisateur, si le resultat obtenu depasse z alors le nombre de decalage
; qui reste est ajoute a la lettre a , exemple a + 3 = d ; y + 3 = z + 2 = a + 1 =b 

;3)le code vigenere utilise une chaine de caractere et une cle, chaque lettre de la chaine
;on lui ajoute la lettre de la cle , meme maniere du code cesar si sa depasse z, si la
;chaine cle est arrive a la fin alors le caractere suivant sera le debut de la chaine cle


;mini projet cree par lyamani diaeddine , filiere bdcc , enset mohammedia

org 100h

jmp start

msg1 db 0dh, 0ah,0dh, 0ah,'ENSET Mohammedia',09h,09h,09h,09h,09h,'      Lyamani Diaeddine'
 db 0dh, 0ah,0dh, 0ah,0dh, 0ah, 09h,09h,09h,09h,'Mini projet BDCC'
 db 0dh, 0ah,0dh, 0ah,0dh, 0ah, 09h,'Bienvenue dans le crypteur de chaines'
 db 0dh, 0ah,09h
 db 'Veuillez choisir le type de cryptage parmi les 3 options suivantes:' 
 db 0dh, 0ah,09h,09h
 db '1- Inverser la chaine' 
 db 0dh, 0ah,09h,09h
 db '2- Code Cesar'          
 db 0dh, 0ah,09h,09h
 db '3- Chiffre de Vigenere'  
 db 0dh, 0ah,'$'

msg10 db 0dh, 0ah,'refaire ? (o/n): ','$'
msg11 db 0dh, 0ah,'veuiller entrer un chiffre valide :','$' 

msg12 db 0dh, 0ah,'entrez la chaine :',0dh, 0ah,'$'

msg13 db 0dh, 0ah,'entrez le decalage :',0dh, 0ah,'$'

retour db 0dh, 0ah, '$'  

msg14 db 0dh, 0ah,'entrez la cle :',0dh, 0ah,'$'  

decalage db 0 

cst db 10
cpt_cle db 0 
cpt_chaine dw 0


start:  

; Afficher message de bienvenue
mov dx,offset msg1
mov ah,9
int 21h 
 
; lire le choix, avec erreur si c'est pas ni 1 ni 2 ni 3
lire:
    
    mov ah, 1     
    int 21h
    
    a:
    cmp al,'1'
    jne b  
    mov dx,offset retour
    mov ah,9
    
    int 21h 
    call inverser
    jmp fin
    
    b:
    cmp al,'2'
    jne c
    call cesar
    jmp fin
    
    c:
    cmp al,'3'
    jne erreur
    call vigenere
    jmp fin
    
    erreur:
    mov dx,offset msg11
    mov ah,9

    int 21h
    jmp lire
    
    
; Message refaire
fin:
 
mov dx,offset msg10
mov ah,9
int 21h

    mov ah, 1     
    int 21h 
    
    
    cmp al,'o'
    je start 
    
    int 20h
    

ret




; procedure pour le fonction inverser la chaine

proc inverser
    

    mov dx,offset msg12
    mov ah,9
    int 21h    
     
    ;la chaine sera stocke dans le stack alors on initialise le si par l'adresse du debut
    ;de la chaine, on utlise cx en tant que compteur et ax pour deplacer les caracteres 
    
    mov si, sp    

    mov cx,0      
    
    mov ax,0

    ;boucle lire caractere , le mettre dans le stack, et incrementer compteur
    ;si le caractere est "entrer" alors on passe vers suiv: ; si le caractere est 
    ;"effacer" (8) alors on enleve le caractere stocke dans la stack , on decremente
    ;le compteur, on remplace le caractere dans l'ecran par espace ensuite on deplace
    ;le curseur avant, lire caractere tant que le caractere n'est pas entrer 
    
l:                ;lire
    mov ah, 1     
    int 21h
    
    cmp al,0dh    
    je suiv
    
    cmp al,8
    je si_retour 

    mov ah,0 
    push ax       ; stocker le caractere dans la pile
    
    add cx,2      
    jmp l
    jmp suiv
    
    
si_retour:        ; si l'utilisateur efface

    pop ax        
    sub cx,2 
    
    mov ah,0ah
    mov al,20h
    mov bl,0
    int 10h  
            
       
       
    jmp l
    
    
    ;l'etape apres la fin de la saisie, on pointe di sur l'adresse de la fin de la chaine
suiv:   
        
    mov di, si 
    sub di, cx 
    
     
    
    mov ah, 9
    mov dx, offset retour     ;; pour afficher le retour a la ligne
    int 21h 

    
    ;la boucle est pour afficher le contenu de la pile inversement en utilisant di, tant
    ;que le compteur n'est pas egale a 0 
boucle:
    mov bl,[di]      
    
    mov ah,2
    mov dl, bl
    int 21h          
    
    add di,2          
    sub cx,2
    cmp cx,0         
    jne boucle
    jmp fin 
    
endp



; Procedure pour le code cesar
proc cesar
    
    mov dx,offset msg12
    mov ah,9
    int 21h
    
    ;la chaine sera stocke dans le stack alors on initialise le si par l'adresse du debut
    ;de la chaine, on utlise cx en tant que compteur et ax pour deplacer les caracteres 
    ;et somme c'est la nombre de decalage fourni par l'utilisateur
    mov si, sp    
    mov cx,0      
    mov ax,0
    mov decalage,0  
    
    
    ;boucle lire caractere , le mettre dans le stack, et incrementer compteur
    ;si le caractere est "entrer" alors on passe vers suiv2: ; si le caractere est 
    ;"effacer" (8) alors on enleve le caractere stocke dans la stack , on decremente
    ;le compteur, on remplace le caractere dans l'ecran par espace ensuite on deplace
    ;le curseur avant, lire caractere tant que le caractere n'est pas entrer
    
    
l2:               ; lire caractere
    mov ah, 1     
    int 21h
    
    cmp al,0dh    
    je suiv2
    
    cmp al,8
    je si_retour2 

    mov ah,0 
    push ax       ; stocker le caractere dans la pile
    
    add cx,2      
    jmp l2
    jmp suiv2
    
    
si_retour2:       ; si l'utilisateur efface

    pop ax        
    sub cx,2 
    
    mov ah,0ah
    mov al,20h
    mov bl,0
    int 10h         
       
       
    jmp l2
    


suiv2:   
    
    mov ah, 9
    mov dx, offset retour     ; pour afficher le retour a la ligne
    int 21h
    
    mov dx,offset msg13
    mov ah,9
    int 21h  
    

    ; ensuite le programme demande a l'utilisateur de fournir le nombre de decalage
    ;le nombre entre doit etre positif, il peut bien aussi depasser 26
    ;d'abord le nombre est converti de l'ascii vers hexa avec le "and 00001111b" 
    ;qui donne le chiffre (entre 0 et 9) qui ressemble au caractere,
    ;on sauvegarde dans bl le contenu de al, puisque pour la premiere fois decalage=0
    ;on deplace decalage dans al et donc aucun effet de multiplier par 10 ce qui donne
    ;chiffre d'unite, et apres calcul on met le resultat de al dans decalage  
    
liredec:          ; lire nombre decalage
    
    
    mov ah, 1     
    int 21h 
    
    cmp al,0dh    ; si le caractere est retour ligne alors jump vers suivdec
    je suivdec 
    
    cmp al,8
    je si_retourdec
    
     
    ; convertir de asci en hexa
    mov bl, al
    mov al, decalage
    mul cst
    and bl, 00001111b
    add al, bl
    mov decalage, al  
    

    jmp liredec
    jmp suivdec
    
    
si_retourdec:        ; si l'utilisateur efface

    mov ah, 02h    
    mov dl, 20h   
    int 21h         
    mov dl, 08h   
    int 21h         
       
       
    jmp liredec
    
    
       
    ;L'etape apres la fin de la saisie du decalage
    ;tant que le cpt n'est pas 0 (fin chaine), on compare si le caractere est < a 'a'
    ;ou sup a 'z' , si oui on ne fait rien (jmp vers non_car) sinon on ajoute le caractere
    ;au decalage et si c'est superieur a z, ce qui reste du decalage on l'ajoute au 
    ;caractere avant 'a'  
       
suivdec:   


jump:
    cmp cx,0                
    je next
    mov al,[si-2]         ;al = contenu de si (caractere)
    
    
 
    cmp al,96
    jle non_car
    cmp al,123
    jge non_car
    
                            
    add al, decalage      ; ici l'ajout du decalage
    
    
grand:                    ; modulo 26
    cmp al,123            ; si al >=123 on fait 
    jnae non_car          ; jump if not above or equal
    
    mov bl,al             
    sub bl,122
    mov al,96                
    add al, bl              
    jmp grand             


    
   
non_car:                  ; afficher le caractere , inc si et dec cx
    
    mov ah,2
    mov dl, al
    int 21h  
    sub si,2
    sub cx,2
           
    jmp jump 
    
    
next: 
    jmp fin
    
endp


; Procedure pour le chiffre de vigenere
proc vigenere
    
    
    mov dx,offset msg12
    mov ah,9
    int 21h  
    
    
    ;On stocke la chaine et la cle dans le stack, le cle dans la fin de la chaine
    ;si pointera vers debut chaine, et y aura 2 compteurs un pour chaine l'autre pour cle 
    mov bp, sp
    mov si, sp    
    mov cx,0      
    mov ax,0
    mov cpt_chaine,0
    mov cpt_cle,0  
    
    
    ;lire la chaine et la mettre dans la pile, augmenter le cpt chaine et cx
    
l3:               ; lire caractere
    mov ah, 1     
    int 21h
    
    cmp al,0dh    
    je suiv3
    
    cmp al,8
    je si_retour3 

    mov ah,0 
    push ax       
    inc cpt_chaine
    add cx,2      
    jmp l3
    jmp suiv3
    
    
si_retour3:       ; si l'utilisateur efface

    pop ax        
    sub cx,2 
    dec cpt_chaine
    
    mov ah,0ah
    mov al,20h
    mov bl,0
    int 10h         
       
       
    jmp l3
    

    ; apres la saisie de la chaine, on pointe di vers sa fin, ou sera le debut de la 
    ;chaine cle, et on initialise ch par 0 pour mettre le cpt cle dedans
suiv3:   


    mov di, si
    sub di, cx
    sub di, 2
    
    mov ah, 9
    mov dx, offset retour     
    int 21h
    
    mov dx,offset msg14
    mov ah,9
    int 21h
    
    mov ch,0 
    

l4:               ; lire caractere
    mov ah, 1     
    int 21h
    
    cmp al,0dh    
    je suiv4
    
    cmp al,8
    je si_retour4 

    mov ah,0 
    push ax       
    inc cpt_cle
    inc ch

    jmp l4
    jmp suiv4
    
    
si_retour4:       ; si l'utilisateur efface

    pop ax        
    sub ch,2 
    dec cpt_cle
    
    mov ah,0ah
    mov al,20h
    mov bl,0
    int 10h         
       
       
    jmp l4 
    
    
    
    ;il ya 2 compteurs fixes et 2 dynamiques: cpt de chaine et cpt de cle
    ;les dynamiques sont utilises comme compteurs pour determiner la fin de la procedure
    ;ils son't stockes dans cl et ch (resp)
    ;le cpt chaine fixe qui est stocke dans cpt_chaine est utilise pour determiner
    ;l'adresse debut de di (debut de la cle) si on arrive a la fin de la cle, pour la 
    ;repeter
    ;le cpt cle est utiliser pour reintialiser le ch(compteur pour cle dynamique) a sa
    ;valeur pour completer le calcul 
    
    

suiv4:

    jump2:
    
    cmp cl,0
    je next4
    mov al,[si-2]          ;debut chaine
    
    cmp ch,0
    jne next3
    mov ch, cpt_cle
    mov di,bp               ;determiner debut chaine cle
    sub di, cpt_chaine
    sub di, cpt_chaine
    sub di, 2
    
    
    ;pour les 2 chaines , on doit verifier si ils sont entre a et z , pour ne rien faire
    

next3:
    
    cmp al,96
    jle non_car3
    cmp al,123
    jge non_car3  
    
    
    
    mov bl,[di]
    cmp bl,96
    jle non_car2
    cmp bl,123
    jge non_car2
    sub bl,61h
    
    
                            
    add al, bl
    
    
grand2:                    
    cmp al,123              
    jnae next2
    
    mov bl,al               
    sub bl,122
    mov al,96                
    add al, bl              
    jmp grand2
    jmp next2
    
    
non_car2:                  
    
    sub di,2
    sub ch,1
    jmp jump2
    
non_car3:
    mov ah,2
    mov dl, al
    int 21h  
    sub si,2
    sub cl,2
    jmp jump2  
    
    
next2:
    mov ah,2
    mov dl, al
    int 21h  
    sub si,2
    sub cl,2 
    sub di,2
    sub ch,1
    jmp jump2 
    
next4:    
    jmp fin  
    

endp


