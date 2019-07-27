a.out: sandbox.o
	ld sandbox.o -o a.out

sandbox.o: sandbox.asm
	nasm -f elf64 -g -F stabs sandbox.asm 
