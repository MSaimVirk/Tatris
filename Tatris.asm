; 22L-6788 Saim Virk
; 22L-6969 Talha Naseer

[org 0x0100]
jmp start

score: db 'SCORE',0
time: db 'TIME',0
next_block: db 'Next Block',0
starting_message: db 'TATRIS',0
starting_message1: db 'press any key to START the game',0
ending_message: db 'Game Over',0
end_score: db 'Your score is: ',0

scor: dw 0
randNum: db 0
randNum1: db 0
randNum5: db 0
line_check: dw 0
tick_count: dw 0
total_sec: dw 0
total_min: dw 0
endgame: dw 0

oldisr: dd 0

shape01: dw 0x69fa, 0x69fa, 0x69b0, 0x69b0, 0x69fa, 0x69fa, 0x69b0, 0x69b0
shape02: dw 0x50fa, 0x50fa, 0x50b0, 0x50b0, 0x50fa, 0x50fa, 0x50fa, 0x50fa
shape03: dw 0x47fa, 0x47fa, 0x47b0, 0x47b0, 0x47b0, 0x47b0, 0x47fa, 0x47fa
shape04: dw 0x36fa, 0x36fa, 0x36b0, 0x36b0, 0x36b0, 0x36b0, 0x36fa, 0x36fa
shape05: dw 0x25fa, 0x25fa, 0x25b0, 0x25b0, 0x25fa, 0x25fa, 0x25b0, 0x25b0


printstr:                   ;Print given string at given co-ordinates and given attributes
    push bp 
    mov bp, sp 
    push es 
    push ax 
    push cx 
    push si 
    push di 
    push ds 
    pop es
    mov di, [bp+4]
    mov cx, 0xffff
    xor al, al
    repne scasb
    mov ax, 0xffff
    sub ax, cx
    dec ax
    jz exit

    mov cx, ax
    mov ax, 0xb800 
    mov es, ax
    mov al, 80
    mul byte [bp+8]
    add ax, [bp+10]
    shl ax, 1
    mov di,ax
    mov si, [bp+4]
    mov ah, [bp+6]
    cld

nextchar:
    lodsb
    stosw
    loop nextchar

exit:
    pop di 
    pop si 
    pop cx 
    pop ax 
    pop es 
    pop bp 
    ret 8

print_num:                                               ;printing the numerical data
    push bp 
    mov  bp, sp 
    push es 
    push di 
    push ax 
    push bx 
    push cx 
    push dx 

    mov  ax, 0xb800 
    mov  es, ax         
    mov  ax, [bp+4]
    mov  bx, 10           
    mov  cx, 0

nextdigit:
    mov  dx, 0
    div  bx  
    add  dl, 0x30
    push dx          
    inc  cx                
    cmp  ax, 0       
    jnz  nextdigit    
    mov  di, [bp+6]      

nextpos:
    pop  dx                 
    mov  dh, 121  
    mov [es:di], dx
    add  di, 2             
    loop nextpos            
 
    pop  dx 
    pop  cx 
    pop  bx 
    pop  ax 
    pop  di 
    pop  es 
    pop  bp 
    ret  4

print_line:               ;print line with given attributes and starting and ending points
    push bp
    mov bp,sp
    push es
    push di
    push ax
    push bx
    push cx

    mov ax,0xb800
    mov es,ax
    mov di,[bp+8]
    mov cx,[bp+6]
    mov bx,[bp+4]
    mov ax,[bp+10]

l1:
    mov word [es:di],ax
    add di,bx
    dec cx
    jnz l1

    pop cx
    pop bx
    pop ax
    pop di
    pop es
    pop bp
    ret 8

clear_screen:      ;Set all memory elements of video memory to space with white background 
    push es
    push di
    push ax
    push cx

    mov ax,0xb800
    mov es,ax
    xor di,di
    mov ax,0x7020
    mov cx,2000

    cld
    repnz stosw

    pop cx
    pop ax
    pop di
    pop es
    ret

animation_1:
    call clear_screen
    push es
    push di
    push dx
    push cx
    push bx
    push ax
    xor di,di
    mov ax,0xb800
    mov es,ax
    mov dx,10
    mov bx,24
    mov ax,80

outer_loop:
    mov cx,ax
