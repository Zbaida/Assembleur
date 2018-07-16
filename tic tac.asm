
data segment
	grid db 9 dup(0)
	player db 0
	win db 0
	temp db 0
	newGameQuest db "Voulez vous rejouer ? (y- oui, autre touche - no)$" 
	
	welcome1 db 10,9,9,9,9, "Bienvenue!$"
	welcome db 10,9,9,9,"****Jeux Tic Tac Toe****$"
	separator db "---|---|---$"
	enterLoc db "Choisir la position allant de  (1-9)$"
	turnMessageX db "Tour du premier joueur (X) $"
	turnMessageO db "Tour du deuxieme joueur(O) $"
	tieMessage db "Egalite entre les deux joueurs!$"
	winMessage db "Le joueur qui a gagne : $"
	inDigitError db "ERREUR!, la place est remplie$"
	inError db "ERREUR!, ce n'est pas un nombre$"
	newline db 0Dh,0Ah,'$'
ends 

stack segment
	dw 128 dup(0)
ends

code segment
start:
	mov ax, data
	mov ds, ax
	mov es, ax
	
	newGame:
	call initiateGrid  ;procedure d'initialisation du grille
	mov player, 10b    ; 2 en decimale
	mov win, 0
	mov cx, 9
	
	gameAgain:
		call clearScreen 
		lea dx, welcome1 
		call printString ;procedure d'affichage 
		lea dx, newline
		call printString
		lea dx, welcome
		call printString
		lea dx, newline
		call printString
		lea dx, newline
		call printString
		lea dx, newline
		call printString
		lea dx, newline
		call printString
		lea dx, enterLoc
		call printString
		lea dx, newline
		call printString
		call printString
		call printGrid
		mov al, player
		cmp al, 1
		je p2turn
			
			; la valeur de player etait 2 
			
			shr player, 1      ; 0010b --> 0001b;
			lea dx, turnMessageX
			call printString
			lea dx, newline
			call printString
			jmp endPlayerSwitch
		
		p2turn:; la valeur de player etait 1
			
			shl player, 1        ; 0001b --> 0010b
			lea dx, turnMessageO
			call printString
			lea dx, newline
			call printString
			
		endPlayerSwitch:
		    call getMove    ; bx va pointer sur la derniere position de getMove (le contenu de al)
		    mov dl, player
		    cmp dl, 1
		    jne p2move
		    mov dl, 'X'
		   jmp contMoves  ; pour compter combien de fois le joueur 1 a joue
		
		
		p2move:
		mov dl, 'O'
		
		contMoves:
		mov [bx], dl
		cmp cx, 5 ; pas besoin de verification apres la 5eme entree
		jg noWinCheck
		call checkWin
		cmp win, 1
		je won
		noWinCheck:
		loop gameAgain
		
	;cas d'egalite, cx = 0 a ce point pas gagnant encore
	 call clearScreen
	 lea dx, welcome
	 call printString
	 lea dx, newline
	 call printString
	 call printString
	 call printString
	 call printGrid
	 lea dx, tieMessage
	 call printString
	 lea dx, newline
	 call printString
	 jmp askForNewGame
	 
	won:; joueur actuel a gagne
	 call clearScreen
	 lea dx, welcome
	 call printString
	 lea dx, newline
	 call printString
	 call printString
	 call printString
	 call printGrid
	 lea dx, winMessage
	 call printString
	 mov dl, player
	 add dl, '0'
	 call putChar
	 lea dx, newline
	 call printString
	 
	askForNewGame:
	 lea dx, newGameQuest; demander de rejouer 
	 call printString
	 lea dx, newline
	 call printString
	 call getChar
	 cmp al, 'y'; rejouer si 'y' est presse
	 jne sof
	 jmp newGame
	 
	sof:
	mov ax, 4c00h
	int 21h
	                  ; *************procedures************
	                  
;-------------------------------------------;
;  ah = 01
; entrer  char en al;
getChar:
	mov ah, 01
	int 21h
	ret
;-------------------------------------------;	
;  ah = 02
; sortir le char de dl
;affecter a ah le dernier char sortie
putChar:
	mov ah, 02
	int 21h
	ret
;-------------------------------------------;
;  ah = 09
; sortir le char de dx
;   al = 24h


printString:
	mov ah, 09
	int 21h
	ret

;-------------------------------------------;
; Effacer l'ecran
; a la fin : ah = 0 


clearScreen:
	mov ah, 0fh
	int 10h
	mov ah, 0
	int 10h
	ret
	
;-------------------------------------------;
; verifier la disponibiliter de la case
;apres avoir recu la position:
; al - va recevoir la place de(0 - 8)
; bx - va pointer sur la dernier position recu(bx[al])

getMove:
	call getChar       ; al = getchar()
	call isValidDigit
	cmp ah, 1
	je contCheckTaken
	mov dl, 0dh
	call putChar
	lea dx, inError
	call printString
	lea dx, newline
	call printString
	jmp getMove
	
	contCheckTaken: ; verifier: si(grid[al] > '9'), grid[al] == 'O' ou 'X'
	lea bx, grid	
	sub al, '1'
	mov ah, 0
	add bx, ax
	mov al, [bx]
	cmp al, '9'
	jng finishGetMove
	mov dl, 0dh
	call putChar
	lea dx, inDigitError
	call printString
	lea dx, newline
	call printString
	jmp getMove
	finishGetMove:
	lea dx, newline
	call printString
	ret
	
