; Note that the frist 30 and the last 20 lines are literally copied from upcase.asm
; Maybe I should make a function in a separate file (when I learn how to do it)

; The difference is that here I'm iterating the buffer backwards, because for a single
; byte in the input I produce two bytes in the output.

; This means that if I proceed from left to right, I'll corrupt the input.
; E.g. if I read the first byte, I'll write to both the first and the second byte.
; Therefore I start at the end of the input buffer and move leftwards.
; I first read the Nth byte and write the result at bytes 2N-1 and 2N.

section .data

section .rodata

    BUFFER_LENGTH equ 100

section .bss

    Buffer: resb BUFFER_LENGTH * 2

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
            add rcx, rax - 1        ; Move to the last read byte

            ; Converts the current byte to 2 hex digits and stores them in the buffer:
ProcNext:                           ;

SwitchNext: dec rcx                 ; Move pointer to the next byte (left)
            dec rax                 ; Check if we reached the end:
            jnz ProcNext            ;       if so - repeat.

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
