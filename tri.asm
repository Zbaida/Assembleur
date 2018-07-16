; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db 3,25,2,31,5,8,'$'
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    mov cx,6 
    mov di,0  
    mov si,0
       
   aff1:
      mov ah ,2    
      mov al, pkey[di] 
      aam 
      mov bx,ax
      
      mov ah ,2 
      
      mov dl, bh
      add dl,48 
      int 21h   
      
      mov dl, bl
      add dl,48 
      int 21h
      
      mov dl, 1fH
      int 21h
        inc di
   cmp pkey[di],'$'
   jne aff1:    
     
     mov di,0  
   for:
   for2:
     
   mov bh,pkey[di] 
   cmp bh,pkey[si]
   jg fin
    xchg bh,pkey[si]
     mov pkey[di] ,bh
   fin:  
            
   inc si
   cmp pkey[si],'$'
   jne for2:
   
    mov si,0
    inc di
   cmp pkey[di],'$'
   jne for:
    
   
     mov di,0 
      mov ah ,2   
      mov dl, 0AH
      int 21h
      mov dl, 0DH
      int 21h
      
      aff2:  
      
      mov ah ,2    
      mov al, pkey[di] 
      aam 
      mov bx,ax
      
      mov ah ,2 
      
      mov dl, bh
      add dl,48 
      int 21h   
      
      mov dl, bl
      add dl,48 
      int 21h
      
      mov dl, 1fH
      int 21h
        inc di
   cmp pkey[di],'$'
   jne aff2:   
    
    ; output string at ds:dx
    
    ; wait for any key....    
    
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
