build: lab02.asm
	nasm -f elf -l lab02.lst -g lab02.asm
	ld -m elf_i386 -o lab02 lab02.o ../common/IO/IO.o
