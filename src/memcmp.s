; https://coding-pepper.github.io/#memcmp

bits 64
%include "src/include.s"

global memcmp

section .text
    ; memcmp(a=rdi, b=rsi, len_a=rdx, len_b=rcx) difference=rax
    memcmp:
        mov rax, 0
        cmp rdx, rcx
        jne _lenmiss

        push r9
        mov r9, 0
        _loop:
            mov dl, byte [rdi]
            mov bl, byte [rsi]
            cmp dl, bl
            je _next

            inc rax

            _next:
            inc rdi
            inc rsi
            inc r9
            cmp r9, rdx
            je _out
            cmp r9, rcx
            je _out

            jmp _loop

        _lenmiss:
            mov rax, 1
            ret
        _out:

        pop r9
        ret