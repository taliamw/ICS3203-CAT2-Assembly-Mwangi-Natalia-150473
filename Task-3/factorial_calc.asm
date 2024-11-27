; Factorial Calculation Program
; Computes the factorial of a number (0-12) using subroutines for modularity.

section .data
    prompt          db 'Enter a number (0-12): ', 0
    result_msg      db 'Factorial is: ', 0
    newline         db 10, 0                ; Newline character for formatting output
    input_buffer    db 10 dup(0)            ; Buffer for storing user input
    result_buffer   db 20 dup(0)            ; Buffer for the factorial result as a string

section .bss
    ; No uninitialized data for this program

section .text
global _start

_start:
    ; Display the input prompt to the user
    mov     rax, 1                  ; sys_write: write to file descriptor
    mov     rdi, 1                  ; stdout file descriptor
    mov     rsi, prompt             ; Pointer to prompt string
    mov     rdx, 22                 ; Length of the prompt message
    syscall

    ; Read input from the user
    mov     rax, 0                  ; sys_read: read from file descriptor
    mov     rdi, 0                  ; stdin file descriptor
    mov     rsi, input_buffer       ; Pointer to input buffer
    mov     rdx, 10                 ; Maximum input size (10 bytes)
    syscall

    ; Convert the user input from ASCII to integer
    mov     rsi, input_buffer       ; Pointer to input buffer
    call    atoi                    ; Result stored in RAX

    ; Validate input to ensure it's within the accepted range (0-12)
    cmp     rax, 12
    ja      invalid_input           ; Jump if number exceeds 12
    cmp     rax, 0
    jl      invalid_input           ; Jump if number is negative

    ; Calculate the factorial using the validated input
    push    rax                     ; Preserve input value on the stack
    call    factorial               ; Result stored in RAX
    add     rsp, 8                  ; Clean up the stack

    ; Convert the factorial result from integer to ASCII
    mov     rsi, result_buffer      ; Pointer to result buffer
    call    itoa                    ; Convert RAX to string format

    ; Display the result message
    mov     rax, 1                  ; sys_write: write to stdout
    mov     rdi, 1                  ; File descriptor for stdout
    mov     rsi, result_msg         ; Pointer to the result message
    mov     rdx, 14                 ; Length of the result message
    syscall

    ; Display the factorial result
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, result_buffer
    mov     rdx, 20                 ; Maximum length of the result string
    syscall

    ; Add a newline for neat formatting
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, newline
    mov     rdx, 1
    syscall

    ; Exit the program
    mov     rax, 60                 ; sys_exit system call
    xor     rdi, rdi                ; Exit status 0
    syscall

invalid_input:
    ; Handle invalid input by exiting gracefully
    mov     rax, 60                 ; sys_exit system call
    mov     rdi, 1                  ; Exit status 1 (error)
    syscall

; Factorial Subroutine
; Computes the factorial of a number using a loop.
factorial:
    mov     rbx, 1                  ; Initialize the result to 1
    cmp     rax, 0                  ; Check if input is 0
    je      factorial_end           ; Factorial of 0 is 1
factorial_loop:
    imul    rbx, rax                ; Multiply result by current value
    dec     rax                     ; Decrement the counter
    jnz     factorial_loop          ; Repeat until counter reaches 0
factorial_end:
    mov     rax, rbx                ; Return the result in RAX
    ret

; ASCII-to-Integer Conversion Subroutine (atoi)
; Converts a numeric string to its integer representation.
atoi:
    xor     rax, rax                ; Clear RAX (result accumulator)
    xor     rcx, rcx                ; RCX will hold the multiplier (10)
    mov     rcx, 10

atoi_loop:
    movzx   rdx, byte [rsi]         ; Load next character as unsigned
    cmp     rdx, 10                 ; Check for newline
    je      atoi_done
    sub     rdx, '0'                ; Convert ASCII to numeric value
    imul    rax, rcx                ; Multiply result by 10
    add     rax, rdx                ; Add the digit to the result
    inc     rsi                     ; Move to the next character
    jmp     atoi_loop

atoi_done:
    ret

; Integer-to-ASCII Conversion Subroutine (itoa)
; Converts an integer to its ASCII string representation.
itoa:
    xor     rcx, rcx                ; Counter for the number of digits
itoa_loop:
    xor     rdx, rdx                ; Clear RDX (remainder)
    mov     rbx, 10                 ; Divisor
    div     rbx                     ; Divide RAX by 10, quotient in RAX
    add     dl, '0'                 ; Convert remainder to ASCII
    push    rdx                     ; Push ASCII character onto the stack
    inc     rcx                     ; Increment digit count
    test    rax, rax                ; Check if quotient is zero
    jnz     itoa_loop

itoa_pop:
    pop     rdx                     ; Retrieve the character from the stack
    mov     [rsi], dl               ; Store it in the result buffer
    inc     rsi                     ; Move buffer pointer
    loop    itoa_pop

    mov     byte [rsi], 0           ; Null-terminate the string
    ret