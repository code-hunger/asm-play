a.out: input.o
	ld input.o -o a.out

input.o: input.asm
	nasm -f elf64 -g -F stabs input.asm 

sandbox: sandbox.o
	ld sandbox.o -o sandbox

sandbox.o: sandbox.asm
	nasm -f elf64 -g -F stabs sandbox.asm 
