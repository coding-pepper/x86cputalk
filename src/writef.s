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

        push r8
        mov r8, rdi

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
            f_memcmp qword [print_segment_address], _f_i32, r9, 3
            cmp rax, 0
            jne _not_i32
                ; if format is i32
                mov rax, 0
                _loop_clean:
                    mov byte [_int_any_32_chardigits + rax], 0
                    inc rax
                    cmp rax, 10
                    jne _loop_clean

                ; retrieve arg into rsi
                mov r9, rsp
                mov rsp, rbp
                pop rsi
                mov rbp, rsp
                mov rsp, r9

                cmp rsi, 0
                mov r10, 0
                jg _not_negative
                    push rsi
                    mov rax, 1
                    mov rdi, r8
                    mov rsi, _minus
                    mov rdx, 1
                    syscall
                    pop rsi
                    neg rsi
                _not_negative:

                mov r9, 9

                mov rax, rsi
                
                _fill_chars:
                    xor rdx, rdx
                    mov rbx, 10
                    div rbx ; rax = rsi / 10 rdx = rsi % 10
                    add dl, 48
                    mov byte [_int_any_32_chardigits+r9], dl
                    cmp rax, 0
                    je _out_fill_chars
                    dec r9
                    cmp r9, 0
                    jl _out_fill_chars
                    jmp _fill_chars
                _out_fill_chars:

                mov rax, 1
                mov rdi, r8
                mov rsi, _int_any_32_chardigits
                add rsi, r9
                mov rdx, 10
                sub rdx, r9
                syscall

                jmp finish_format

            _not_i32:

            f_memcmp qword [print_segment_address], _f_ui32, r9, 4
            cmp rax, 0
            jne _not_ui32
                ; if format is ui32
                jmp finish_format
            _not_ui32:

            f_memcmp qword [print_segment_address], _f_s, r9, 1
            cmp rax, 0
            jne _not_s
                ; if format is string
                ; retrieve arg into rsi
                mov rdx, 0
                mov r9, rsp
                mov rsp, rbp
                pop rsi
                mov rbp, rsp
                mov rsp, r9
                mov r9, rsi

                _loop3:
                    mov al, byte [r9]
                    cmp al, 0
                    je _out3
                    inc rdx
                    inc r9
                    jmp _loop3
                _out3:

                mov rax, 1
                mov rdi, r8
                syscall
                jmp finish_format
            _not_s:

            finish_format:
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

            pop r8
            ret

        _out2:

        pop r8
        ret

section .data
    _var_argc dq 0
    _result dq 0
    print_segment_address dq 0
    _parse db 0

    _minus db '-'
    _int_any_32_chardigits db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

    _f_i8 db "i8"
    _f_i16 db "i16"
    _f_i32 db "i32"
    _f_i64 db "i64"
    _f_i128 db "i128"

    _f_ui8 db "ui8"
    _f_ui16 db "ui16"
    _f_ui32 db "ui32"
    _f_ui64 db "ui64"
    _f_ui128 db "ui128"

    _f_s db "s"
    _f_c db "c"
    _f_f db "f"
    _f_p db "p"

    __dbg db "Ja"