inner_1:
    mov word [es:di],0x07b0
    call delay
    add di,2
    loop inner_1
    sub ax,2
    mov cx,bx
    add di,158
inner_2:
    mov word [es:di],0x07b0
    sub di,2
    mov word [es:di],0x07b0
    add di,2
    call delay
    add di,160
    loop inner_2
    sub bx,2
    mov cx,ax
    sub di,164
inner_3:
    mov word [es:di],0x07b0
    call delay
    sub di,2
    loop inner_3
    sub ax,4
    mov cx,bx
    sub di,158
inner_4:
    mov word [es:di],0x07b0
    add di,2
    mov word [es:di],0x07b0
    sub di,2
    call delay
    sub di,160
    loop inner_4
    call play_tune1
    dec dx
    jnz outer_loop

    pop ax
    pop bx
    pop cx
    pop dx
    pop di
    pop es
    ret

animation_2:                                  ;completely black the screen
    push es
    push di
    push dx
    push cx
    push bx
    push ax
    xor di,di
    mov ax,0xb800
    mov es,ax
    mov dx,11
    mov bx,23
    mov ax,80

outer__loop:
    mov cx,ax
inner__1:
    mov word [es:di],0x0720
    call delay
    add di,2
    loop inner__1
    mov cx,bx
    add di,158
inner__2:
    sub di,2
    mov word [es:di],0x0720
    add di,2
    mov word [es:di],0x0720
    call delay
    add di,160
    loop inner__2
    sub ax,2
    mov cx,ax
inner__3:
    mov word [es:di],0x0720
    call delay
    sub di,2
    loop inner__3
    mov cx,bx
    inc cx
    sub ax,2
    sub di,2
inner__4:
    add di,2
    mov word [es:di],0x0720
    sub di,2
    mov word [es:di],0x0720
    call delay
    sub di,160
    loop inner__4
    add di,164
    sub bx,2

    dec dx
    jnz outer__loop


    pop ax
    pop bx
    pop cx
    pop dx
    pop di
    pop es
    ret

shape1:                                             ;horizontal line starting from left most
    push bp
    mov bp,sp
    push es
    push di
    push ds
    push si
    push ax
    push cx

    mov di,[bp+4]
    mov ax,0xb800
    mov es,ax
    mov si,shape01

    movsw
    movsw
    movsw
    movsw    
    movsw
    movsw
    movsw
    movsw

    pop cx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    pop bp
    ret

shape2:                                             ;T starting from left most
    push bp
    mov bp,sp    
    push es
    push di
    push ds
    push si
    push ax
    push cx

    mov di,[bp+4]
    mov ax,0xb800
    mov es,ax
    mov si,shape02

    movsw
    movsw
    movsw
    movsw    
    movsw
    movsw    
    add di,152
    movsw
    movsw

    pop cx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    pop bp
    ret

shape3:                                             ;Square starting from top left
    push bp
    mov bp,sp
    push es
    push di
    push ds
    push si
    push ax
    push cx

    mov di,[bp+4]
    mov ax,0xb800
    mov es,ax
    mov si,shape03

    movsw
    movsw
    movsw
    movsw    
    add di,152
    movsw
    movsw    
    movsw
    movsw

    pop cx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    pop bp
    ret

shape4:                                             ;J starting from top
    push bp
    mov bp,sp
    push es
    push di
    push ds
    push si
    push ax
    push cx

    mov di,[bp+4]
    mov ax,0xb800
    mov es,ax
    mov si,shape04

    movsw
    movsw
    add di,156
    movsw
    movsw    
    add di,152
    movsw
    movsw    
    movsw
    movsw

    pop cx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    pop bp
    ret

shape5:                                             ;L starting from top
    push bp
    mov bp,sp
    push es
    push di
    push ds
    push si
    push ax
    push cx

    mov di,[bp+4]
    mov ax,0xb800
    mov es,ax
    mov si,shape05

    movsw
    movsw
    add di,156
    movsw
    movsw    
    add di,156
    movsw
    movsw    
    movsw
    movsw

    pop cx
    pop ax
    pop si
    pop ds
    pop di
    pop es
    pop bp
    ret

movleftS1:                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    S1L
    mov di,bx
    mov si,di
    sub di,4
    cmp word [es:di],0x70b0
    jne exit1
    mov cx,8
    repnz movsw

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    sub bx,4
exit1:
    ret

