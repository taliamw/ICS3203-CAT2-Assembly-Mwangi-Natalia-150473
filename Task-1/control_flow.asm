; This program takes a number as input and tells you whether it's POSITIVE, NEGATIVE, or ZERO.
; A simple tool to practice assembly while understanding control flow.

section .data
    prompt db "Hey! Enter a number: ", 0 ; Custom input prompt
    positive_msg db "Your number is POSITIVE", 0
    negative_msg db "Your number is NEGATIVE", 0
    zero_msg db "It's a ZERO!", 0

section .bss
    num resb 10  ; Space for the input number (up to 10 characters including '\n')

section .text
    global _start

_start:
    ; Say hello and ask for a number
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; stdout
    mov ecx, prompt       ; Display the prompt
    mov edx, 22           ; Prompt length
    int 0x80              ; Call kernel

    ; Read the input
    mov eax, 3            ; syscall: sys_read
    mov ebx, 0            ; stdin
    mov ecx, num          ; Buffer to store input
    mov edx, 10           ; Max bytes to read
    int 0x80              ; Call kernel

    ; Turn input into an integer
    mov esi, num          ; Pointer to the input buffer
    xor eax, eax          ; Reset accumulator for the number
    xor ebx, ebx          ; Clear sign flag

input_to_int:
    movzx edx, byte [esi] ; Load a single character
    cmp dl, 0x2D          ; Check for '-'
    je set_negative       ; Handle negative sign
    cmp dl, 0x30          ; Check if >= '0'
    jl end_input          ; Stop if invalid character
    cmp dl, 0x39          ; Check if <= '9'
    jg end_input          ; Stop if invalid character

    sub dl, 0x30          ; Convert ASCII digit to integer
    imul eax, eax, 10     ; Shift existing number left
    add eax, edx          ; Add new digit
    inc esi               ; Move to the next character
    jmp input_to_int      ; Loop to process next character

set_negative:
    mov bl, 1             ; Set negative flag
    inc esi               ; Skip '-'
    jmp input_to_int

end_input:
    cmp bl, 0             ; Was the number negative?
    je classify           ; No, skip negation
    neg eax               ; Yes, negate the number

; Let's classify the number
classify:
    cmp eax, 0            ; Compare the number to zero
    je is_zero            ; If zero, handle it
    jl is_negative        ; If less than zero, handle it
    jmp is_positive       ; Otherwise, it's positive

is_zero:
    mov ecx, zero_msg     ; Point to "ZERO" message
    jmp display_result

is_negative:
    mov ecx, negative_msg ; Point to "NEGATIVE" message
    jmp display_result

is_positive:
    mov ecx, positive_msg ; Point to "POSITIVE" message

; Display the result
display_result:
    mov eax, 4            ; syscall: sys_write
    mov ebx, 1            ; stdout
    mov edx, 23           ; Max length for any message
    int 0x80              ; Call kernel

    ; Say goodbye and exit
    mov eax, 1            ; syscall: sys_exit
    xor ebx, ebx          ; Exit code 0
    int 0x80