;-------------------------------------------;
; Initialiser la grille de '1' a '9'
; utiliser bx, al, cx

initiateGrid:
	lea bx, grid ;bx pointer sur la grille
	mov al, '1'
	mov cx, 9
	initNextTa:
	mov [bx], al
	inc al
	inc bx
	loop initNextTa
	ret
	
;-------------------------------------------;
; verifier si le contenu de al est un chiffre
; sans compter '0'
; si c'est un chiffre, ah = 1, sinon ah = 0
  
  isValidDigit:
	mov ah, 0
	cmp al, '1'
	jl sofIsDigit
	cmp al, '9'
	jg sofIsDigit
	mov ah, 1
	sofIsDigit:
	ret
	
	
;-------------------------------------------;	
;  3x3 grille
; utiliser bx, dl, dx

printGrid:
	lea bx, grid
	call printRow
	lea dx, separator
	call printString
	lea dx, newline
	call printString
	call printRow
	lea dx, separator
	call printString
	lea dx, newline
	call printString
	call printRow
	ret

;-------------------------------------------;
;
;utiliser bx comme le premier nombre de ligne 
;  a la fin:
; dl = 3 eme cellule de la ligne
; bx += 3, pour la ligne suivante
; dx pointe sur la nouvelle ligne
printRow:

	;First Cell
	mov dl, ' '
	call putChar
	mov dl, [bx]
	call putChar
	mov dl, ' '
	call putChar
	mov dl, '|'
	call putChar
	inc bx
	
	;Second Cell
	mov dl, ' '
	call putChar
	mov dl, [bx]
	call putChar
	mov dl, ' '
	call putChar
	mov dl, '|'
	call putChar
	inc bx
	
	;Third Cell
	mov dl, ' '
	call putChar
	mov dl, [bx]
	call putChar
	inc bx
	lea dx, newline
	call printString
	ret
	
;-------------------------------------------;	
; Retourner 1 en al si un joueur est gagne 
; 1 si gagne, 0 sinon
; Changes bx
checkWin:
	lea si, grid
	call checkDiagonal
	cmp win, 1
	je endCheckWin
	call checkRows
	cmp win, 1
	je endCheckWin
	call CheckColumns
	endCheckWin:
	ret
	
;-------------------------------------------;	
checkDiagonal:
	;DiagonalLtR
	mov bx, si
	mov al, [bx]
	add bx, 4	;grid[0] ---> grid[4]
	cmp al, [bx]
	jne diagonalRtL
	add bx, 4	;grid[4] ---> grid[8]
	cmp al, [bx]
	jne diagonalRtL
	mov win, 1
	ret
	
	diagonalRtL:
	mov bx, si
	add bx, 2	;grid[0] ---> grid[2]
	mov al, [bx]
	add bx, 2	;grid[2] ---> grid[4]
	cmp al, [bx]
	jne endCheckDiagonal
	add bx, 2	;grid[4] ---> grid[6]
	cmp al, [bx]
	jne endCheckDiagonal
	mov win, 1
	endCheckDiagonal:
	ret
	
;-------------------------------------------;
checkRows:	
	;firstRow
	mov bx, si; --->grid[0]
	mov al, [bx]
	inc bx		;grid[0] ---> grid[1]
	cmp al, [bx]
	jne secondRow
	inc bx		;grid[1] ---> grid[2]
	cmp al, [bx]
	jne secondRow
	mov win, 1
	ret
	
	secondRow:
	mov bx, si; --->grid[0]
	add bx, 3	;grid[0] ---> grid[3]
	mov al, [bx]
	inc bx	;grid[3] ---> grid[4]
	cmp al, [bx]
	jne thirdRow
	inc bx	;grid[4] ---> grid[5]
	cmp al, [bx]
	jne thirdRow
	mov win, 1
	ret
	
	thirdRow:
	mov bx, si; --->grid[0]
	add bx, 6;grid[0] ---> grid[6]
	mov al, [bx]
	inc bx	;grid[6] ---> grid[7]
	cmp al, [bx]
	jne endCheckRows
	inc bx	;grid[7] ---> grid[8]
	cmp al, [bx]
	jne endCheckRows
	mov win, 1
	endCheckRows:
	ret
	
;-------------------------------------------;	

CheckColumns:
	;firstColumn
	mov bx, si; --->grid[0]
	mov al, [bx]
	add bx, 3	;grid[0] ---> grid[3]
	cmp al, [bx]
	jne secondColumn
	add bx, 3	;grid[3] ---> grid[6]
	cmp al, [bx]
	jne secondColumn
	mov win, 1
	ret
	
	secondColumn:
	mov bx, si; --->grid[0]
	inc bx	;grid[0] ---> grid[1]
	mov al, [bx]
	add bx, 3	;grid[1] ---> grid[4]
	cmp al, [bx]
	jne thirdColumn
	add bx, 3	;grid[4] ---> grid[7]
	cmp al, [bx]
	jne thirdColumn
	mov win, 1
	ret
	
	thirdColumn:
	mov bx, si; --->grid[0]
	add bx, 2	;grid[0] ---> grid[2]
	mov al, [bx]
	add bx, 3	;grid[2] ---> grid[5]
	cmp al, [bx]
	jne endCheckColumns
	add bx, 3	;grid[5] ---> grid[8]
	cmp al, [bx]
	jne endCheckColumns
	mov win, 1
	endCheckColumns:
	ret
	
ends
end start