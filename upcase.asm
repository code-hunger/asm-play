section .data

section .rodata

    BUFFER_LENGTH equ 100

section .bss

    Buffer: resb BUFFER_LENGTH

section .text

global _start
_start:
    nop

Read:       mov rax, 3              ; Will do sys_read!
            mov rbx, 0              ; From STDIN!
            mov rcx, Buffer         ; Into our buffer
            mov rdx, BUFFER_LENGTH  ; With this length

            int 80h                 ; Fire!

            cmp rax, 0              ; Check if at EOF?
            je Exit                 ; If no more input, exit!
            mov rdx, rax            ; Keep a copy of the length of the buffer in RDX

CheckRange: cmp byte [rcx], 'a'     ; If byte is out of range, no need for uppercasing.
            jl SwitchNext           ; Equivalent to:
            cmp byte [rcx], 'z'     ; if rcx < 'a' or rcx > 'z'
            jg SwitchNext           ;     SwitchNext            

ModifyByte: sub byte [rcx], 32      ; Convert to uppercase

SwitchNext: inc rcx                 ; Move pointer to the next byte
            dec rax                 ; Check if we reached the end:
            jnz CheckRange          ;       if so - repeat.

Print:      mov rax, 4              ; Prepare a sys_write call
            mov rbx, 1              ;                 ...to STDOUT

            ; Note that the following can also be done with 'sub rcx, rdx' 
            ; because currently RCX points right after the end of the buffer.
            mov rcx, Buffer         ; The message being our buffer,
                                    ;   ...it's length is already in RDX

            int 80h                 ; Fire!

            jmp Read                ; The old buffer was printed. Read a new one!

Exit:       mov rax,1               ; Prepare to call sys_exit
            mov rbx,0               ; ... with exit code 0
            int 80h                 ; Fire!