movrightS1:                                                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   S1R
    mov si,bx
    add si,14
    mov di,si
    add di,4
    cmp word [es:di],0x70b0
    jne exit11

    mov cx,8
looop0:
    movsw
    sub di,4
    sub si,4
    loop looop0
    sub di,2
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    add bx,4
exit11:
    ret

play_s1:                                                                                    ;moving down
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es
    push ds

    mov ax,0xb800
    mov es,ax
    mov ds,ax
    mov bx,374
md1:
    call delay_n
    mov si,bx
    mov di,si
    add di,160
    add bx,160
    cmp word [es:di],0x70b0
    jne ends1
    cmp word [es:di+8],0x70b0
    jne ends1
    cmp word [es:di+4],0x70b0
    jne ends1
    cmp word [es:di+12],0x70b0
    jne ends1

    cld
    mov cx,8
    repnz movsw
    sub di,176
    sub si,176
    mov cx,8
looop1:
    mov word[es:di],0x70b0
    add di,2
    loop looop1

    call play_tune1

    mov ah,1
    int 16h
    jz noakpS1
    mov ah,0
    int 16h
    cmp ah,0x4b
    jne checkRAKS1
    call movleftS1

checkRAKS1:
    cmp ah,0x4d
    jne noakpS1
    call movrightS1

noakpS1:
    jmp md1
    
ends1:
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop bx 
    pop ax 
    pop bp 
    ret

movleftS2:                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    S2L
    mov di,bx
    mov si,di
    sub di,4
    cmp word [es:di],0x70b0
    jne exit2
    cmp word [es:di+164],0x70b0
    jne exit2
    mov cx,6
loooop0:
    movsw
    loop loooop0
    mov word [es:di],0x70b0
    mov word [es:di+2],0x70b0

    add si,152
    add di,152

    movsw
    movsw
    mov word [es:di],0x70b0
    mov word [es:di+2],0x70b0

    sub bx,4
exit2:
    ret

movrightS2:                                                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   S2R
    mov di,bx
    add di,14
    mov si,bx
    add si,10
    cmp word [es:di],0x70b0
    jne exit22
    cmp word [es:di+156],0x70b0
    jne exit22
    movsw

    mov cx,5
loooop2:
    sub di,4
    sub si,4
    movsw
    loop loooop2

    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    add si,164
    add di,168
    movsw

    sub di,4
    sub si,4
    movsw
    
    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    add bx,4
exit22:
    ret

play_s2:                                                                                    ;moving down
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es
    push ds

    mov ax,0xb800
    mov es,ax
    mov ds,ax
    mov bx,374
md2:
    call delay_n
    mov si,bx
    add si,164
    mov di,si
    add di,160
    add bx,160
    cmp word [es:di],0x70b0
    jne ends2
    cmp word [es:di-156],0x70b0
    jne ends2
    cmp word [es:di-164],0x70b0
    jne ends2
    movsw
    movsw
    sub di,168
    sub si,168
    movsw
    movsw
    movsw
    movsw
    movsw
    movsw
    sub di,172
    mov cx,6
loooop1:
    mov word[es:di],0x70b0
    add di,2
    loop loooop1

    call play_tune1


    mov ah,1
    int 16h
    jz noakpS2
    mov ah,0
    int 16h
    cmp ah,0x4b
    jne checkRAKS2
    call movleftS2

checkRAKS2:
    cmp ah,0x4d
    jne noakpS2
    call movrightS2

noakpS2:
    jmp md2
    
ends2:
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop bx 
    pop ax 
    pop bp 
    ret

movleftS3:                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    S3L
    mov di,bx
    mov si,di
    sub di,4
    cmp word [es:di],0x70b0
    jne exit3
    cmp word [es:di+160],0x70b0
    jne exit3

    movsw
    movsw
    movsw
    movsw

    mov word[es:di],0x70b0
    mov word[es:di+2],0x70b0

    add di,152
    add si,152

    movsw
    movsw
    movsw
    movsw

    mov word[es:di],0x70b0
    mov word[es:di+2],0x70b0

    sub bx,4
exit3:
    ret

