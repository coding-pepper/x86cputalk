bits 64
%include "src/include.s"

global _start

extern exit
extern writef

section .text
    _start:
        mov r10, 45
        push r10
        mov r10, name2
        push r10
        mov r10, name
        push r10
        f_writef 1, msg
        f_exit 0
        ret

section .data
    name db "John", 0
    name2 db "Kenny", 0
    msg db "Hello, %s% and %s%.", 10, "num = %i32%", 10, 0