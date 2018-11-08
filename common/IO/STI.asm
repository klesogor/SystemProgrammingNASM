
section     .data
	sys_write equ 4h
	sys_read  equ 3h
	std_in    equ 2h
	std_out   equ 1h
	max_chars equ 5h
	num dw -135
	msg  db 'Not a valid character or too big/small number ', 0xa
	len equ $-msg

section	    .bss
	buffer resb 64


section     .text

global      read_num

read_num:
	push ebp
	mov ebp,esp

	mov eax, sys_read
	mov ebx, std_in
	mov ecx, buffer
	mov edx, max_chars
	int 80h
	mov ecx, buffer; pointer

	check_first_symbol:
	mov al,[buffer]
	cmp ax, '-'
	je resolve_minus
	cmp ax, '+'
	je resolve_plus
	jmp preprocess_integer

	resolve_minus:
	mov ax,1
	push ax
	inc ecx
	jmp preprocess_integer

	resolve_plus:
	mov ax,0
	push ax
	inc ecx
	jmp preprocess_integer

	preprocess_integer:
	mov bl,10; set first nul
	push word 0; push empty value
	process_integer:
	mov al, [ecx]
	sub ax, '0'
	validate_num:
	jc bad; if ax<0 - error
	mov dx, 9
	sub dx, ax
	jc bad
	good:
	mov dx,ax
	pop ax
	mul bl
	add ax,dx
	jo bad; if overflow - it's time to leave
	push ax
	inc ecx
	cmp [ecx],byte 0xa 
	je finish
	cmp [ecx], byte  0x0
	je finish
	jmp process_integer

	bad:
	mov ax,sys_write
	mov bx,std_out
	mov ecx, msg
	mov dx,len
	int 80h
	mov eax,1
	int 80h

	finish:
	pop ax
	pop bx
	cmp bx,1
	jne return
	neg ax

	return:
	mov esp, ebp
	pop ebp
	ret



