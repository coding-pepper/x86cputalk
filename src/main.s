bits 64
%include "src/include.s"

global _start

extern exit
extern writef
extern fopen_w
extern fopen_r
extern fread
extern close
extern init_malloc

section .text
    _start:
        pop rdi ; argc
        pop rsi ; progname

        cmp rdi, 3
        je args_correct
            f_writef 1, usage
            f_exit 0
            ret
        args_correct:

        pop rax
        mov [input], rax
        pop rax
        mov [output], rax

        mov rax, [output]
        push rax
        mov rax, [input]
        push rax

        f_writef 1, msg
        
        f_fopen_r [input]
        cmp rax, 0
        jg input_file_ok
            f_writef 1, msg2_2
            f_writef 1, msg_abort
            f_exit 0
            ret

        input_file_ok:
        mov r12, rax

        f_writef 1, msg2
        f_fread r12
        cmp rax, 1
        jg success
            f_exit 1
        success:
        mov qword [input_addr], rax
        push rax
        f_writef 1, string
        f_exit 0
        ret

section .data
    format dq 0
    input dq 0
    output dq 0

    input_addr dq 0
    output_error db "unable to open output file for writing.", 10, 0
    usage: 
        db "usage: x86cputalk format input output", 10
        db "format:", 10
        db "   x86.raw - raw code (used for bootloaders)", 10
        db "   elf64 - elf64 object", 10
        db "   elf32 - elf32 object", 10
        db "   elf64.exe - elf64 linux program", 10
        db "   elf32.exe - elf32 linux program", 10, 0

    string db "%str%", 10, 0
    teststr db "addr=%ptr% size=%int%", 10, 0
    msg db 27, "[1;36m[info]", 27, "[0m compiling %str% to %str%", 10, 0
    msg2 db 27, "[1;32m[success]", 27, "[0m opened input file for reading", 10, 0
    msg2_2 db 27, "[1;31m[fail]", 27, "[0m failed to open input file for reading", 10, 0
    msg_abort db 27, "[1;31mabort.", 27, "[0m", 10, 0