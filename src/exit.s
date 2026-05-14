bits 64
%include "src/include.s"

global exit

section .text
    exit:
        mov rax, SYS_EXIT
        syscall
        ret