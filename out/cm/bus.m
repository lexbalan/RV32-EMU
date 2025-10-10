import "mmio"
include "stdio"
include "stdlib"
//
//
import "mmio" as mmio


const showText: Bool = false


// see mem.ld
public const ramSize: Nat32 = Nat32 16 * 1024
public const ramStart = Nat32 0x10000000
public const ramEnd: Nat32 = ramStart + ramSize


public const romSize = Nat32 0x100000
public const romStart = Nat32 0x00000000
public const romEnd: Nat32 = romStart + romSize


const mmioSize = Nat32 0xFFFF
const mmioStart = Nat32 0xF00C0000
const mmioEnd: Nat32 = mmioStart + mmioSize


var ram: [ramSize]Word8
var rom: [romSize]Word8


public func read (adr: Nat32, size: Nat8) -> Word32 {
	if isAdressInRange(adr, ramStart, ramEnd) {
		let ramPtr = Ptr &ram[adr - ramStart]
		if size == 1 {
			return Word32 *(*Word8 ramPtr)
		} else if size == 2 {
			return Word32 *(*Word16 ramPtr)
		} else if size == 4 {
			return *(*Word32 ramPtr)
		}
	} else if isAdressInRange(adr, romStart, romEnd) {
		let romPtr = Ptr &rom[adr - romStart]
		if size == 1 {
			return Word32 *(*Word8 romPtr)
		} else if size == 2 {
			return Word32 *(*Word16 romPtr)
		} else if size == 4 {
			return *(*Word32 romPtr)
		}
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		// MMIO Read
	} else {
		memoryViolation("r", adr)
	}

	return 0
}


public func write (adr: Nat32, value: Word32, size: Nat8) -> Unit {
	if isAdressInRange(adr, ramStart, ramEnd) {
		let ramPtr = Ptr &ram[adr - ramStart]
		if size == 1 {
			*(*Word8 ramPtr) = unsafe Word8 value
		} else if size == 2 {
			*(*Word16 ramPtr) = unsafe Word16 value
		} else if size == 4 {
			*(*Word32 ramPtr) = value
		}
	} else if isAdressInRange(adr, mmioStart, mmioEnd) {
		let mmioAdr: Nat32 = adr - mmioStart
		if size == 1 {
			mmio.write8(mmioAdr, unsafe Word8 value)
		} else if size == 2 {
			mmio.write16(mmioAdr, unsafe Word16 value)
		} else if size == 4 {
			mmio.write32(mmioAdr, value)
		}
	} else if isAdressInRange(adr, romStart, romEnd) {
		memoryViolation("w", adr)
	} else {
		memoryViolation("w", adr)
	}
}



@inline
func isAdressInRange (x: Nat32, a: Nat32, b: Nat32) -> Bool {
	return x >= a and x < b
}


var memviolationCnt = Nat32 0
func memoryViolation (rw: Char8, adr: Nat32) -> Unit {
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr)
	if memviolationCnt > 10 {
		exit(1)
	}
	memviolationCnt = memviolationCnt + 1
	//	memoryViolation_event(0x55) // !
}



public func load_rom (filename: *Str8) -> Nat32 {
	return load(filename, &rom, romSize)
}


func load (filename: *Str8, bufptr: *[]Word8, buf_size: Nat32) -> Nat32 {
	printf("LOAD: %s\n", filename)

	let fp: *File = fopen(filename, "rb")

	if fp == nil {
		printf("error: cannot open file '%s'", filename)
		return 0
	}

	let n: SizeT = fread(bufptr, 1, SizeT buf_size, fp)

	printf("LOADED: %zu bytes\n", n)

	if showText {
		var i = SizeT 0
		while i < (n / 4) {
			printf("%08zx: 0x%08x\n", i, (unsafe *[]Nat32 bufptr)[i])
			i = i + 4
		}

		printf("-----------\n")
	}

	fclose(fp)

	return unsafe Nat32 n
}


public func show_ram () -> Unit {
	var i = Nat32 0
	let ramptr: *[ramSize]Word8 = &ram
	while i < 256 {
		printf("%08X", i * 16)

		var j = Nat32 0
		while j < 16 {
			printf(" %02X", ramptr[i + j])
			j = j + 1
		}

		printf("\n")

		i = i + 16
	}
}

