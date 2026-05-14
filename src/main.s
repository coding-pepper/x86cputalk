bits 64
%include "src/include.s"

global _start

extern exit

section .text
_start:

    f_exit 0
    ret