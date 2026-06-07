
COMPILER_PATH=/opt/homebrew/opt/llvm@14/bin
#COMPILER_PATH=/usr/bin

CC=$(COMPILER_PATH)/clang
#CC=$(COMPILER_PATH)/clang-14
MACHINE = --target=riscv32 -march=rv32im

# Кароче, -nostdlib -fno-builtin -fno-builtin-memset не помогают
# гребаный компайлер все равно норовит вызывать memset и невозможно отделаться!

CFLAGS = -O0 $(MACHINE)

# only-section=.isr  не поможет - эту секцию хрен продавишь, хз почему так
ONLYSECTION=--only-section=.text --only-section=.data

SYS=../sys

LDSCRIPT = $(SYS)/mem.ld

# compile C to BIN
all:
	mcc -mbackend=c11 -o src/riscv m2/riscv.m
	mcc -mbackend=c11 -o src/main m2/main.m
	mcc -mbackend=c11 -o src/console m2/console.m
	mcc -mbackend=c11 -o src/riscv_emu m2/riscv_emu.m

	# translate C to ASM
	#$(CC) $(CFLAGS) -S src/main.c

	# translate ASM to OBJ
	#$(CC) $(CFLAGS) main.s -c -o main.o

	$(CC) $(CFLAGS) $(SYS)/muldivmod.c -c -o muldivmod.o
	$(CC) $(CFLAGS) $(SYS)/vect.S -c -o vect.o
	$(CC) $(CFLAGS) $(SYS)/base.S -c -o base.o
	$(CC) $(CFLAGS) $(SYS)/startup.c -c -o startup.o
	$(CC) $(CFLAGS) src/console.c -c -o console.o
	$(CC) $(CFLAGS) src/main.c -c -o main.o
	$(CC) $(CFLAGS) src/riscv.c -c -o riscv.o

	# link OBJects to ELF
	$(CC) $(CFLAGS) -nostdlib -o out/main.elf -T $(LDSCRIPT) vect.o startup.o console.o base.o muldivmod.o main.o riscv.o

	rm *.o

	# extract sections from ELF to BIN file

	llvm-objcopy -Iriscv32 out/main.elf $(ONLYSECTION) -Obinary out/image.bin
	cp out/image.bin ../../image.bin

	#llvm-objcopy-14 -Iriscv32 out/main.elf $(ONLYSECTION) -Obinary ../../image.bin

	# make ELF dump
	llvm-objdump --full-contents --section=.text --section=.data -d out/main.elf > out/dump.txt
	#llvm-objdump-14 --full-contents --section=.text --section=.data -d out/main.elf > out/dump.txt



# show ELF content
dump:
	objdump --full-contents out/main.elf


# show ELF sections
sect:
	objdump -h out/main.elf


# show ELF symbols
symb:
	objdump -t out/main.elf


info:
	objdump -x out/main.elf

