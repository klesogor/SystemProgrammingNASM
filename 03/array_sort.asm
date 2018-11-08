
global main
extern printf, read_array, print_array, array, array_size

section .data
    mes               db 'This program is bubble sort.',10,0
    default_array_mes db 'You entered this array:',10,0
    sorted_array_mes  db 'Sorted array:',10,0
section .text
main:
    push mes
    call printf
    add esp,4

    ;read array
    call read_array
    ;print array
    push default_array_mes
    call printf
    add esp,4
    
    call print_array

    call sort_array

    call print_array

    ret

sort_array: ;eax - counter, ebx - flag; ecx,edx - available
    mov esi, [array_size]
    mov edi, array;pointer to array
    dec esi;points to pre-last element of array
    external_loop:
    mov eax,0
    mov ebx,0; flag
        internal_loop:
        mov ecx, [edi + eax * 4]
        mov edx, [edi + eax * 4 + 4]
        cmp ecx,edx
        jle skip_swap
            swap:
            mov [edi + eax * 4 + 4], ecx
            mov [edi + eax * 4], edx
            mov ebx,1
        skip_swap:
        inc eax
        cmp eax,esi
        jne internal_loop
        out_internal:
        cmp ebx,0
        je finally
        dec esi
        jnz external_loop

finally:
ret