movrightS3:                                                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   S2R
    mov di,bx
    add di,168
    mov si,di
    sub si,2
    add di,2
    cmp word [es:di],0x70b0
    jne exit33
    cmp word [es:di-160],0x70b0
    jne exit33
    movsw

    mov cx,3
looooop2:
    sub di,4
    sub si,4
    movsw
    loop looooop2

    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    sub si,156
    sub di,152
    movsw

    mov cx,3
looooop3:
    sub di,4
    sub si,4
    movsw
    loop looooop3
    
    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    add bx,4
exit33:
    ret

play_s3:                                                                                    ;moving down
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es
    push ds

    mov ax,0xb800
    mov es,ax
    mov ds,ax
    mov bx,374                             ;; starting left position of di
md3:
    call delay_n
    mov si,bx
    add si,160
    mov di,si
    add di,160
    add bx,160
    cmp word [es:di],0x70b0
    jne ends3
    cmp word [es:di+4],0x70b0
    jne ends3
    movsw
    movsw
    movsw
    movsw
    sub di,168
    sub si,168
    movsw
    movsw
    movsw
    movsw
    sub di,168
    mov word [es:di],0x70b0
    mov word [es:di+2],0x70b0
    mov word [es:di+4],0x70b0
    mov word [es:di+6],0x70b0

    call play_tune1


    mov ah,1
    int 16h
    jz noakpS3
    mov ah,0
    int 16h
    cmp ah,0x4b
    jne checkRAKS3
    call movleftS3

checkRAKS3:
    cmp ah,0x4d
    jne noakpS3
    call movrightS3

noakpS3:
    jmp md3
    
ends3:
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop bx 
    pop ax 
    pop bp 
    ret

movleftS4:                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    S3L
    mov di,bx
    add di,316
    mov si,di
    sub di,4
    cmp word [es:di],0x70b0
    jne exit4
    cmp word [es:di-156],0x70b0
    jne exit4
    cmp word [es:di-316],0x70b0
    jne exit4
    mov cx,4
loooooop0:
    movsw
    loop loooooop0

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    sub di,2

    sub si,164
    sub di,164
    movsw
    movsw

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    sub di,2

    sub si,164
    sub di,164
    movsw
    movsw

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    sub di,2

    sub bx,4
exit4:
    ret

movrightS4:                                                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   S2R
    mov di,bx
    add di,4
    mov si,di
    sub si,2
    add di,2
    cmp word [es:di],0x70b0
    jne exit44
    cmp word [es:di+160],0x70b0
    jne exit44
    cmp word [es:di+320],0x70b0
    jne exit44

    movsw
    sub di,4
    sub si,4
    movsw

    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    add di,164
    add si,160
    movsw
    sub di,4
    sub si,4
    movsw
    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    add di,164
    add si,160
    movsw
    mov cx,3
loooop4:
    sub di,4
    sub si,4
    movsw
    loop loooop4
    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    add bx,4
exit44:
    ret

play_s4:                                                                                    ;moving down
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es
    push ds

    mov ax,0xb800
    mov es,ax
    mov ds,ax
    mov bx,374                             ;; starting left position of di
md4:
    call delay_n
    mov si,bx
    add si,316
    mov di,si
    add di,160
    add bx,160
    cmp word [es:di],0x70b0
    jne ends4
    cmp word [es:di+4],0x70b0
    jne ends4
    movsw
    movsw
    movsw
    movsw
    sub si,164
    sub di,168
    mov word [es:di],0x70b0
    mov word [es:di+2],0x70b0
    add di,4
    movsw
    movsw
    sub di,164
    sub si,164
    movsw
    movsw
    sub di,164
    mov word [es:di],0x70b0
    mov word [es:di+2],0x70b0   

    call play_tune1
 

    mov ah,1
    int 16h
    jz noakpS4
    mov ah,0
    int 16h
    cmp ah,0x4b
    jne checkRAKS4
    call movleftS4

checkRAKS4:
    cmp ah,0x4d
    jne noakpS4
    call movrightS4

noakpS4:
    jmp md4
    
ends4:
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop bx 
    pop ax 
    pop bp 
    ret

