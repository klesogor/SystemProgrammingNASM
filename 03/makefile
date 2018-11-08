build_minmax: read_array.o array_sum_minmax.o
	gcc -g -m32 -o array_sum_minmax array_sum_minmax.o read_array.o

build_2d: read_array.o array_2d_allhits.o
	gcc -g -m32 -o array_2d_allhits array_2d_allhits.o read_array.o

build_sort: read_array.o array_sort.o
	gcc -g -m32 -o array_sort array_sort.o read_array.o

array_2d_allhits.o:
	nasm -g -f elf -l array_2d_allhits.lst -o array_2d_allhits.o array_2d_allhits.asm

read_array.o: read_array.asm 
	nasm -g -f elf -l read_array.lst -o read_array.o read_array.asm

array_sum_minmax.o: array_sum_minmax.asm
	nasm -g -f elf -l array_sum_minmax.lst -o array_sum_minmax.o array_sum_minmax.asm

array_sort.o: array_sort.asm
	nasm -g -f elf -l array_sort.lst -o array_sort.o array_sort.asm