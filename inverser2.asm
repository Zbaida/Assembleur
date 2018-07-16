; l'idee de cet algorithme est d'inverser une chaine de caractere
;d'abord l'utiliseur entre un caractere et le mp le stocke dans la stack 
;ensuite en connaissant l'adresse debut et fin de la chaine (si, di) situe dans le stack
;le mp prend caractere par caractere depuis l'adresse de di pour afficher la chaine inverse  


; par lyamani diaeddine (dommage ca a l'air de petite taille )


name "inverser chaine"

org 100h                ; debuter de l'adresse 100h
jmp start

retour db 0dh, 0ah, '$'   ; declarer le retour a la ligne

start:

        
    mov si, sp    ; adresse de debut de la chaine

    mov cx,0      ; compteur de caracteres
    
    mov ax,0

    
    
lire:
    cmp al,0dh    ; si le caractere est retour ligne alors jump vers suiv
    je suiv
    
    mov ah, 1     ; lire caractere
    int 21h
    
    cmp al,8
    je si_retour 

    mov ah,0 
    push ax       ; stocker le caractere dans la pile
    
    add cx,2      ; puisque on stock sur 16 bits , la difference entre 2 adresses sera 2
    jmp lire
    jmp suiv
    
    
si_retour:        ; si l'utilisateur efface

    pop ax        ; passer a l'adresse precedente du stack
    sub cx,2 
    
    mov ah, 02h   ; pour afficher le caractere 
    mov dl, 20h   ; remplacer le caractere par espace 
    int 21h         
    mov dl, 08h   ; retour pour deplacer le curseur avant
    int 21h         
       
       
    jmp lire    

suiv:             ;; determiner l'adresse de fin de la chaine dans la pile
    mov di, si
    sub cx,2
    sub di, cx 
    
     
    
    mov ah, 9
    mov dx, offset retour     ;; pour afficher le retour a la ligne
    int 21h 

    
boucle:
    mov bl,[di]      ; le contenu de la case ou dl pointe sera dans bl
    
    mov ah,2
    mov dl, bl
    int 21h          ; afficher le caractere
    
    add di,2         ; augmenter le pointeur de 2 , diminuer cpt de 2 
    sub cx,2
    cmp cx,0         
    jne boucle       
    

 
        