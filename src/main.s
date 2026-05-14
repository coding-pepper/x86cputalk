bits 64
%include "src/include.s"

global _start

extern exit
extern writef

section .text
    _start:
        f_writef 1, msg, 14
        f_exit 0
        ret

section .data
    msg db "Hello, world!", 10