movleftS5:                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    S3L
    mov di,bx
    add di,320
    mov si,di
    sub di,4
    cmp word [es:di],0x70b0
    jne exit5
    cmp word [es:di-160],0x70b0
    jne exit5
    cmp word [es:di-320],0x70b0
    jne exit5
    movsw
    movsw
    movsw
    movsw

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    sub si,168
    sub di,170
    movsw
    movsw

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    sub si,164
    sub di,166
    movsw
    movsw

    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0

    sub bx,4
exit5:
    ret

movrightS5:                                                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   S2R
    mov di,bx
    add di,330
    mov si,bx
    add si,326
    cmp word [es:di],0x70b0
    jne exit55
    cmp word [es:di-164],0x70b0
    jne exit55
    cmp word [es:di-324],0x70b0
    jne exit55    
    movsw
    mov cx,3
loooooop5:
    sub di,4
    sub si,4
    movsw
    loop loooooop5
    mov word [es:di-6],0x70b0
    mov word [es:di-4],0x70b0
    sub di,160
    sub si,160
    movsw
    sub di,4
    sub si,4
    movsw
    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    sub di,156
    sub si,160
    movsw
    sub di,4
    sub si,4
    movsw

    sub di,6
    mov word [es:di],0x70b0
    add di,2
    mov word [es:di],0x70b0
    
    add bx,4
exit55:
    ret

play_s5:                                                                                    ;moving down
    push bp
    mov bp,sp
    push ax
    push bx
    push cx
    push si
    push di
    push es
    push ds

    mov ax,0xb800
    mov es,ax
    mov ds,ax
    mov bx,374                             ;; starting left position of di
md5:
    call delay_n
    mov si,bx
    add si,320
    mov di,si
    add di,160
    add bx,160
    cmp word [es:di],0x70b0
    jne ends5
    cmp word [es:di+4],0x70b0
    jne ends5
    movsw
    movsw
    movsw
    movsw
    sub di,168
    sub si,168
    movsw
    movsw
    mov word[es:di],0x70b0
    mov word[es:di+2],0x70b0
    sub di,164
    sub si,164
    movsw
    movsw
    sub di,164
    mov word[es:di],0x70b0
    mov word[es:di+2],0x70b0

    call play_tune1

    mov ah,1
    int 16h
    jz noakpS5
    mov ah,0
    int 16h
    cmp ah,0x4b
    jne checkRAKS5
    call movleftS5

checkRAKS5:
    cmp ah,0x4d
    jne noakpS5
    call movrightS5

noakpS5:
    jmp md5
    
ends5:
    pop ds 
    pop es 
    pop di 
    pop si 
    pop cx 
    pop bx 
    pop ax 
    pop bp 
    ret

check_endgame:
push es
push ax

mov ax,0xb800
mov es,ax

cmp word[es:694],0x70b0
jz eennd
mov word [endgame],1
eennd:
cmp word[es:700],0x70b0
jz eenndd
mov word [endgame],1

eenndd:
pop ax
pop es
ret

starting_screen:
    push es
    push di
    push ax
    push cx

    mov di,1136                                       ;left side of box
    mov cx,10
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,1144                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1146                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,1162                                       ;left side of box
    mov cx,8
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,1162                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1164                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1646                                       ;left side of box
    mov cx,4
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,2122                                       ;left side of box
    mov cx,8
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line

    mov di,1184                                       ;left side of box
    mov cx,10
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,1192                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1194                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,1210                                       ;left side of box
    mov cx,9
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,1210                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1212                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1690                                       ;left side of box
    mov cx,9
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,1228                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1230                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,1238                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1236                                       ;left side of box
    mov cx,7
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,1244                                       ;left side of box
    mov cx,9
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,1724                                       ;left side of box
    mov cx,9
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line
    mov di,2204                                       ;left side of box
    mov cx,9
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line

    mov di,1244                                       ;left side of box
    mov cx,3
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,1740                                       ;left side of box
    mov cx,3
    mov ax,0x67b0
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    
    mov ax,24                                      ;start
    push ax
    mov ax,19
    push ax
    mov ax,121
    push ax
    mov ax,starting_message1
    push ax
    call printstr

    call system_pause
    call animation_2

    pop cx                                           ;ending of starting screen
    pop ax
    pop di
    pop es
    ret

clear_next_block:
push ax
push cx
push dx
push es
push di
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ax,0xb800
    mov es,ax
    mov di,2348
    add di,160
    mov dx,5
