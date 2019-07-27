section .data

    MyStr db "ALEX",0   ; A null-terminating byte at the end

section .text

global _start
_start:
            nop
            mov rax,MyStr

ProcChar:   mov cl,[rax]        ; Look at the first byte of our string
            add cl,0            ; Force the zero flag if we reached a null byte
            jz Ex               ; If current byte is zero, go to Ex. Otherwise continue.
            add byte [rax],32   ; Convert an ASCII letter to uppercase
            inc rax             ; Move the string pointer to the next char
            jmp ProcChar        ; Process the next char

Ex:
            nop

section .bss
