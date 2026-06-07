

public func csrwMtvec (adr: Word32) -> Word32 {
	var old: Word32
	__asm("csrw mtvec, %0", [["=r", old]], [["r", adr]])
	return old
}


public func csrMisa () -> Word32 {
	var x: Word32
	__asm("csrr %0, misa", [["=r", x]], [])
	return x
}

