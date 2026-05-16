bits 64
%include "src/include.s"

global fread

section .text
    ; fread(file_desc=rdi) pointer_to_file=rax
    fread:
        ret