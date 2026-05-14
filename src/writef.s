; https://coding-pepper.github.io/#writef

bits 64
%include "src/include.s"

extern memcmp

global writef

section .text
    ; writef(file_desc=rdi, string=rsi, var_args=stack); bytes_written=rax
    writef:
        mov qword [_result], 0
        mov qword [print_segment_address], 0
        mov byte  [_parse], 0
        mov qword [_var_argc], rdx

        mov rdx, 0
        push rsi

        _loop:
            mov al, byte [rsi]
            cmp al, 0
            je _out
            inc rdx
            inc rsi
            jmp _loop
        _out:
        pop rsi

        mov qword [print_segment_address], rsi
        _loop2:
            mov al, byte [rsi]
            cmp al, 0
            je _strend

            cmp al, '%'
            je _procent

            inc rsi
            jmp _loop2
        _procent:
            mov al, byte [_parse]
            cmp al, 0
            jne _got_format

            ; print things before %
            mov rax, 1
            mov rdx, rsi ; next 4 lines calculate lenght of print into rdx
            push rsi
            mov rsi, [print_segment_address]
            sub rdx, rsi
            syscall
            add qword [_result], rdx

            ; restore rsi
            pop rsi
            inc rsi

            ; set new base
            mov qword [print_segment_address], rsi

            mov byte [_parse], 1
            jmp _loop2
        _got_format:
            mov byte [_parse], 0

            ; print_segment_address:rsi - format string
            push r9
            push rdi
            push rdx
            push rsi
            mov rdx, rsi
            mov rsi, [print_segment_address]
            sub rdx, rsi

            mov r9, rdx
            f_memcmp qword [print_segment_address], _f_i, r9, 1
            cmp rax, 0
            jne _not_i
            ; if format is i
            mov rax, 1
            mov rdi, 1
            mov rdx, 2
            mov rsi, __dbg
            syscall

            _not_i:

            pop rsi
            pop rdx
            pop rdi
            pop r9
            inc rsi
            mov qword [print_segment_address], rsi

            jmp _loop2
        _strend:
            mov rax, 1
            mov rdx, rsi
            mov rsi, [print_segment_address]
            sub rdx, rsi
            syscall
            add qword [_result], rdx
            mov rax, qword [_result]
            ret

        _out2:

        ret

section .data
    _var_argc dq 0
    _result dq 0
    print_segment_address dq 0
    _parse db 0

    _f_i db "i"
    __dbg db "Ja"