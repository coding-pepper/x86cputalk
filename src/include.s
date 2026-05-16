SYS_WRITE equ 1
SYS_OPEN equ 2
SYS_BRK equ 12
SYS_EXIT equ 60
STDOUT equ 1

; exit(exit_code=rdi)
%macro f_exit 1
    mov rdi, %1
    call exit
%endmacro

; writef(file_desc=rdi, string=rsi, var_argc=rdx, var_args=stack) bytes_written=rax
%macro f_writef 2
    mov rbp, rsp
    mov rdi, %1
    mov rsi, %2
    call writef
%endmacro

; memcmp(a=rdi, b=rsi, len=rdx) difference=rax
%macro f_memcmp 4
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    mov rcx, %4
    call memcmp
%endmacro

; open(filename=rdi, flags=rsi, mode=rdx) file_desc=rax
%macro f_open 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    call open
%endmacro

; fopen_r(filename=rdi) file_desc=rax
%macro f_fopen_r 1
    mov rdi, %1
    call fopen_r
%endmacro

; fopen_w(filename=rdi, mode=rdx) file_desc=rax
%macro f_fopen_w 2
    mov rdi, %1
    mov rdx, %2
    call fopen_w
%endmacro

; close(file_desc=rdi)
%macro f_close 1
    mov rdi, %1
    call close
%endmacro

; fread(file_desc=rdi) pointer_to_file=rax
%macro f_fread 1
    mov rdi, %1
    call fread
%endmacro

; brk(address=rdi) (address == 0 ? address_of_brk : status)=rax
%macro f_brk 1
    mov rdi, %1
    call brk
%endmacro

; get_brk() address_of_brk=rax
%macro f_get_brk 0
    call get_brk
%endmacro

; init_malloc(max_entries=rdi) status=rax
%macro f_init_malloc 1
    mov rdi, %1
    call init_malloc
%endmacro