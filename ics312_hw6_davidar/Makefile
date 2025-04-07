# Compiler and assembler settings
CC = gcc
CFLAGS = -m32 -no-pie
ASM = nasm
ASMFLAGS = -f elf

# Define program names
EXECS = imagedisplay imagedescramble imagedecrypt test
all: $(EXECS)

# Linking executables
# General compile rule for assembly programs into executables
$(EXECS): %: %.o asm_io.o driver.o
	$(CC) $(CFLAGS) -o $@ $^

# Compiling assembly files
%.o: %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

# Compile asm_io.asm separately with ELF type definition
asm_io.o: asm_io.asm
	$(ASM) $(ASMFLAGS) -d ELF_TYPE asm_io.asm -o asm_io.o

# Compile the C driver file
driver.o: driver.c
	$(CC) $(CFLAGS) -c driver.c -o driver.o

# Clean command
clean:
	rm -f *.o $(PROG1) $(PROG2)