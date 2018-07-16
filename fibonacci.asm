;******************************************
;*Aim of this code to generate a Fibonacci* 
;*Sequence up to n numbers.               *
;*Author : Sardor                         * 
;*IDE    : emu8086                        *
;******************************************
name "fibonacci Series"
.model small

.data

    tittle db 0ah,"Fibonacci Series", 0ah,0dh,"$"
    line   db     " -------- ---------", 0ah,0ah,0dh,"$"
    message1 db "veuillez entrer the target number: ", "$"
    message2 db 0ah,0ah,0dh,"Enter any key to continue: ", "$"
    can db 5 dup (?)
    term dw 0 
    term1 dw 0
    term2 dw 1
    term3 dw 0 
    fact dw 1
    sum dw 0
    fil db 06
    col db 18h
    mit db 0
    num db 9 
    .code
otra: 
 mov fil,06 ;la position : 6eme ligne
 mov col,18h ;la position : 24eme column
 mov mit,0;;
 mov ax,0;charger le tout par 0 
 mov bx,0
 mov dx,0
 mov fact,1
 mov sum,0 
 mov term,0 
 mov term1,0;
 mov term2,1
 mov term3,0 
 call clean;
 mov ax,@data
 mov ds,ax
 mov dx,offset tittle
 mov ah,09 ;affichage de titre
 int 21h

 mov dx,offset message1
 int 21h

 mov dx,offset can
 mov si,dx
 mov byte ptr[si],5 ;Stocker une valeur de taille 5 byte dans l'emplacement de mémoire indiqué par SI
 mov ah,0ah
 int 21h   
 mov ah,02;sauter une ligne
 mov dl,0ah
 int 21h
 int 21h
 mov dl,0dh;retourner
 int 21h            
 mov ch,0h;
 mov cl,byte ptr[si+1] ;charger dans cl la taille d'octet(nb d'octet) du valeur dans l'entree standard  (le nombre de chiffre ecrit dans l'ES  )
 add si,cx;   (ajouter le nombre d'octet a SI)
 mov bx,0ah; 
             
             
             
 ;cette boucle loop pour avoir le nombre entree au clavier par l'utilisateur sous forme:
 ; (chiffre des unites *1 + chiffre des Des dizaines*10 + ....)           
             
loop1:
mov al,[si+1]; charger dans al l'octet dans l'emplacement de memoire indiquer par SI (le dernier chiffre ecrit dans l'ES sous forme 30+chiffre en hexa)  
and ax,0fh     ; faire le et logique avec 0x0f  pour charger dans ax les 4 bits de poids faible (on est interesse juste par le 4 premiers bit)
mul fact       ; on multiple le contenu de ax par fact
add sum,ax
mov ax,fact
mul bx        ;mul ax par bx (qui est inisialise par 10)
mov fact,ax    ;charger dans fact sa nouvelle valeur ax(il va se multiplier a chaque iteration par 10)
dec si
               ;tourner la boucle jusqu'au le nombre de chiffre entree au clavier egale 0 (valeur de cx=0)
loop loop1

    ; sum c'est le nombre entrer au clavier en hexadecimal 

 mov ax,sum;on a le sum en hexadecimal
 mov bl,2;diviser par 2
 div bl
 mov mit,al; charger mit par le quotion 
 add mit,1;ajouter 1
 call locate;faire appelle a la fonction de positionnement

 mov ax,term1   ; term1 initilalise par 0
 mov bx,term2    ; term2 initilalise par 1
 mov dx,term3     ; term3 initilalise par 0

while: 

mov cx,sum;charger sum dans cx
add ax,bx; ajouter bx a ax
mov term,ax;
mov bx,dx
mov dx,ax; 

mov term1,ax
mov term2,bx
mov term3,dx

cmp mit,cl;comparison si le prmiere colone est rempli
jz movement;si sont egale il va au mouvement sinon salto

salto:

call decimal;convertir la valeur a afficher de la suite en decimal

inc fil
call locate

mov ax,term1   ;recharger ax,bx,dx par les valeurs de term1,term2,term3
mov bx,term2
mov dx,term3

cmp sum,01    ;comparer sum avec 01 pour verifier qu'on a pas atteint la limite de valeurs a afficher de la suite
jz sigue   
dec sum      ;decrementer la valeur de sum
jmp while  ;boucler a while

movement:  

add col,18h
mov fil,05
jmp salto   

sigue:

mov dx,offset message2
mov ah,09
int 21h
mov ah,01
int 21h

cmp al,"n"
jz finish
jmp otra

finish:
mov ah,4ch
int 21h 

locate proc near

mov ah,02
mov bh,00
mov dh,fil
mov dl,col
int 10h

ret

locate endp 

decimal proc near

lea si,num+5
mov cx,0ah    ;charger cx par 10
mov bx,5      ;charger bx par 5  

vuelta:
cmp ax,cx;comparer la valeur de ax afficher avec 10 s'il est inferieur donc c pas la peine de la convertir (jmp vers menor)
jb menor
xor dx,dx
div cx;
add dl,30h;sum of 30
mov byte ptr[si],dl;placer dans le dernier nombre
dec si;decrementer
dec bx
      ;diminuer quand ya pas moins que le nombre donnee 
jmp vuelta 
    menor:
add al,30h
mov byte ptr[si],al
mov byte ptr[si+6],"$";placer $ a la fin
mov ah,09          ;afficher dans la sortie standard la valeur de al
lea dx,num+bx;ajouter bx
int 21h

ret

decimal endp

clean proc near

mov ah,06h   ; passer au debut 
mov al,0     ; de l'ecran
mov cx,0     ; ligne ch=0, column cl=0
mov dx,184fh ; 
mov bh,07h   ; 
int 10h         
mov ah,02    ; place le curseur 
mov dx,0     ; au debut
mov bh,0     ; nouvelle fenetre 
int 10h 
ret

