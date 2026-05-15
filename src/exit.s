; https://coding-pepper.github.io/#exit

bits 64
%include "src/include.s"

global exit

section .text
    ; exit(exit_code=rdi)
    exit:
        mov rax, SYS_EXIT
        syscall
        ret