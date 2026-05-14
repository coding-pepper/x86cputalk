; https://coding-pepper.github.io/#writef

bits 64
%include "src/include.s"

global writef

section .text
    ; writef(file_desc=rdi, string=rsi, len=rdx);
    writef:
        mov rax, 1
        syscall
        ret