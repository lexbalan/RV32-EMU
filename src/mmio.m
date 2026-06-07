
include "libc/ctypes"
include "libc/stdio"


const consoleMMIOAdr = Nat32 0x10
const consolePutAdr = consoleMMIOAdr + 0
const consoleGetAdr = consoleMMIOAdr + 1

const consolePrintInt32Adr = consoleMMIOAdr + Nat32 0x10
const consolePrintUInt32Adr = consoleMMIOAdr + Nat32 0x14
const consolePrintInt32HexAdr = consoleMMIOAdr + Nat32 0x18
const consolePrintUInt32HexAdr = consoleMMIOAdr + Nat32 0x1C

const consolePrintInt64Adr = consoleMMIOAdr + Nat32 0x20
const consolePrintUInt64Adr = consoleMMIOAdr + Nat32 0x28



public func write8 (adr: Nat32, value: Word8) -> Unit {
	if adr == consolePutAdr {
		putchar(Int value)
		return
	}
}


public func write16 (adr: Nat32, value: Word16) -> Unit {
	if adr == consolePutAdr {
		putchar(Int value)
		return
	}
}


public func write32 (adr: Nat32, value: Word32) -> Unit {
	if adr == consolePutAdr {
		putchar(Int value)
		return
	} else if adr == consolePrintInt32Adr {
		printf("%d", value)
		return
	} else if adr == consolePrintUInt32Adr {
		printf("%u", value)
		return
	} else if adr == consolePrintInt32HexAdr {
		printf("%x", value)
		return
	} else if adr == consolePrintUInt32HexAdr {
		printf("%x", value)
		return
	}
}


public func read8 (adr: Nat32) -> Word8 {
	return 0
}

public func read16 (adr: Nat32) -> Word16 {
	return 0
}

public func read32 (adr: Nat32) -> Word32 {
	return 0
}

