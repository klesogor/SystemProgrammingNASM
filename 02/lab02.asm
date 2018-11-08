%define check_overflow jo report_overflow
%define stdout 0x1
%define sys_write 0x4
%define stdin 0x2
%define sys_read 0x3
SECTION .data
	overflow_mes db 'overflow occured during program runtime. Please, invent exceptions to handle this properly',10,13
	len equ $ - overflow_mes
	input_mes db 'Please, enter a signed byte(or else you will break something)',10,13
	leni equ $ - input_mes
	int_mes db 'Integer part:'
	int_mesl equ  $ - int_mes
	rem_mes db  10,13,'Reminder part:'
	rem_mesl equ  $ - rem_mes

SECTION .text

EXTERN read_num, print_num
GLOBAL _start

_start:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, input_mes
	mov edx, leni
	int 80h
	call read_num
	push ax
	call cmp_num; no ret, it will destroy programm

cmp_num:   ;expects short(16bit, signed)
	push ebp
	mov ebp, esp
	
	mov ax, [ebp + 8]
	cmp ax, 0x1
	jle le_one
	cmp ax, 0x14
	jle le_twenty
	jmp gt_twenty

le_one:
	mov ax, [ebp+8]
	imul ax
	check_overflow
	mov bx, 75
	mul bx
	check_overflow
	push ax;75 * x^2
	mov ax,[ebp+8]
	mov bx, 17
	imul bx 
	mov bx,ax; 17x
	pop ax
	sub ax,bx
	check_overflow

	push ax
	call print_num
	add esp,4
	jmp finally

le_twenty:
	mov ax, [ebp+8]
	mul ax
	check_overflow
	;x^2
	add ax, 54
	mov bx,[ebp + 8]
	inc bx
	;1 + x
	div bx
	check_overflow

	push ax
	push dx
	call print_division_res
	add esp, 8
	jmp finally

gt_twenty: 
	mov ax, [ebp + 8]
	mov bx, 85
	mul bx
	check_overflow
	mov bx,[ebp + 8]
	inc bx
	div bx
	check_overflow
	push ax
	push dx
	call print_division_res
	add esp, 8
	jmp finally
finally:
	mov eax,1
	int 80h

report_overflow:
	mov eax, sys_write
	mov ebx, stdout
	mov ecx, overflow_mes
	mov edx, len
	int 80h
	mov eax, 0x1
	int 80h

print_division_res:
	push ebp
	mov ebp,esp

	mov ax, sys_write
	mov bx, stdout
	mov ecx, int_mes
	mov dx, int_mesl
	int 80h
	mov ax, [ebp + 10]
	push ax
	call print_num
	mov ax,sys_write
	mov ecx, rem_mes
	mov dx, rem_mesl
	int 80h
	add esp,4
	mov ax, [ebp + 8]
	push ax
	call print_num
	add esp,4

	mov esp,ebp
	pop ebp
	ret
