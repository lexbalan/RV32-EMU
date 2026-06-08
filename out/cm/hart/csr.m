import "builtin"

//
// CSR's
// see: https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//

public const mstatus_regno = 0x300// Machine status register
public const misa_regno = 0x301// ISA and extensions
public const medeleg_regno = 0x302// Machine exception delegation register
public const mideleg_regno = 0x303// Machine interrupt delegation register
public const mie_regno = 0x304// Machine interrupt-enable register
public const mtvec_regno = 0x305// Machine trap-handler base address
public const mcounteren_regno = 0x306// Machine counter enable

public const mscratch_regno = 0x340
public const mepc_regno = 0x341
public const mcause_regno = 0x342
public const mtval_regno = 0x343
public const mip_regno = 0x344

public const mcycle_regno = 0xB00
public const minstret_regno = 0xB02
public const mcycleh_regno = 0xB80
public const minstreth_regno = 0xB82

public const mvendorid_regno = 0xF11
public const marchid_regno = 0xF12
public const mimpid_regno = 0xF13
public const mhartid_regno = 0xF14
public const mconfigptr_regno = 0xF15



// MISA fields
public const misa_a: Word32 = Word32 1 << 0
public const misa_b: Word32 = Word32 1 << 1
public const misa_c: Word32 = Word32 1 << 2
public const misa_f: Word32 = Word32 1 << 5
public const misa_i: Word32 = Word32 1 << 8
public const misa_m: Word32 = Word32 1 << 12
public const misa_s: Word32 = Word32 1 << 18
public const misa_u: Word32 = Word32 1 << 20
public const misa_x: Word32 = Word32 1 << 23
public const misa_xlen_32: Word32 = Word32 1 << 30
public const misa_xlen_64: Word32 = Word32 2 << 30

