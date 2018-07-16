name "Statistique"

org 100h
.data
tab db 100

msg1 db "Enter la taille du tableau: $" 
msg2 db "Enter une suite des nombre: $"
nl db 13, 10, '$'
menu db "                      '''''' Menu ''''''''''''''''", 13, 10,
     db "                      '                          '", 13, 10,
     db "                      ' 01 - Min                 '", 13, 10,
     db "                      ' 02 - Max                 '      - HOUMMI Oumnia ", 13, 10,
     db "                      ' 03 - Somme               '      - BOUGHNAM Taoufiq ", 13, 10,
     db "                      '                          '", 13, 10,
     db "                      ''''''''''''''''''''''''''''", 13, 10,
     db "                      choix > $"
errchoix db "                      choix incorrect !!!", 13, 10, '$'
errsize db "                      taille incorrecte !!!", 13, 10, '$'
strchoix db "                      choix > $"
msgresult db 13, 10, 13, 10, "  Result:", 13, 10,
                          db "----------", 13, 10, '$'
msqretry db 13, 10, 13, 10, "voulez-vous continuer (00/01)?$ "
msgmin db "le minimium est : $"
msgmax db "le maximium est : $"
msgsom db "la somme est : $"

strnbr db 0h, 0h, '$'
nbr db 0h, '$'
nbr16b dw 0h
strnbr16b db 0h, 0h, 0h, 0h, 0h, '$'
tabsize db 0h
     
min db 0h
max db 0h
som dw 0h ;; 16bits

.code
enter_tabsize:                         
mov dx, offset msg1
mov ah, 9
int 21h

call enternombre
cmp nbr, 0
je erreur_size
 
mov al, nbr
mov tabsize, al

mov dx, offset nl ; sauter la ligne
mov ah, 9
int 21h

mov dx, offset msg2
mov ah, 9
int 21h


mov ch, 0    
mov cl, tabsize    
mov si, 0

; saisie les elements du tableau
tab_element:
    call enternombre
    mov al, nbr
    mov tab[si], al
    inc si
    mov dx, 20h ;; afficher
    mov ah, 2   ;; un
    int 21h     ;; espace
loop tab_element

menu_block:    
mov dx, offset nl ; sauter la ligne
mov ah, 9
int 21h
mov dx, offset nl ; sauter la ligne
mov ah, 9
int 21h

mov dx, offset menu ; 
mov ah, 9
int 21h

enter_choix:
call enternombre
cmp nbr, 1
je min_block
cmp nbr, 2
je max_block
cmp nbr, 3
je somme_block

jmp erreur_choix

min_block:
   mov cl, tabsize
   mov si, 0
   mov al, tab[0] ; min =
   mov min, al    ; premier element dans le tableau
   
   cherche_min:
      mov al, tab[si]
      cmp al, min
      jae there
      mov min, al ;si le nombre est inferieur  par rapport au minimium
      there:
      inc si
   loop cherche_min
   
   ;; afficher le min                  
   mov dx, offset msgresult
   mov ah, 9
   int 21h
   mov dx, offset msgmin
   mov ah, 9
   int 21h                  
   ;afficher nommbre min
   mov al, min
   mov nbr, al
   call manipstrnombre
   mov dx, offset strnbr
   mov ah, 9
   int 21h  

jmp lafin

max_block:
   mov cl, tabsize
   mov si, 0
   mov al, tab[0]
   mov max, al ; max = premier element dans le tableau
   
   cherche_max:
      mov al, tab[si]
      cmp al, max
      jbe there2
      mov max, al ;si le nombre est superieur  par rapport au maximium
      there2:
      inc si
   loop cherche_max
   
   ;; afficher le max                  
   mov dx, offset msgresult
   mov ah, 9
   int 21h
   mov dx, offset msgmax
   mov ah, 9
   int 21h                  
   ;afficher nombre max
   mov al, max
   mov nbr, al
   call manipstrnombre
   mov dx, offset strnbr
   mov ah, 9
   int 21h  
 
 
jmp lafin

somme_block:
    mov cl, tabsize
    mov si, 0
    mov som, 0
    calc_somme:
        mov ah, 0
        mov al, tab[si]
        add som, ax
        inc si
    loop calc_somme
    
    
    
    mov ax, som
    mov nbr16b, ax
    call manipstrnbr16b
    
    ;; afficher le max                  
    mov dx, offset msgresult
    mov ah, 9
    int 21h
    mov dx, offset msgsom
    mov ah, 9                                   
    int 21h                  
    ;afficher nombre max
    mov dx, offset strnbr16b
    mov ah, 9
    int 21h

jmp lafin

erreur_choix:
    mov dx, offset errchoix
    mov ah, 9
    int 21h
    mov dx, offset strchoix
    mov ah, 9
    int 21h
    jmp enter_choix

erreur_size:
    mov dx, offset errsize
    mov ah, 9
    int 21h
    jmp enter_tabsize    
 
lafin: 
    mov dx, offset msqretry
    mov ah, 9
    int 21h
    call enternombre
    cmp nbr, 0
    je finprog
    cmp nbr, 1
    je menu_block
    jmp lafin

finprog:
;; end of code 

ret

;;;; procedures ;;;;
enternombre proc
    ;saisie des characteres  
    mov ah, 1
    int 21h
    mov strnbr[0], al
    mov ah, 1
    int 21h
    mov strnbr[1], al

    ;convertir les characteres en un nombre entier    
    mov al, strnbr[1]
    sub al, 30h
    mov nbr, al

    mov al, strnbr[0]
    sub al, 30h
    mov bl, 10
    mul bl

    add nbr, al
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ret
endp enternombre


manipstrnombre proc ; covertir le nombre 'nbr' en chaine de caracteres 'strnbr'
    mov ah, 0 
    mov al, nbr
    mov bl, 10
    div bl
    mov strnbr[0], al
    mov strnbr[1], ah
    add strnbr[0], 30h
    add strnbr[1], 30h
    ret
endp


manipstrnbr16b proc ;covertir le nombre 'nbr16b' en chaine de caracteres 'strnbr16b'
    mov ax, nbr16b
    mov bx, 10
    mov cx, 5
    mov si, 4
    convertchar:
        mov dx, 0
        div bx
        add dl, 30h
        mov strnbr16b[si], dl
        dec si
        cmp ax, 0
        je sorti_boucle
    loop convertchar
    sorti_boucle:
    ret
endp        