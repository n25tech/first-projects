# Variables
ASM=nasm
#LINKER=ld
LINKER=gcc
FLAGS=-f elf64

# Automatically find all .asm files and define their binary names
SRCS := $(wildcard *.asm)
BINS := $(SRCS:.asm=)

# Default target: compile everything
all: $(BINS)

# Pattern rule: Link .o into a binary
%: %.o
	mkdir -p bin
	$(LINKER) $< -o bin/$@

# Pattern rule: Assemble .asm into .o
%.o: %.asm
	$(ASM) $(FLAGS) $< -o $@

# Clean up utility: removes object files AND the binaries
clean:
	rm -f *.o $(BINS)