loooooooooooooop:
    mov cx,15
    looooooooooooop:
        mov word [es:di],0x7020
        add di,2
        loop looooooooooooop
    add di,130
    dec dx
    jnz loooooooooooooop  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pop di
pop es
pop dx
pop cx
pop ax
ret

outline:
    push es
    push di
    push ax
    push cx

    mov ax,0xb800
    mov es,ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov di,334
    mov dx,21
loooooooooooop:
    mov cx,40
    looooooooooop:
        mov word [es:di],0x70b0
        add di,2
        loop looooooooooop
    add di,80
    dec dx
    jnz loooooooooooop    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov di,170                                      ;top line of box
    mov cx,71
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line

    mov di,3690                                     ;bottom line of box
    mov cx,70
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line

    mov di,330                                       ;left side of box
    mov cx,22
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,332                                       ;left side of box
    mov cx,22
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,470                                       ;right side of box
    mov cx,22
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,312                                       ;right side of box
    mov cx,23
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,416                                       ;line dividing the box
    mov cx,22
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line
    mov di,414                                       ;line dividing the box
    mov cx,22
    mov ax,0x0920
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov ax,58                                      ;score
    push ax
    mov ax,4
    push ax
    mov ax,121
    push ax
    mov ax,score
    push ax
    call printstr
    
    mov ax,1078                                     ;score position
    push ax
    mov ax,[scor]
    push ax
    call print_num

    mov ax,58                                      ;time
    push ax
    mov ax,8
    push ax
    mov ax,121
    push ax
    mov ax,time
    push ax
    call printstr

    call print_colon

    mov ax,56
    push ax
    mov ax,12
    push ax
    mov ax,121
    push ax
    mov ax,next_block
    push ax
    call printstr

    mov di,2348                                      ;top line of box
    mov cx,15
    mov ax,0x795f
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line

    mov di,3308                                     ;bottom line of box
    mov cx,15
    mov ax,0x795f
    push ax
    push di
    push cx
    mov ax,2
    push ax
    call print_line

    mov di,2506                                       ;left side of box
    mov cx,6
    mov ax,0x797c
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    mov di,2538                                       ;right side of box
    mov cx,6
    mov ax,0x797c
    push ax
    push di
    push cx
    mov ax,160
    push ax
    call print_line

    pop cx
    pop ax
    pop di
    pop es
    ret

delay:
    push cx
    mov cx,0x3fff
llll1:
    loop llll1
    pop cx
    ret

delay_long:
    
    push cx
    push ax

    mov cx,0x1fff
ll1:
    mov ax,0xff
ll2:
    dec ax
    jnz ll2
    loop ll1

    pop ax
    pop cx
    ret

delay_n:
    
    push cx
    push ax

    mov cx,0xfff
lll1:
    mov ax,0x6f
lll2:
    dec ax
    jnz lll2
    loop lll1

    pop ax
    pop cx
    ret

ending_screen:
    push es
    push di
    push ax
    push cx

    call animation_1

    mov ax,8                                      ;ending screen
    push ax
    mov ax,11
    push ax
    mov ax,121
    push ax
    mov ax,ending_message
    push ax
    call printstr
    call delay

    mov ax,4
    push ax
    mov ax,12
    push ax
    mov ax,121
    push ax
    mov ax,end_score
    push ax
    call printstr
    call delay

    mov ax,1956                     ;end score position
    push ax
    mov ax,[scor]
    push ax
    call print_num

    pop cx                                           ;ending of ending screen
    pop ax
    pop di
    pop es
    ret

randGen:
    push bp
    mov bp, sp
    push cx
    push dx
    push ax
    
    rdtsc                   ;getting a random number in ax dx
    xor dx,dx               ;making dx 0
    mov cx, [bp + 4]
    div cx                  ;dividing by 'Paramter' to get numbers from 0 - Parameter
    mov [randNum], dl      ;moving the random number in variable
    
    pop ax
    pop dx
    pop cx
    pop bp
    ret 2

