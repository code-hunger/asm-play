section .data

            MyStr db "Alex rocks!!..",0   ; A null-terminating byte at the end

section .text

global _start
_start:
            nop
            mov rax, MyStr  ; The text is in RAX
            mov rdx, rax    ; Keep a copy of the message start in RDX
            mov rbx, 0      ; The length is in RBX

ProcChar:   mov cl, [rax]   ; Look at the first byte of our string
            cmp cl, 0       ; Check if our byte is zero:
            je Print        ;       in that case, finish.

            ; If the value is out of A..Z, skip to the next char:
            cmp cl, 'a'         ; Compare with 'A':
            jl Next             ;   if less, skip it.
            cmp cl, 'z'         ; Compare with 'Z':
            jg Next             ;   if bigger, skip it as well.
            sub byte [rax], 32d ; Otherwise, convert an ASCII letter to lowercase

Next:       inc rax             ; Move the string pointer to the next char
            inc rbx             ; Increment the string length
            jmp ProcChar        ; Process the next char

Print:      mov byte [rax], 10  ; Add a newline to the end
            inc rbx             ; And update the length respectfully

            ; Now RAX points to the end of the string. The start is still in RDX.
            mov rcx, rdx    ; Move our message from RDX to RCX 
            mov rdx, rbx    ; Move the message length to RDX
            mov eax, 4      ; Specify a sys_write call
            mov ebx, 1      ; ... to stdout
            int 80h         ; Fire!

Exit:       mov rax,1   ; Prepare to call sys_exit
            mov rbx,0   ; ... with exit code 0
            int 80h     ; Fire!

section .bss
