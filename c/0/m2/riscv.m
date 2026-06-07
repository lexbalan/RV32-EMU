

public func csrwMtvec (adr: Word32) -> Word32 {
	var old: Word32
	__asm("csrw mtvec, %0", [["=r", old]], [["r", adr]])
	return old
}

