# For all targets in bin/, require an *.o file
bin/%: bin/%.o
	ld $< -o $@

# For all *.o targets, require the respective .asm source.
bin/%.o: %.asm
	nasm -f elf64 -g -F stabs $< -o $@

upcase: bin/upcase
