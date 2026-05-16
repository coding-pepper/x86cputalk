bits 64
%include "src/include.s"

extern brk
extern get_brk

global malloc
global init_malloc

section .text
    ; init_malloc(max_entries=rdi) status=rax
    init_malloc:
        f_get_brk
        push rax
        mov rax, 8
        mul rdi;
        mov rdi, rax ; rdi = rdi * 8
        pop rax
        add rdi, rax
        call brk

        mov [malloc_entries_ptr], rax
        ret

    ; malloc(size=rdi) address=rax
    malloc:
        ret

section .data
    malloc_entries_ptr dq 0