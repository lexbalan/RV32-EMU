
COMPILER_PATH=/opt/homebrew/opt/llvm@14/bin
#COMPILER_PATH=/usr/bin

CC=$(COMPILER_PATH)/clang
#CC=$(COMPILER_PATH)/clang-14
MACHINE = --target=riscv32 -march=rv32im

# Кароче, -nostdlib -fno-builtin -fno-builtin-memset не помогают
# гребаный компайлер все равно норовит вызывать memset и невозможно отделаться!

CFLAGS = $(MACHINE)

# only-section=.isr  не поможет - эту секцию хрен продавишь, хз почему так
ONLYSECTION=--only-section=.text --only-section=.data

SYS=../sys

LDSCRIPT = $(SYS)/mem.ld

# compile C to BIN
all:
	# translate C to ASM
	#$(CC) $(CFLAGS) -S main.c

	# translate ASM to OBJ
	#$(CC) $(CFLAGS) main.s -c -o main.o

	$(CC) $(CFLAGS) $(SYS)/muldivmod.c -c -o muldivmod.o
	$(CC) $(CFLAGS) $(SYS)/vect.S -c -o vect.o
	$(CC) $(CFLAGS) $(SYS)/base.S -c -o base.o
	$(CC) $(CFLAGS) $(SYS)/startup.c -c -o startup.o
	$(CC) $(CFLAGS) $(SYS)/system.c -c -o system.o
	$(CC) $(CFLAGS) $(SYS)/console.c -c -o console.o
	$(CC) $(CFLAGS) $(SYS)/printf.c -c -o printf.o
	$(CC) $(CFLAGS) main.c -c -o main.o


	# link OBJects to ELF
	$(CC) $(CFLAGS) -nostdlib -o main.elf -T $(LDSCRIPT) vect.o startup.o system.o console.o printf.o base.o muldivmod.o main.o

	rm *.o

	# extract sections from ELF to BIN file

	llvm-objcopy -Iriscv32 main.elf $(ONLYSECTION) -Obinary ../../image.bin
	#llvm-objcopy-14 -Iriscv32 main.elf $(ONLYSECTION) -Obinary ../../image.bin

	# make ELF dump
	llvm-objdump --full-contents --section=.text --section=.data -d ./main.elf > ./dump.txt
	#llvm-objdump-14 --full-contents --section=.text --section=.data -d ./main.elf > ./dump.txt



# show ELF content
dump:
	objdump --full-contents main.elf


# show ELF sections
sect:
	objdump -h main.elf


# show ELF symbols
symb:
	objdump -t main.elf


info:
	objdump -x main.elf

