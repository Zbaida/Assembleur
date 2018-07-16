
 You may customize this and other start-up templates; 
 The location of this template is c:\emu8086\inc\0_com_template.txt
org 100h
.data

matrice1 db 9 dup(?)
matrice2 db 9 dup(?)
matrice3 db 9 dup(0) 
i db 0
choix db 0
saute db 0 
j db 0
    k db 0
    row db 0
    col db 0
    xij db 0
.code

lea si,matrice1
lea di,matrice2
lea bp,matrice3 



sasir la matrice 1 
mov dl,179
mov ah,2
int 21h
boucle:
cmp i,9
jne repeter
jmp suite
repeter:
mov dl,9        ;;       ajouter 
mov ah,2        ;;        une 
int 21h         ;;     tabulation 

mov ah,1        ;;        lire
int 21h         ;;         un 
sub al,30h      ;;       nombre
mov [si],al     ;;   affecter le nombre saisie au tableau
inc si
inc i           ;; incrimenter le nombre pour tester qu'on saute la ligne
inc saute

cmp saute,3
jne s1
mov dl,9
mov ah,2
int 21h          ;;               code 
mov dl,179
mov ah,2
int 21h
mov dl,9
mov ah,2
int 21h
mov dl,13       ;;            de sauter 
mov ah,2
int 21h
mov dl,10
mov ah,2        ;;             la ligne
int 21h
mov saute,0
cmp i,9
je suite
mov dl,179
mov ah,2
int 21h
s1:
jmp boucle
suite: 

mov i,0 
mov saute,0
mov dl,13
mov ah,2
int 21h
mov dl,10
mov ah,2
int 21h
mov dl,179
mov ah,2
int 21h 
mov dl,9
mov ah,2
int 21h     
finveg


question
mov ah,1
int 21h
mov choix,al


sasir la matrice 2
boucle2:
cmp i,9
jne repeter2
jmp suite2
repeter2:
mov ah,1
int 21h  
sub al,30h
mov [di],al
inc di
inc i
inc saute
mov dl,9
mov ah,2
int 21h
voir si on a saisi 3 nombre pour retourner a la ligne
cmp saute,3
jne s2
mov dl,179
mov ah,2
int 21h
mov dl,13
mov ah,2
int 21h
mov dl,10
mov ah,2
int 21h
mov saute,0
cmp i,9
je suite2
mov dl,179
mov ah,2
int 21h
mov dl,9
mov ah,2
int 21h
s2:
jmp boucle2
suite2:
           
mov ah,1
int 21h
mov ah,0
cmp choix,02bh
je addi
cmp choix,02ah
je multiplication 

addition des deux matrices
  
 addi:
lea si,matrice1
lea di,matrice2
lea bp,matrice3 
mov i,0
addition:
cmp i,9
je  suite3
mov bl,[si]
mov [bp],bl
mov bl,[di]
add [bp],bl
inc si
inc di
inc bp
inc i
jmp addition
suite3:   
      
jmp affichage
 espace entre les matrices

multiplication:
  
    mov i,0       ;initialisation de i
    
    for1:cmp i,3  ;boucle for avec indice i
    jge fin       ;condition de validite
    
    
    mov j,0       ;initialisation de j
    for2:cmp j,3  ;boucle for 2
    jge finfor2
    
    mov k,0       ;initialisation de k
    for3:cmp k,3  ;boucle for 3
    jge finfor3 
    
    lea di,matrice2  ;pointer sur la matrice 1 avec di 
    mov cx,0
    mov cl,j         ;j pour preciser quel ellement de de quel colone
    add di,cx
    
    mov al,k         ;k pour determiner quel ligne
                      on utilisant la formule suivante DI + 3*k +j exemple 3*0 +0
    mov bl,3
    mul bl     
    mov bh,0 
    
    add di,ax        ;deplacer le pointeur
    
    mov al,[di]      ;la valeur de l'element
    mov col,al       ;mettre dans variable col
    
    lea di,matrice1  ;pointer sur DI
    mov cx,0   
    mov cl,k         ;preciser quel element de la ligne
    add di,cx
    
    mov al,i         ;preciser la ligne
    mov bl,3         ;on utilisant la regle suivante DI + 3*i +k
    mul bl
    add di,ax
    mov al,[di]      ;mettre la valeur dans variable row
    mov row,al
    mov bl,col    
    mul bl
    
    add xij,al       ;additionner les deux termes 
        
         
    inc k
    jmp for3         
    finfor3: 
    
    mov al,xij       ;apres l'addition de tous les termes la mettre dans
    mov [bp],al      ;matrice3 pointe par si
    
    
    mov xij,0       ;mettre xij a 0 pour calculer le prochaine terme
    inc bp
    
       
    inc j       
    jmp for2     
    finfor2:
    
    mov ah,2
    mov dl,0Dh
    int 21h
    mov dl,0Ah
    int 21h
              
    inc i
    jmp for1 
    
    
    
    fin: ;Merci pour votre attention 
    
    jmp affichage







affichage:
mov dl,13
mov ah,2
int 21h
mov dl,10
mov ah,2
int 21h
mov dl,179
mov ah,2
int 21h 
mov dl,9
mov ah,2
int 21h

affichage de la matrice resultat 

mov i,0  
mov saute,0
lea bp,matrice3 
affichageresultat:
mov al,[bp]
    aam
    add ax, 3030h
    push ax
    mov dl, ah
    mov ah, 02h
    int 21h
    pop dx
    mov ah, 02h
    int 21h


mov dl,9
int 21h
inc i
inc saute
cmp saute,3
jne nonsaute
mov dl,179
mov ah,2
int 21h
mov ah,2
mov dl,10
int 21h
mov dl,13
int 21h
mov saute,0 
cmp i,9
je finprogramme 
mov dl,179
mov ah,2
int 21h
mov dl,9
mov ah,2
int 21h
nonsaute:
inc bp
cmp i,9
jne affichageresultat
finprogramme:

ret
