/*
 * hart/csr
 */

//
// CSR's
// see: https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//

public const mstatus_adr = 0x300     // Machine status register
public const misa_adr = 0x301        // ISA and extensions
public const medeleg_adr = 0x302     // Machine exception delegation register
public const mideleg_adr = 0x303     // Machine interrupt delegation register
public const mie_adr = 0x304         // Machine interrupt-enable register
public const mtvec_adr = 0x305       // Machine trap-handler base address
public const mcounteren_adr = 0x306  // Machine counter enable

public const mscratch_adr = 0x340
public const mepc_adr = 0x341
public const mcause_adr = 0x342
public const mtval_adr = 0x343
public const mip_adr = 0x344

public const mcycle_adr = 0xB00
public const minstret_adr = 0xB02
public const mcycleh_adr = 0xB80
public const minstreth_adr = 0xB82

public const mvendorid_adr = 0xF11
public const marchid_adr = 0xF12
public const mimpid_adr = 0xF13
public const mhartid_adr = 0xF14
public const mconfigptr_adr = 0xF15



// MISA fields
public const misa_a = Word32 1 << 0
public const misa_b = Word32 1 << 1
public const misa_c = Word32 1 << 2
public const misa_f = Word32 1 << 5
public const misa_i = Word32 1 << 8
public const misa_m = Word32 1 << 12
public const misa_s = Word32 1 << 18
public const misa_u = Word32 1 << 20
public const misa_x = Word32 1 << 23
public const misa_xlen_32 = Word32 1 << 30
public const misa_xlen_64 = Word32 2 << 30


