section .data

    MyStr db "ALEX",0   ; A null-terminating byte at the end

section .text

global _start
_start:
            nop
            mov rax,MyStr

ProcChar:   mov cl,[rax]        ; Look at the first byte of our string
            cmp cl,0            ; Check if our byte is zero:
            je Exit             ;       in that case, finish.
            add byte [rax],32   ; Convert an ASCII letter to uppercase
            inc rax             ; Move the string pointer to the next char
            jmp ProcChar        ; Process the next char

Exit:
            mov rax,1   ; Prepare to call sys_exit
            mov rbx,0   ; with exit code 0
            int 80h     ; Fire!

section .bss
