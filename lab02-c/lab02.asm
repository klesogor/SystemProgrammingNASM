%define error jne log_error
; for some reason commands without args is implemented like fcommand TO st1 and then pushes st1 down
section .data
        out_mes   db "result = %.3f",10,0
        in_mes    db "Enter integer to calculate function:",10,0
        error_mes db "Input parsing error",10,0
        in_format db "%d",0
section .bss
    in_val    resd 1
    temp_val  resd 1
    out_val   resd 2; res 4*2=8 byte for float output
section .text
extern printf, scanf
global main
main:
    push in_mes
    call printf
    add esp, 4
    push in_val
    push in_format
    call scanf
    add esp,8; in_val now contains integer
    cmp eax, 1
    error
    mov eax, [in_val]
    cmp eax, 1
    jle first_case
    cmp eax, 20
    jle second_case
    jmp third_case

    first_case:
    call calc_le_one
    jmp fin
    second_case:
    call calc_le_twenty
    jmp fin
    third_case:
    call calc_gt_twenty
    jmp fin

    fin: 
    push dword [out_val + 4]
    push dword [out_val]
    push out_mes
    call printf
    add esp,12
    mov eax, 0x1
    int 80h
    
calc_le_one:
    fild dword [in_val]
    fild dword [in_val]
    fmulp;x^2

    mov  dword [temp_val], 75
    fild dword [temp_val]
    fmulp ;75x^2

    fild dword [in_val]
    mov  dword [temp_val], 17
    fild dword [temp_val]
    fmulp;17x

    fsubp; 54x^2 - 17x

    fstp qword [out_val]
    ret

calc_le_twenty:
    fild dword [in_val]
    fild dword [in_val]
    fmulp; x^2

    fild dword [in_val]
    fld1
    faddp; x+1

    fdivp; x^2/(x+1)

    mov  dword [temp_val], 54
    fild dword [temp_val]
    faddp; 54+(x^2/(x+1))

    fstp qword [out_val]
    ret

calc_gt_twenty:
    mov  dword [temp_val], 85
    fild dword [temp_val]
    fild dword [in_val]
    fmulp; 85x

    fld1
    fild dword [in_val]
    faddp; x+1

    fdivp; 85x/(1+x)

    fstp qword [out_val]
    ret

log_error:
    push error_mes
    call printf
    mov eax, 0x1
    mov ebx, 0x1
    int 0x80