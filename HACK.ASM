.model tiny
.code
org 100h

VIDEOSEG        equ 0b800h
INP_ADDR        equ 82h
INP_LEN_ADDR    equ 80h
MAX_BUF_LEN     equ 0A0h


start:
.data
BUF_SET_UP:
    max_len     db MAX_BUF_LEN
    strlen      db 0
    buffer      db MAX_BUF_LEN dup(0)

.code
    mov dx, offset max_len
    mov ah, 0ah
    int 21h

    push VIDEOSEG
    pop es

    call HashFunc
    mov ah, 70h
    mov es:[00], ax

;    mov dx, offset buffer
;    mov ah, 09h
;    int 21h

    mov ax, 4c00h
    int 21h

;_____________________________________________________;

;__HASHFUNC__
;Gets the dx = address of string, cx = the length of this string and returns its value
;Entry: CL
;Exit: AX
;Destr: BX, CX, DX, DI
;_____________________________________________________;
HashFunc    proc
    mov cl, strlen

hash_sentence:
    mov di, cx
    dec di
    mov bl, buffer[di]

    add ax, bx

    xor dx, dx
    mov bx, 100h
    div bx
    mov ax, dx                      ;ax += bx^2 (mod 100h)

    loop hash_sentence

    ret
    endp
;_____________________________________________________;

end	    Start
