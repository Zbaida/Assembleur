; -------------------Dessiner avec la souris -----------------
; Appuyez sur le bouton gauche de la souris pour commencer a dessiner

org 100h
jmp start

oldX dw -1  ; definir un variable: coordonne X
oldY dw 0   ; definir un variable: coordonne Y

start:

;--Preparation de la fenetre

mov ah, 00
mov al, 13h       ; definir la fenetre de dessin
int 10h

;----   


main_dessin: ; fonction de dessin, 
;--Attendre que le bouton soit pressé.
mov ax, 3    ; 
int 33h      ; verifier la souris 

shr cx, 1    ; regler le probleme des coordonnees de la souris dans la fenetre de dessin     
cmp bx, 1    ; lorsqu'on clique sur la souris ==> bx=1 sinon reste a 0 
jne xor_cursor: ;

mov al, 1010b   ; definir la couleur du pixelle 
jmp dessiner_pixel 

xor_cursor:     ; verifie le mouvement de la souris  
cmp oldX, -1    ; Si il y a un mouvement oldX != -1
je pixel_non_requis ; non deplacement de la souris
push cx      ; sauvegarder dans le registre la valeur cx
push dx      ; sauvegarder dans le registre la valeur dx
mov cx, oldX  ;mettre le nouveau coordonnee de x dans cx
mov dx, oldY   ;mettre le nouveau coordonnee de y dans dx
mov ah, 0dh     ; obtenir les coordonnees X et Y du pixel.
int 10h
xor al, 1111b   ; definir la couleur de pixelle 
mov ah, 0ch     ; couleur de pixel  
int 10h
pop dx          ; Recuperation du premier resultat dans le registre dx
pop cx          ; Recuperation du premier resultat dans le registre cx
;--pixel actuel
pixel_non_requis:   
mov ah, 0dh     ;                                                                                            
int 10h
xor al, 1111b   ; 
mov oldX, cx
mov oldY, dx  


;--Dessiner le pixel (colorier)
dessiner_pixel:
mov ah, 0ch     
int 10h

;--Verification de la fin du programme
Verifier_Echap_boutton:  ; fin du programme si le bouton presse est Echap
mov dl, 255
mov ah, 6
int 21h
cmp al, 27               ; 27 represente Echap
jne main_dessin          ; si le bouton n est pas Echap continuer le dessin 


;--Fin du programme:
; Fermer la fenetre de dessin et retour au mode normal :
mov ax, 3 
int 10h     
mov ah, 1
mov ch, 0
mov cl, 8
int 10h
mov dx, offset msg
mov ah, 9
int 21h
mov ah, 0
int 16h
ret
msg db "fin du programme   $"
