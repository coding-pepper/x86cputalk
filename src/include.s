SYS_WRITE equ 1
SYS_EXIT equ 60
STDOUT equ 1

%macro f_exit 1
    mov rdi, %1
    call exit
%endmacro

%macro f_writef 2
    mov rdi, %1
    mov rsi, %2
    call writef
%endmacro