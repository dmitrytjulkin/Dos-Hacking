.model tiny
.code
org 100h

;// TODO check the carry flag if the prog hasnt opened

start:
.data
    hack_prog_name  db "S:\BIN\HACKING\getthrou.com", 0
    cmd_str         db 6, "getthou.com", 0Dh
    eg_solution     db "0000000000000000<", 0

exec_param_rec:
    env_seg     dw 0
    cmd_off    dw offset cmd_str
    cmd_seg     dw 0
    fcb_1off    dw 0
    fcb_1seg    dw 0
    fcb_2off    dw 0
    fcb_2seg    dw 0

.code
    push ds es ss sp

    mov bx, (end_prog - start + 0Fh)/10h + 10h
    mov ax, 4A00h
    int 21h                         ;shrink the memory block
                                    ;to make it available for child process

    mov cmd_seg, ds  ;setting the exec_param_rec

    mov dx, offset hack_prog_name
    push ds
    pop es
    mov bx, offset exec_param_rec   ;es:bx = execute params
    mov ax, 4B00h                   ;ds:dx = address of the program name
    int 21h                         ;execute com file

    pop sp ss es ds

    mov ax, 4c00h
    int 21h                         ;the end of prog

end_prog:
end start

