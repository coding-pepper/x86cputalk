bits 64
%include "src/include.s"

global brk
global get_brk

section .text
    ; brk(address=rdi) (address == 0 ? address_of_brk : status)=rax
    brk:
        mov rax, SYS_BRK
        syscall
        ret

    ; get_brk() address_of_brk=rax
    get_brk:
        mov rax, SYS_BRK
        mov rdi, 0
        syscall
        ret