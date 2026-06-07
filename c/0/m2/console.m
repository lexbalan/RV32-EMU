
pragma unsafe

include "./riscv_emu"

public func putc (x: Char8) -> Unit {
    put_code(Nat32 unsafe Word32 x)
}

public func put_code (x: Nat32) -> Unit {
	*(*Nat8 unsafe Ptr consolePrintChar8Adr) = unsafe Nat8 x
}

public func getc () -> Nat32 {
	return 0
}


public func print_int (x: Int32) -> Unit {
	*(*Int32 unsafe Ptr consolePrintInt32Adr) = x
}

public func print_uint (x: Nat32) -> Unit {
	*(*Nat32 unsafe Ptr consolePrintUInt32Adr) = x
}

public func print_uint_hex (x: Nat32) -> Unit {
	*(*Nat32 unsafe Ptr consolePrintUInt32HexAdr) = x
}


public func puts (x: *Str8) -> Unit {
    var i: Nat32 = 0
    while true {
        let c = x[i]
        if c == '\0' {
            break
        }
        putc(c)
        i = i + 1
    }
}

