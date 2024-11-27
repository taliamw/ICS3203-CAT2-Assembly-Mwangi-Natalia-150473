; Array Reversal Program
; Reads five single-digit integers from the user, reverses their order, and outputs the reversed array.

section .data
    prompt db "Enter five single digits separated by spaces (e.g., 1 2 3 4 5): ", 0
    prompt_len equ $ - prompt
    newline db 10, 0                 ; Line break for output formatting
    invalid_input_msg db "Invalid input! Please try again.", 0
    invalid_input_len equ $ - invalid_input_msg

section .bss
    input resb 16      ; Buffer for user input (up to 16 characters, including spaces and '\n')
    array resb 5       ; Space to store the 5 digits as characters

section .text
    global _start

_start:
    ; Display the prompt to the user
input_prompt:
    mov rax, 1              ; syscall: sys_write
    mov rdi, 1              ; file descriptor: stdout
    mov rsi, prompt         ; Address of the prompt string
    mov rdx, prompt_len     ; Length of the prompt
    syscall

    ; Read input from the user
    mov rax, 0              ; syscall: sys_read
    mov rdi, 0              ; file descriptor: stdin
    mov rsi, input          ; Address of the input buffer
    mov rdx, 16             ; Maximum bytes to read
    syscall

    ; Begin parsing the input for digits
    xor r12, r12            ; Initialize array index to 0
    mov rdi, input          ; Point to the start of the input buffer

parse_input:
    ; Check if all 5 digits have been processed
    cmp r12, 5
    je reverse_array

    ; Read the next character from the input
    mov al, [rdi]
    cmp al, 0               ; Check for null terminator (end of input)
    je invalid_input        ; If end reached too soon, input is invalid

    ; Verify if the character is a digit
    cmp al, '0'
    jl skip_char            ; Ignore characters below '0'
    cmp al, '9'
    jg skip_char            ; Ignore characters above '9'

    ; Store the valid digit into the array
    mov [array + r12], al
    inc r12                 ; Move to the next array index

skip_char:
    inc rdi                 ; Advance to the next character in the input
    jmp parse_input         ; Continue processing

reverse_array:
    ; Reverse the contents of the array
    mov r12, 0              ; Left index
    mov r13, 4              ; Right index (last element)

reverse_loop:
    cmp r12, r13            ; Check if left and right indices have crossed
    jge output_array        ; If crossed, reversal is complete

    ; Swap elements at the left and right indices
    mov al, [array + r12]
    mov bl, [array + r13]
    mov [array + r12], bl
    mov [array + r13], al

    ; Update indices
    inc r12                 ; Move left index to the right
    dec r13                 ; Move right index to the left
    jmp reverse_loop

output_array:
    ; Output each character in the reversed array
    mov r12, 0              ; Start at the beginning of the array

output_loop:
    ; Load a character from the array
    mov al, [array + r12]
    mov [input], al         ; Temporarily store it in the input buffer for printing

    ; Print the character
    mov rax, 1              ; syscall: sys_write
    mov rdi, 1              ; stdout
    mov rsi, input          ; Address of the character
    mov rdx, 1              ; Single character length
    syscall

    ; Print a newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Move to the next character
    inc r12
    cmp r12, 5              ; Check if all characters have been printed
    jl output_loop

    ; Exit the program
    mov rax, 60             ; syscall: sys_exit
    xor rdi, rdi            ; Exit code 0
    syscall

invalid_input:
    ; Handle invalid input by displaying an error message
    mov rax, 1              ; syscall: sys_write
    mov rdi, 1              ; stdout
    mov rsi, invalid_input_msg ; Address of the error message
    mov rdx, invalid_input_len ; Length of the message
    syscall

    ; Restart the program to allow another attempt
    jmp input_prompt