randGen1:
    push bp
    mov bp, sp
    push cx
    push dx
    push ax
    
    rdtsc                   ;getting a random number in ax dx
    xor dx,dx               ;making dx 0
    mov cx, [bp + 4]
    div cx                  ;dividing by 'Paramter' to get numbers from 0 - Parameter
    mov [randNum5], dl      ;moving the random number in variable
    
    pop ax
    pop dx
    pop cx
    pop bp
    ret 2

system_pause:
    push ax

    mov ah,0x1
    int 0x21

    pop ax
    ret


move_rest_down:
    push bp
    mov bp,sp
    push es
    push di
    push cx
    push ax 
    push si
    push ds

    mov ax,0xb800
    mov es,ax
    mov ds,ax
    mov di,[bp+4]
    mov si,di
    sub si,160
    mov ax,15
lopp:
    mov cx,40
    repnz movsw
    sub di,240
    sub si,240
    dec ax
    jnz lopp

;    add word[scor],100
;    mov ax,1078                                     ;score position
;    push ax
;    mov ax,[scor]
;    push ax
;    call print_num
    pop ds
    pop si
    pop ax
    pop cx
    pop di
    pop es
    pop bp
    ret 2

clear_line:
    push bp
    mov bp,sp
    push es
    push di
    push cx
    push ax

    mov ax,0xb800
    mov es,ax
    mov di,[bp+4]
    mov cx,40
loooooooooop:
    mov word[es:di],0x70b0
    add di,2
    loop loooooooooop

    push bx
    call move_rest_down

    pop ax
    pop cx
    pop di
    pop es
    pop bp
    ret 2

check_lines_for_poping:
    push es
    push di
    push dx
    push cx
    push bx
    push ax

    mov ax,0xb800
    mov es,ax
    mov bx,3534

    mov dx,16
lopppppp:
    mov cx,40
    mov di,bx
    mov word[line_check],1
    loppppp:
        cmp word [es:di],0x70b0
        jnz nextcheck
        mov word[line_check],0
        nextcheck:
        add di,2
        loop loppppp
    cmp word[line_check],1
    jnz nextlinecheck
    push bx
    call clear_line
    add bx,160
    nextlinecheck:
    sub bx,160
    dec dx
    jnz lopppppp

exitt:
    pop ax
    pop bx
    pop cx
    pop dx
    pop di
    pop es
    ret

print_colon:
push es
push ax

mov ax,0xb800
mov es,ax
mov word[es:1718],0x703a

pop ax
pop es
ret

clear_time_cell:
push es
push ax

mov ax,0xb800
mov es,ax
mov word[es:1722],0x7020

pop ax
pop es
ret


; timer interrupt service routine 
timer:
push ax 
inc word [cs:tick_count]            ; increment tick count 
cmp word [cs:tick_count],18
jl less
inc word[cs:total_sec]
mov word[cs:tick_count],0

cmp word[cs:total_sec],60
jl nnn
inc word[cs:total_min]
mov word[cs:total_sec],0
nnn:
call clear_time_cell
push 1720
push word [cs:total_sec] 
call print_num
push 1716
push word [cs:total_min] 
call print_num                      ; print tick count
less:

pop ax 
jmp far [cs:oldisr]

play_tune1:
    push ax

    mov ax,7
    push ax
    call randGen1


    cmp byte[randNum5],1
    jne pn2
    push 261
    jmp eeed
pn2:
    cmp byte[randNum5],2
    jne pn3
    push 294
    jmp eeed
pn3:
    cmp byte[randNum5],3
    jne pn4
    push 329
    jmp eeed
pn4:
    cmp byte[randNum5],4
    jne pn5
    push 349
    jmp eeed
pn5:
    cmp byte[randNum5],1
    jne pn6
    push 392
    jmp eeed
pn6:
    cmp byte[randNum5],1
    jne pn7
    push 440
    jmp eeed
pn7:
    push 493
eeed:
    call play_note

    pop ax
    ret

play_note:
    ; Play a note with a given frequency
    push bp
    mov bp, sp

    mov al, 0B6h
    out 43h, al
    mov ax, [bp + 4]  ; Get the note frequency from the stack
    out 42h, al
    mov al, ah
    out 42h, al
    in al, 61h
    or al, 3
    out 61h, al

    pop bp
    ret 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


start:
    call clear_screen

    call starting_screen

    call clear_screen

