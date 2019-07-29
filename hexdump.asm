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

    UPPER4 equ 11110000b
    LOWER4 equ 00001111b

    DIGITS db "0123456789ABCDEF"

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

            add rcx, rax            ; Move past the last read byte

ProcNext:   dec rcx                 ; Move pointer to the next byte (left)
            dec rax

            ; Converts the current byte to 2 hex digits and stores them in the buffer:
ProcFirst4: mov bl, [rcx]           ; An 8-bit register is enough for our single byte
            and bl, LOWER4          ; We zero-out the upper 4 bits for now

            mov bl, [DIGITS + rbx]  ; Convert the first nybble to a HEX digit
            mov [rcx + rax + 1], bl ;   ...and write it to the buffer!

ProcNext4:  mov bl, [rcx]           ; Now load our byte again in BL
            and bl, UPPER4          ;    ...but this time mask the lower 4 bits
            shr bl, 4               ;       ...and move the first 4 into the second 4

            mov bl, [DIGITS + rbx]  ; Convert the second nybble to a HEX digit
            mov [rcx + rax], bl     ; and write it to the buffer!

SwitchNext: cmp rax, 0              ; Check if we reached the beginning:
            jne ProcNext            ;       if so - repeat.

Print:      mov rax, 4              ; Prepare a sys_write call
            mov rbx, 1              ;                 ...to STDOUT
                                    ; RCX already points to Buffer because we iterate leftwards
            shl rdx, 1              ; And RDX must be doubled because the buffer is twice as long

            int 80h                 ; Fire!

            jmp Read                ; The old buffer was printed. Read a new one!

Exit:       mov rax,1               ; Prepare to call sys_exit
            mov rbx,0               ; ... with exit code 0
            int 80h                 ; Fire!
