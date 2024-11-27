; Sensor-Based Motor and Alarm Control
; Adjusts motor and alarm statuses based on sensor input thresholds.

global _start

section .data
    sensor_value    dd 0        ; Stores the input sensor value
    motor_status    db 0        ; Indicates motor state: 0=OFF, 1=ON
    alarm_status    db 0        ; Indicates alarm state: 0=OFF, 1=ON

    HIGH_LEVEL      equ 80      ; Trigger threshold for high water level
    MODERATE_LEVEL  equ 50      ; Trigger threshold for moderate water level

    prompt          db 'Enter sensor value: ', 0
    input_buffer    db 10 dup(0)
    motor_msg       db 'Motor Status: ', 0
    alarm_msg       db 'Alarm Status: ', 0
    on_msg          db 'ON', 10, 0
    off_msg         db 'OFF', 10, 0

section .text
_start:
    ; Prompt the user for a sensor value
    mov     eax, 4              ; System call to write
    mov     ebx, 1              ; Write to standard output
    mov     ecx, prompt         ; Load prompt message
    mov     edx, 20             ; Length of the message
    int     0x80                ; Trigger system call

    ; Read sensor value input from the user
    mov     eax, 3              ; System call to read
    mov     ebx, 0              ; Read from standard input
    mov     ecx, input_buffer   ; Buffer to store input
    mov     edx, 10             ; Max characters to read
    int     0x80                ; Trigger system call

    ; Convert the user input to an integer
    mov     esi, input_buffer   ; Point to the input buffer
    call    atoi                ; ASCII to integer conversion

    ; Store the converted sensor value
    mov     [sensor_value], eax

    ; Load the sensor value and decide the appropriate action
    mov     eax, [sensor_value]
    cmp     eax, HIGH_LEVEL     ; Check if sensor exceeds high threshold
    jg      high_level          ; Jump if greater than HIGH_LEVEL

    cmp     eax, MODERATE_LEVEL ; Check if sensor exceeds moderate threshold
    jg      moderate_level      ; Jump if greater than MODERATE_LEVEL

low_level:
    ; Low sensor level: Activate motor, deactivate alarm
    mov     byte [motor_status], 1
    mov     byte [alarm_status], 0
    jmp     display_status      ; Proceed to display statuses

moderate_level:
    ; Moderate sensor level: Deactivate both motor and alarm
    mov     byte [motor_status], 0
    mov     byte [alarm_status], 0
    jmp     display_status

high_level:
    ; High sensor level: Activate both motor and alarm
    mov     byte [motor_status], 1
    mov     byte [alarm_status], 1

display_status:
    ; Display the motor status
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, motor_msg
    mov     edx, 14
    int     0x80

    ; Show whether the motor is ON or OFF
    mov     al, [motor_status]
    cmp     al, 1
    je      motor_on
    jmp     motor_off

motor_on:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, on_msg
    mov     edx, 3
    int     0x80
    jmp     display_alarm

motor_off:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, off_msg
    mov     edx, 4
    int     0x80

display_alarm:
    ; Display the alarm status
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, alarm_msg
    mov     edx, 13
    int     0x80

    ; Show whether the alarm is ON or OFF
    mov     al, [alarm_status]
    cmp     al, 1
    je      alarm_on
    jmp     alarm_off

alarm_on:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, on_msg
    mov     edx, 3
    int     0x80
    jmp     exit_program

alarm_off:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, off_msg
    mov     edx, 4
    int     0x80

exit_program:
    ; Terminate the program
    mov     eax, 1              ; System call for exit
    xor     ebx, ebx            ; Exit code 0
    int     0x80

; Subroutine: Convert ASCII input to integer
atoi:
    xor     eax, eax            ; Clear result register
    xor     ebx, ebx            ; Clear temporary register
atoi_loop:
    mov     bl, byte [esi]      ; Load the next character
    cmp     bl, 10              ; Check for newline (end of input)
    je      atoi_done
    sub     bl, '0'             ; Convert ASCII to numeric digit
    imul    eax, eax, 10        ; Multiply current result by 10
    add     eax, ebx            ; Add the new digit
    inc     esi                 ; Advance to the next character
    jmp     atoi_loop
atoi_done:
    ret                         ; Return the result in EAX