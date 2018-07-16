
org 100h

.data
;jmp start

msg1 db "Entrer un nombre etre 0 et 255 : $"
msg_erreur db "ERREUR !!! ENTRER UN NOMBRE ENTRE 0 ET 255 $"
msgretour db "voulez-vous continuer... (y/n)? : $"
num db 0h,0h,0h,'$' 
bin db 0h,0h,0h,0h,0h,0h,0h,0h,'$'
aa db 0,'$'
nl db 13,10,'$'
som db 0,'$'
som16b dw 0,'$' 

.code
;start:
program:

;;;;;; initialisation ;;;;;;;;;;;;;;;;;;;;;;
mov som, 0
mov som16b, 0
mov cx, 8
mov si, 0

setzero:
    mov bin[si], 0
    inc si
loop setzero
mov cx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

mov dx,offset nl
mov ah,9
int 21h

mov dx, offset msg1 ;afficher
mov ah, 09          ;le message 
int 21h             ;msg1
 
mov dx,offset nl    ;sauter
mov ah,9            ;une
int 21h             ;ligne

;mov dx,13
;mov ah,2
;int 21h
;mov dx,10
;mov ah,2
;int 21h

 mov cx, 0
numb:          ; cette boucle
               ; son but est de 
mov ah, 1      ; saisir le nombre
int 21h        ; caractere par 
mov si, cx     ; caractere
mov num[si],al ;
inc cx         ;
cmp cx,3       ;
jl numb        ;


mov dx,offset nl
mov ah,9
int 21h  
   
mov dx,offset num
mov ah, 09
int 21h


mov bx,100     ; converter le caractere           
mov al,num[0]  ; de centaine 
sub al,30h     ; a un nombre 
mov ah, 0      ; 
mul bx         ; multiplier par 100
add som,al     ; et ajoute le nombre a la somme
add som16b,ax  ; et ajoute le nombre a la somme de 16bit

mov bx,10           
mov al,num[1]  ; le caractere de dizaine
sub al,30h
mov ah, 0
mul bx
add som,al
add som16b,ax

mov bx,1           
mov al,num[2]  ; le caractere d'unite
sub al,30h;
mov ah, 0
mul bx
add som,al
add som16b,ax

cmp som16b, 255  ; comparer la somme en 16bits s'elle est superieur de 255 ; va sauter
JA codage_except ; a l'etiquette codage_except ou un message d'erreur s'affiche


mov dx,offset nl
mov ah,9
int 21h


mov dx,offset som ; afficher le caractere associe
mov ah,9          ; a le nombre entre
int 21h           ;


mov di, 7
mov bx,2
mov al,som
etq:              ; cette boucle, son but
mov ah,0          ; est de converter le nombre au binaire
div bl            ; utilisant les divisions successives par 2
mov bin[di],ah    ; on divise ax par bl, le reste se trouve 
dec di            ; dans ah
cmp al,0          ;
jne etq           ;


mov dx,offset nl
mov ah,9
int 21h 


mov dx,offset bin ; afficher le nombre binaire comme
mov ah, 09        ; suite des nombre 0 et 1 en Hex
int 21h           ; 0 = null character; 1 = smiley face

mov cx,8
mov si,8
numbb:            ; boucle pour converter
dec si            ; chaque nombre au caractere
mov bl,bin[si]    ; 0h -> '0' ; 1h -> '1'
add bl,30h        ; on ajoute 30h au nombre 
mov bin[si],bl    ; pour obtenir son caractere equivalant
loop numbb        ;

mov dx,offset nl
mov ah,9
int 21h

mov dx,offset bin ;
mov ah, 09        ; afficher le nombre binaire
int 21h           ;

mov dx, offset nl
mov ah, 9
int 21h

retour:
mov dx, offset msgretour ; afficher un message de possibilite
mov ah, 9                ; de repeter loperation avec un autre nombre  
int 21h                  ; 

mov ah, 1                ; saisie d'un caractere
int 21h                  ;

cmp al, 'y'              ; si le caractere egale 'y'
je program               ; goto l'ettique program

JMP END                  ; sinon goto END; la fin du programme
 
codage_except:

mov dx,offset nl
mov ah,9
int 21h

mov dx,offset msg_erreur
mov ah,09
int 21h   

mov dx,offset nl
mov ah,9
int 21h

jmp retour

END: ret

