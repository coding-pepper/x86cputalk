bits 64
%include "src/include.s"

global fread

extern get_brk
extern brk

ALLOC_SIZE equ 128
section .text
    ; fread(file_desc=rdi) pointer_to_file=rax
    fread:
        push r10
        push rdi
        push rsi
        push rdx

        mov qword [fd], rdi

        loop:
            mov r10, qword [buffer_capacity]
            cmp r10, 0
            jne no_alloc
                call get_brk
                cmp qword [begin_buffer], 0
                jne not_first_alloc
                    mov qword [begin_buffer], rax
                    mov qword [begin_buffer_inc], rax
                    jmp cont
                not_first_alloc:
                cont:
                mov rdi, rax
                add qword [buffer_capacity], ALLOC_SIZE
                add rdi, ALLOC_SIZE
                call brk
                cmp rax, 0
                jne no_alloc
                error:
                    pop rdx
                    pop rsi
                    pop rdi
                    pop r10
                    mov rax, 0
                    ret
            no_alloc:
            mov rax, SYS_READ
            mov rdi, qword [fd]
            mov rsi, qword [begin_buffer_inc]
            mov rdx, qword [buffer_capacity]
            syscall
            add qword [begin_buffer_inc], rax
            cmp rax, 0 ; eof
            je out
            jg cont2
                r_err:
                ;read error
                pop rdx
                pop rsi
                pop rdi
                pop r10
                mov rax, 1
                ret
            cont2:
            sub qword [buffer_capacity], rax
            jmp loop
        out:
        pop rdx
        pop rsi
        pop rdi
        pop r10
        mov rax, qword [begin_buffer]
        ret

section .data
    fd dq 0
    begin_buffer_inc dq 0
    begin_buffer dq 0
    buffer_capacity dq 0