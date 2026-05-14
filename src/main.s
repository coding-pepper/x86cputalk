bits 64
%include "src/include.s"

global _start

extern exit
extern writef

section .text
    _start:
        mov rax, 32
        push rax
        f_writef 1, msg
        f_exit 0
        ret

section .data
    msg db "num %i%hello%i%ee", 10, 0