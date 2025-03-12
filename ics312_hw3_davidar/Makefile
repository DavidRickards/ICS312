# Program names
PROG1 = hw3_ex1
PROG2 = hw3_ex2

# Compiler and assembler settings
CC = gcc
CFLAGS = -m32 -no-pie
ASM = nasm
ASMFLAGS = -f elf

# Default target (build both programs)
default: $(PROG1) $(PROG2)

# Run executables (optional, modify as needed)
run: $(PROG1) $(PROG2)
	@./$(PROG1)
	@./$(PROG2)

# Linking executables
$(PROG1): $(PROG1).o driver.o asm_io.o
	$(CC) $(CFLAGS) $(PROG1).o driver.o asm_io.o -o $(PROG1)

$(PROG2): $(PROG2).o driver.o asm_io.o
	$(CC) $(CFLAGS) $(PROG2).o driver.o asm_io.o -o $(PROG2)

# Compiling assembly files
%.o: %.asm
	$(ASM) $(ASMFLAGS) $< -o $@

# Compile asm_io.asm separately with ELF type definition
asm_io.o: asm_io.asm
	$(ASM) $(ASMFLAGS) -d ELF_TYPE asm_io.asm -o asm_io.o

# Compile the C driver file
driver.o: driver.c
	$(CC) $(CFLAGS) -c driver.c -o driver.o

# Clean command
clean:
	/bin/rm -f *.o $(PROG1) $(PROG2)
