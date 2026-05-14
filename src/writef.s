; https://coding-pepper.github.io/#writef

bits 64
%include "src/include.s"

global writef

section .text
    ; writef(file_desc=rdi, string=rsi);
    writef:
        mov rdx, 0
        push rsi
        
        _loop:
            mov al, byte [rsi]
            cmp al, 0
            je _out
            inc rdx
            inc rsi
            jmp _loop
        _out:
        pop rsi

        mov rax, 1
        syscall
        ret