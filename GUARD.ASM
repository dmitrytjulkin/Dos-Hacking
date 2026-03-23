.model tiny
.code
org 100h

VIDEOSEG        equ 0b800h
INP_ADDR        equ 82h
INP_LEN_ADDR    equ 80h
MAX_BUF_LEN     equ 00FFh

start:
.code
    mov dx, offset extra_phrase
    mov ah, 09h
    int 21h

    mov dx, offset max_len
    mov ah, 0ah
    int 21h                         ;saving input string in buffer

    xor cx, cx
    mov di, offset buffer
    mov cl, strlen
    call HashFunc                   ;receiving hash of input
    mov bx, ax

    jmp main

RESPOND:
    incorrect_psswrd db "Go Home, Walter (access denied)$"
    correct_psswrd   db "You're goddamn right (access granted)$"
    extra_phrase     db "Say my name: $"

BUF_SET_UP:
    max_len     db MAX_BUF_LEN
    strlen      db 0h
    buffer      db 010h dup( )

MY_PSSWRD:
    psswrd_code      dw 0Bh          ;GiovanniGiorgio

main:
    mov ax, psswrd_code

    xor ah, ah
    cmp ax, bx
    je has_guessed

hasnt_guessed:
    mov dx, offset incorrect_psswrd
    jmp next

has_guessed:
    mov dx, offset correct_psswrd

next:
    mov ah, 09h
    int 21h                         ;printing the dx string

    mov ax, 4c00h
    int 21h                         ;end the program

;_____________________________________________________;

;__HASHFUNC__
;Gets the di (address of string), cx (the length of this string) and returns its value
;Entry: CX, DI
;Exit: AX
;Destr: BX, CX, DX, DI
;_____________________________________________________;
HashFunc    proc
    push bx
    xor ax, ax

hash_sentence:
    xor bx, bx
    mov bl, ds:[di]
    inc di

    add ax, bx

    xor dx, dx
    mov bx, 100h
    div bx
    mov ax, dx                      ;ax += bx^2 (mod 100h)

    loop hash_sentence

    pop bx

    ret
    endp
;_____________________________________________________;

end	    Start
