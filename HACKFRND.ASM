.model tiny
.code
org 100h

;// TODO check the carry flag if the prog hasnt opened

start:
.data
    eg_solution     db "0000000000000000<", 0Dh, "$"
    eg_ans          db "Heisenburger        $"

hack_sequence_phrase:
    rand_ans        db BUF_LEN dup(?), "$"
    necces_to_print db "you god dame right$", "get out!!$ "
    hack_phrase     dw 0EB28h
    end_of_seq      db 0Dh
    SEQ_LEN         equ $ - hack_sequence_phrase
    BUF_LEN         equ 14h

.code
    mov si, offset eg_ans
    mov di, offset rand_ans
    mov cx, BUF_LEN
    rep movsb                       ;copying certain phrase into buffer space

    mov dx, offset hack_sequence_phrase
    mov bx, 1
    mov cx, SEQ_LEN
    mov ah, 40h
    int 21h                         ;printing hacking sequence

    mov ax, 4c00h
    int 21h                         ;the end of prog

end start
