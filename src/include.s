SYS_WRITE equ 1
SYS_EXIT equ 60
STDOUT equ 1

%macro f_exit 1
    mov rdi, %1
    call exit
%endmacro

; writef(file_desc=rdi, string=rsi, var_argc=rdx, var_args=stack); bytes_written=rax
%macro f_writef 2
    mov rbp, rsp
    mov rdi, %1
    mov rsi, %2
    call writef
%endmacro

; memcmp(a=rdi, b=rsi, len=rdx); difference=rax
%macro f_memcmp 4
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    mov rcx, %4
    call memcmp
%endmacro