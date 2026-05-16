; https://coding-pepper.github.io/#open

bits 64
%include "src/include.s"

global open
global fopen_r
global fopen_w
global close

section .text
    ; open(filename=rdi, flags=rsi, mode=rdx) file_desc=rax
    open:
        mov rax, SYS_OPEN
        syscall
        ret
    ; fopen_r(filename=rdi) file_desc=rax
    fopen_r:
        mov rsi, 0
        mov rdx, 0644o
        call open
        ret

    ; fopen_w(filename=rdi, mode=rdx) file_desc=rax
    fopen_w:
        mov rsi, 01101o
        call open
        ret
    ; close(file_desc=rdi)
    close:
        mov rax, 3
        syscall
        ret