
%macro CHECK_OVERFLOW_SUM 0
    jo inform_overflow
%endmacro
global main
extern printf,read_array,array,array_size
section .data
    mes db "This programm calculates sum of the array and finds max and min element",10,0
    overflow db "Overflow occured during sum calculation",10,0
    fin_format db "sum: %d, min: %d, max:%d",10,0
section .text

main:
    push mes
    call printf
    add esp,4
    call read_array
    mov edi, array
    mov esi, [array_size]
    ;clear registers
    xor ebx,ebx
    xor ecx,ecx
    xor edx,edx

    process_array:;bx - sum, cx - min; dx - max
    mov eax,[edi]
    add ebx,eax
    CHECK_OVERFLOW_SUM
    cmp eax, ecx
    jge check_greater
    ;swap
    mov ecx,eax
    check_greater:
    cmp eax, edx
    jle check_index
    mov edx, eax
    check_index:
    add edi, 4;next element
    dec esi
    jnz process_array

    push edx
    push ecx
    push ebx
    push fin_format
    call printf
    add esp, 16
    ret

    inform_overflow:
    push overflow
    call printf
    add esp,4
    mov eax,1
    int 80h
