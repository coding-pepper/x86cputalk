SYS_WRITE equ 1
SYS_EXIT equ 60
STDOUT equ 1

%macro f_exit 1
    mov rdi, $0
    call exit
%endmacro