section .data

section .bss

    BUFFER_LENGTH equ 100
    Buffer: resb BUFFER_LENGTH

section .text

global _start
_start:
    nop

        mov rsi, 0              ; Keep the full msg length in RSI

Read:   mov rax, 3              ; Will do sys_read!
        mov rbx, 0              ; From STDIN!
        mov rcx, Buffer         ; Into our buffer
        mov rdx, BUFFER_LENGTH  ; With this length

        int 80h                 ; Fire!

        add rsi, rax    ; Keep the full message length in ESI
        cmp rax, 0      ; Check if at EOF?
        je Print        ; If no more input, exit!

        mov rbx, rax    ; Set the current buffer's length in RBX
        mov rax, Buffer ; Use RAX as a pointer to the buffer

Process:    ; Check if current byte is within a..z:
            cmp byte [rax], 'a' 
            jl Next
            cmp byte [rax], 'z'
            jg Next

            inc byte [rax]  ; Modify current byte

Next:       inc rax         ; Move to the next byte
            dec rbx         ; 
            jnz Process
            jmp Read

Print:      ;mov rcx, rax    ; Move the message to RCX
            mov rdx, rsi    ; Move the length to RDX
            mov rax, 4      ; Prepare a sys_write
            mov rbx, 1      ;   ...to STDOUT
            int 80h         ; Fire!

Exit:       mov rax,1       ; Prepare to call sys_exit
            mov rbx,0       ; ... with exit code 0
            int 80h         ; Fire!

