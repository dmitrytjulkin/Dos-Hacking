.model tiny
.code
org 100h

VIDEOSEG        equ 0b800h
INP_ADDR        equ 82h
INP_LEN_ADDR    equ 80h
MAX_BUF_LEN     equ 0A0h


start:
.code
    mov dx, offset extra_phrase
    mov ah, 09h
    int 21h

    mov dx, offset max_len
    mov ah, 0ah
    int 21h                         ;saving input string in buffer

    xor cx, cx
    mov dx, offset buffer
    mov di, dx
    mov cl, strlen
    call HashFunc                   ;receiving hash of input
    mov bx, ax

    mov dx, offset psswrd
    mov di, dx
    mov cl, 6d
    call HashFunc                   ;receiving hash of psswrd

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

;__DATA__
BUF_SET_UP:
    max_len     db MAX_BUF_LEN
    strlen      db 0
    buffer      db MAX_BUF_LEN dup(0)

MY_PSSWRD:
    psswrd      db "012345$"

RESPOND:
    correct_psswrd   db "You're goddamn right (access granted)$"
    incorrect_psswrd db "Go Home, Walter (access denied)$"
    extra_phrase     db "Say my name$"


end	    Start
