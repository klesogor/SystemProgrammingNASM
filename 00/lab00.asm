;[map all lab00.map]
SECTION .data
	SOURCE: db 10,20,30,40; INITIAL ARRAY
SECTION .bss
	TARGET: resb 4; FREE SPACE TO MOVE BYTES FROM SOURCE
SECTION .text
	GLOBAL _start

_start:
	mov al,1
	mov al,[SOURCE]; move source
	mov [TARGET+3],al
	mov al,[SOURCE+1]
	mov [TARGET+2],al
	mov al,[SOURCE+2]
	mov [TARGET+1],al
	mov al,[SOURCE+3]
	mov [TARGET],al
	;exit programm
	mov ax,1
	mov bx,1
	int 0x80;sys_call
