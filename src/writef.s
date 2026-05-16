; https://coding-pepper.github.io/#writef

bits 64
%include "src/include.s"

extern memcmp

global writef

section .text
    ; writef(file_desc=rdi, string=rsi, var_args=stack) bytes_written=rax
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
            mov rax, SYS_WRITE
            mov rdi, r8
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
            cmp r9, 0
            jne do_format_shit
                mov rax, SYS_WRITE
                mov rdi, r8
                mov rsi, _modulo
                mov rdx, 1
                syscall 
                add qword [_result], rdx

                jmp finish_format
            do_format_shit:
            f_memcmp qword [print_segment_address], _f_i32, r9, 3
            cmp rax, 0
            jne _not_i32
                ; if format is i32
                mov rax, 0
                _loop_clean:
                    mov byte [_int_any_32_chardigits + rax], 0
                    inc rax
                    cmp rax, 39
                    jne _loop_clean

                ; retrieve arg into rsi
                mov r9, rsp
                mov rsp, rbp
                pop rsi
                mov rbp, rsp
                mov rsp, r9

                cmp rsi, 0
                jg _not_negative
                    push rsi
                    mov rax, SYS_WRITE
                    mov rdi, r8
                    mov rsi, _minus
                    mov rdx, 1
                    syscall
                    pop rsi
                    neg rsi
                    add qword [_result], 1
                _not_negative:

                mov r9, 38

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

                mov rax, SYS_WRITE
                mov rdi, r8
                mov rsi, _int_any_32_chardigits
                add rsi, r9
                mov rdx, 39
                sub rdx, r9
                syscall
                add qword [_result], rdx

                jmp finish_format

            _not_i32:

            f_memcmp qword [print_segment_address], _f_ui32, r9, 4
            cmp rax, 0
            jne _not_ui32
                ; if format is ui32
                mov rax, 0
                _loop_clean2:
                    mov byte [_int_any_32_chardigits + rax], 0
                    inc rax
                    cmp rax, 39
                    jne _loop_clean2

                ; retrieve arg into rsi
                mov r9, rsp
                mov rsp, rbp
                pop rsi
                mov rbp, rsp
                mov rsp, r9

                mov r9, 38

                mov rax, rsi
                
                _fill_chars2:
                    xor rdx, rdx
                    mov rbx, 10
                    div rbx ; rax = rsi / 10 rdx = rsi % 10
                    add dl, 48
                    mov byte [_int_any_32_chardigits+r9], dl
                    cmp rax, 0
                    je _out_fill_chars2
                    dec r9
                    cmp r9, 0
                    jl _out_fill_chars2
                    jmp _fill_chars2
                _out_fill_chars2:

                mov rax, SYS_WRITE
                mov rdi, r8
                mov rsi, _int_any_32_chardigits
                add rsi, r9
                mov rdx, 39
                sub rdx, r9
                syscall
                add qword [_result], rdx

                jmp finish_format

            _not_ui32:

            f_memcmp qword [print_segment_address], _f_s, r9, 3
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

                add qword [_result], rdx

                mov rax, SYS_WRITE
                mov rdi, r8
                syscall
                jmp finish_format
            _not_s:

            f_memcmp qword [print_segment_address], _f_c, r9, 4
            cmp rax, 0
            jne _not_char
                ; retrieve arg into rsi
                mov rdx, 0
                mov r9, rsp
                mov rsp, rbp
                pop rsi
                mov rbp, rsp
                mov rsp, r9

                mov qword [_char], rsi

                mov rax, SYS_WRITE
                mov rdi, r8
                mov rsi, _char
                mov rdx, 1
                add qword [_result], rdx
                syscall
                jmp finish_format

            _not_char:

            f_memcmp qword [print_segment_address], _f_p, r9, 3
            cmp rax, 0
            jne _not_ptr
                ; if format is ptr
                mov rax, 0
                _loop_clean3:
                    mov byte [_skibidi_hex_bullshit + rax], 0
                    inc rax
                    cmp rax, 16
                    jne _loop_clean3

                ; retrieve arg into rsi
                mov r9, rsp
                mov rsp, rbp
                pop rsi
                mov rbp, rsp
                mov rsp, r9

                mov r9, 15

                mov rax, rsi
                
                _fill_chars3:
                    xor rdx, rdx
                    mov rbx, 16
                    div rbx ; rax = rsi / 16 rdx = rsi % 16
                    cmp dl, 10
                    jge letter
                        add dl, 48
                        jmp not_letter
                    letter:
                        add dl, 55
                    not_letter:

                    mov byte [_skibidi_hex_bullshit+r9], dl
                    cmp rax, 0
                    je _out_fill_chars3
                    dec r9
                    cmp r9, 0
                    jl _out_fill_chars3
                    jmp _fill_chars3
                _out_fill_chars3:

                mov rax, SYS_WRITE
                mov rdi, r8
                mov rsi, _hex
                mov rdx, 2
                syscall

                mov rax, SYS_WRITE
                mov rdi, r8
                mov rsi, _skibidi_hex_bullshit
                add rsi, r9
                mov rdx, 16
                sub rdx, r9
                syscall

                add qword [_result], rdx
                add qword [_result], 2

                jmp finish_format

            _not_ptr:

            finish_format:
            pop rsi
            pop rdx
            pop rdi
            pop r9
            inc rsi
            mov qword [print_segment_address], rsi

            jmp _loop2
        _strend:
            mov rax, SYS_WRITE
            mov rdx, rsi
            mov rsi, [print_segment_address]
            sub rdx, rsi
            mov rdi, r8
            syscall
            add qword [_result], rdx
            mov rax, qword [_result]

            pop r8
            ret

        _out2:

        pop r8
        mov rax, qword [_result]
        ret

section .data
    _var_argc dq 0
    _result dq 0
    print_segment_address dq 0
    _parse db 0

    _minus db '-'
    _int_any_32_chardigits:
        times 39 db 0
    _skibidi_hex_bullshit:
        times 16 db 0

    _f_i32 db "int"
    _f_ui32 db "uint"

    _f_s db "str"
    _f_c db "char"
    _f_f db "float"
    _f_p db "ptr"

    _hex db '0x'
    _char dq 0
    _modulo db '%'