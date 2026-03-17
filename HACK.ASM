.model tiny
.code
org 100h

VIDEOSEG     equ 0b800h
INP_ADDR     equ 82h
INP_LEN_ADDR equ 80h


Start:
    push VIDEOSEG
    pop es

    call HashFunc
    mov ah, 70h
    mov es:[00], ax

    mov ax, 4c00h
    int 21h

;_____________________________________________________;
;__HASHFUNC__
;Gets the string from the input and returns its value
;Entry:
;Exit: AX
;Destr: BX, CX, DX, DI
;_____________________________________________________;
HashFunc    proc
    mov cl, ds:[INP_LEN_ADDR]
    dec cl                  ;cx = len(input)

looper:
    mov di, cx
    mov bx, ds:[INP_ADDR + di]

    push ax
    mov ax, bx
    mul bx
    mov bx, ax
    pop ax

    add ax, bx

    mov dx, 100h
    div dx
    mov ax, dx              ;ax += bx^2 (mod 100h)

    loop looper

    ret
    endp

password db 1012 dup(0)

end	Start
