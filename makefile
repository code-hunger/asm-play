SRC 	:= .
BIN 	:= ./bin

# For all targets in bin/, require an *.o file
$(BIN)/%: $(BIN)/%.o
	ld $< -o $@

# For all *.o targets, require the respective .asm source.
$(BIN)/%.o: %.asm
	@mkdir -p $(BIN)
	nasm -f elf64 -g -F stabs $< -o $@

SOURCES := $(wildcard *.asm)

TARGETS := $(SOURCES:.asm=)
TARGETS := $(addprefix $(BIN)/, $(TARGETS))

all:  $(TARGETS)

clean:
# With -f to suppress errors for inexistent files
	rm -f $(TARGETS)
