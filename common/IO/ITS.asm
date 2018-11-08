
section     .data
	sys_write equ 4h
	sys_read  equ 3h
	std_in    equ 2h
	std_out   equ 1h


section     .text

global      print_num

print_num:;expects number on stack
	push ebp; save base pointer
	mov ebp,esp; point to start of stack
	res_sign:
	mov ax, word [ebp+8]; ebp+ret address
	or ax,ax
	jns init_ns
	mov ax, '-';print minus sign
	mov [buffer], ax
	mov eax, sys_write
	mov ebx, std_out
	mov ecx, buffer
	mov edx, 1
	int 80h
	mov ax, [ebp+8];invert value
	neg ax
	mov [ebp+8], ax
	jmp init_s
	
	init_ns:
	mov ax, [ebp+8]

	init_s:
	mov bx, 10
	mov dx, 0

	divide_loop:
	add dx,2;increment counter by two, since two bytes will be reserved on stack
	div bl
	xor cx, cx
	mov cl,ah
	add cx, '0'
	push cx
	xor ah,ah
	test ax,ax
	jnz divide_loop
	
	print_res:
	mov ax, sys_write
	mov bx, std_out
	mov ecx, esp; counter is already in dx
	int 80h

	mov esp,ebp;restore stack and return
	pop ebp
	ret

