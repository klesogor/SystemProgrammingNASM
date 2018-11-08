%define SIZE 20
%macro CHECK_INPUT_VALID_INTEGER 1
    cmp eax,%1
    call invalid_integer_input
%endmacro


extern printf,scanf
global print_array, read_array, invalid_integer_input, array, array_size, read_2d_array, array_2d_size

section .data
    in_mes_size    db "Enter array size in range 1 to 20", 10,0
    size_error_mes db "Invalid array size",10,0
    parse_error    db "Invalid character found", 10, 0
    in_mes_digit   db "Enter next digit:",10,0
    in_format      db "%d",0
    new_line       db 10,0
    out_format     db "%d ",0
    in_mes_2d      db "Enter two array sizes(rows,cols) in format 0 0",10,0
    in_2d_format   db "%d %d",0
section .bss
    array          resd SIZE 
    array_size     resd 1
    temp_var       resd 1
    array_2d_size resd 2
section .text 

read_array:
push in_mes_size
call printf
add esp,4
push array_size
push in_format
call scanf
add esp,8
CHECK_INPUT_VALID_INTEGER 1

parse_array_no_inp_mes:
mov eax, [array_size]
cmp eax, 0
jle invalid_array_size
cmp eax, SIZE
jg  invalid_array_size
mov esi, [array_size]
mov edi, array
push in_mes_digit

parse_next_int:
call printf
push temp_var
push in_format
call scanf
add esp,8
mov eax, [temp_var]
mov [edi], eax
add edi, 4
dec esi
jnz parse_next_int

finalize:
add esp,4
ret

print_array:
    mov esi, [array_size]
    mov edi, array
    sub esp,4
    push out_format
    write_next_int:
    mov eax, [edi]
    mov [esp+4], eax
    call printf
    add edi,4
    dec esi
    jnz write_next_int
    add esp,8
    push new_line
    call printf
    add esp,4

    ret


invalid_array_size:
push size_error_mes
call printf
add esp,4
mov eax,1
int 80h

invalid_integer_input:
push parse_error
call printf
add esp,4
mov eax,1
int 80h

read_2d_array:
    push in_mes_2d
    call printf
    add esp,4
    push array_2d_size + 4
    push array_2d_size
    push in_2d_format
    call scanf
    add esp,12
    CHECK_INPUT_VALID_INTEGER 2
    mov eax, [array_2d_size + 4]
    mov ebx, [array_2d_size]

    imul ebx
    mov [array_size], eax
    jmp parse_array_no_inp_mes
