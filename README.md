# ICS3203-CAT2-Assembly-Mwangi-Natalia-150473
Assembly Language Programming CAT 2

## Overview

This repository contains the solutions to the ICS3203 Assembly Language CAT2 assignment. The assignment consists of four tasks that involve control flow, array manipulation, factorial calculation, and data monitoring using port-based simulation. Each task is designed to showcase different aspects of assembly programming, including low-level memory management, use of registers, conditional logic, and system calls.

### Task 1: Control Flow and Conditional Logic
- **Purpose**: This program classifies a given number as positive, negative, or zero using conditional jumps in assembly. It demonstrates the use of assembly jumps (`je`, `jl`, `jmp`) for controlling program flow.

### Task 2: Array Manipulation with Looping and Reversal
- **Purpose**: This task implements array reversal using loops and memory manipulation in assembly. It demonstrates how to work directly with memory, manage pointers, and handle bounds and alignment issues.

### Task 3: Modular Program with Subroutines for Factorial Calculation
- **Purpose**: This program calculates the factorial of a number using subroutines and recursion. It showcases how to use registers for computation and how to preserve register values across subroutine calls.

### Task 4: Data Monitoring and Control Using Port-Based Simulation
- **Purpose**: This program simulates a water-level sensor with motor and alarm control. It demonstrates how to read sensor values, compare them to predefined thresholds, and perform actions (turning a motor on or off, triggering an alarm) based on the input.

## Instructions for compiling and running the code

- **Compilation and Running the Programs (example with task 1)**:
  cd Task-1
  nasm -f elf64 control_flow.asm -o control.o
  ld control_flow.o -o control_flow
  ./control_flow

## Insights and Challenges

### Task 1: Control Flow and Conditional Logic
- **Insights**: Conditional jumps (`je`, `jl`, `jmp`) are essential in assembly programming to manage the flow of execution. They enable the program to handle different scenarios, such as classifying numbers as positive, negative, or zero.
- **Challenges**: Debugging the conditional logic and ensuring that jumps occur correctly was tricky. Memory management, especially with data registers, was a key concern to maintain the correct values at each stage.

### Task 2: Array Manipulation with Looping and Reversal
- **Insights**: Working directly with memory in assembly allows for efficient manipulation of data, but it requires careful management of pointers and memory bounds.
- **Challenges**: Managing pointers and ensuring proper memory alignment were difficult. Any mistake in pointer manipulation could lead to crashes or data corruption.

### Task 3: Modular Program with Subroutines for Factorial Calculation
- **Insights**: Using subroutines in assembly allows for modular code and easier debugging. Preserving register values across subroutine calls is essential for maintaining the correctness of recursive functions.
- **Challenges**: Handling recursion in assembly is much more complex than in higher-level languages. Managing the stack and ensuring that values are preserved during recursive calls was a challenge.

### Task 4: Data Monitoring and Control Using Port-Based Simulation
- **Insights**: Low-level memory manipulation in this task allowed for simulating a control system. It demonstrated how to monitor and act based on sensor input in real-time.
- **Challenges**: Correctly handling sensor input and updating the motor and alarm status based on predefined thresholds required careful conditional logic. Ensuring that memory was updated correctly to reflect the status of the system was a key challenge.