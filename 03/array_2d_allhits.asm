%macro CHECK_INPUT_VALID_INTEGER 0%
    cmp eax,1
    jne invalid_integer_input
%endmacro

extern  print_array, array, read_2d_array, array_size, array_2d_size, invalid_integer_input, printf, scanf
global main

section .data
    mes             db "This programm finds all matches of number in 2d array",10,0
    inp_mes         db "Enter a number to look for:",10,0
    match_format    db "Hit! Row: %d, Col: %d",10 ,0
    inp_format      db "%d"
section .bss
    temp_val resd 1
section .text
main:
    ;read array
    push mes
    call printf
    add esp,4

    call read_2d_array
    ;get match input
    push inp_mes
    call printf
    add esp,4

    push temp_val
    push inp_format
    call scanf
    CHECK_INPUT_VALID_INTEGER
    add esp,8

    ;move row length to register
    mov ebx,[array_2d_size + 4]
    ;start calculations. remember to keep edx clean
    mov edi, array
    mov esi, [array_size]
    process_element:
    ;get value and compare
    mov ecx, [edi]
    cmp ecx, [temp_val]
    jne check_index
    ;clear edx
    
    mov eax,[array_size]
    ;invert esi, now it points to beginning
    sub eax, esi
    ;divide current index 
    xor edx,edx
    div ebx
    ;push col
    push edx
    ;push row
    push eax
    push match_format
    ;print
    call printf
    add esp,12

    check_index:
    add edi, 4
    dec esi
    jnz process_element

    ret