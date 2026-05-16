bits 64
%include "src/include.s"

global _start

extern exit
extern writef
extern fopen_w
extern close
extern init_malloc

section .text
    _start:
        pop rdi ; argc
        pop rsi ; progname

        cmp rdi, 4
        je args_correct
            f_writef 1, usage
            f_exit 0
            ret
        args_correct:

        pop rax
        mov [format], rax
        pop rax
        mov [input], rax
        pop rax
        mov [output], rax

        mov rax, [output]
        push rax
        mov rax, [input]
        push rax
        mov rax, [format]
        push rax

        f_writef 1, msg
        
        f_exit 0
        ret

section .data
    format dq 0
    input dq 0
    output dq 0

    output_error db "unable to open output file for writing.", 10, 0
    usage: 
        db "usage: x86cputalk format input output", 10
        db "format:", 10
        db "   x86.raw - raw code (used for bootloaders)", 10
        db "   elf64 - elf64 object", 10
        db "   elf32 - elf32 object", 10
        db "   elf64.exe - elf64 linux program", 10
        db "   elf32.exe - elf32 linux program", 10, 0

    teststr db "bytes=%int%", 10, 0
    msg db "format=%str% input=%str% output=%str%", 10, 0