;    mov ax, 03D04h    ; Set the initial delay and frequency for the first note (adjust as needed)
;    out 43h, al       ; Send the low byte to port 43h
;    mov al, ah
;    out 42h, al       ; Send the high byte to port 42h
;    in al, 61h        ; Read the current value of the speaker control register
;    or al, 3          ; Turn on the speaker (bits 0 and 1)
;    out 61h, al       ; Send the new value back to the speaker control register

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xor ax, ax 
mov es, ax                         ; point es to IVT base 
mov ax,[es:8*4]
mov [oldisr],ax
mov ax,[es:8*4+2]
mov [oldisr+2],ax
cli                                ; disable interrupts 
mov word [es:8*4], timer           ; store offset at n*4 
mov [es:8*4+2], cs                 ; store segment at n*4+2 
sti                                ; enable interrupts 

    call outline

    mov ax, 5
    push ax
    call randGen
    mov al,[randNum]
    mov byte[randNum1],al
    mov ax, 5
    push ax
    call randGen

    mov word[tick_count],0
    mov word[total_sec],0
    mov word[total_min],0

gamep:

    mov al,[randNum]
    add al,1

    cmp al,1
    jnz plys2
    push 2834
    call shape1
    jmp enddd
plys2:
    cmp al,2
    jnz plys3
    push 2834
    call shape2
    jmp enddd
plys3:
    cmp al,3
    jnz plys4
    push 2834
    call shape3
    jmp enddd
plys4:
    cmp al,4
    jnz plys5
    push 2834
    call shape4
    jmp enddd
plys5:
    push 2834
    call shape5
enddd:

    mov al,[randNum1]
    add al,1

    cmp al,1
    jnz plays2
    push 374
    call shape1
    call play_s1
    jmp endd
plays2:
    cmp al,2
    jnz plays3
    push 374
    call shape2
    call play_s2
    jmp endd
plays3:
    cmp al,3
    jnz plays4
    push 374
    call shape3
    call play_s3
    jmp endd
plays4:
    cmp al,4
    jnz plays5
    push 374
    call shape4
    call play_s4
    jmp endd
plays5:
    push 374
    call shape5
    call play_s5
endd:
    call clear_next_block
    add word[scor],10
    mov ax,1078                                     ;score position
    push ax
    mov ax,[scor]
    push ax
    call print_num
    call check_lines_for_poping

    mov al,[randNum]
    mov byte[randNum1],al
    mov ax, 5
    push ax
    call randGen

    cmp word[total_min],2
    jge enddddd
    call check_endgame
    cmp word[endgame],1
    jz enddddd
    jmp gamep

enddddd:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

xor ax, ax 
mov es, ax                         ; point es to IVT base 
cli                                ; disable interrupts 
mov ax,[oldisr]
mov word [es:8*4], ax           ; store offset at n*4 
mov ax,[oldisr+2]
mov word[es:8*4+2], ax                 ; store segment at n*4+2 
sti                                ; enable interrupts

    call system_pause

    call ending_screen


    ; Turn off the speaker
    in al, 61h         ; Read the current value of the speaker control register
    and al, 0FCh       ; Turn off bits 0 and 1 to disable the speaker
    out 61h, al        ; Send the new value back to the speaker control register

    ; Add a delay to allow the last note to complete
    call delay

    ; Terminate the program
    mov ah, 4Ch       ; DOS function number for program termination
    xor al, al        ; Return code 0
    int 21h           ; Call DOS interrupt


call system_pause
mov  ax,0x4c00
int 0x21




;    push 2834
;    call shape1
;    push 374
;    call shape1
;    call play_s1
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape1
;    push 374
;    call shape1
;    call play_s1
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 2834
;    call shape1
;    push 374
;    call shape1
;    call play_s1
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape1
;    call play_s1
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 2834
;    call shape1
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape1
;    call play_s1
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 2834
;    call shape4
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape5
;    push 374
;    call shape4
;    call play_s4
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape5
;    call play_s5
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape3
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape1
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;    
;    push 374
;    call shape3
;    call play_s1
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 2834
;    call shape2
;    push 374
;    call shape3
;    call play_s3
;    call clear_next_block
;    call check_lines_for_poping
;
;    push 374
;    call shape2
;    call play_s2
;    call clear_next_block
;    call check_lines_for_poping