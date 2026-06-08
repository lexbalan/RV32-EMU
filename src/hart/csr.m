/*
 * hart/csr
 */

pragma public_module

//
// CSR's
// see: https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//

const mstatus_regno = 0x300     // Machine status register
const misa_regno = 0x301        // ISA and extensions
const medeleg_regno = 0x302     // Machine exception delegation register
const mideleg_regno = 0x303     // Machine interrupt delegation register
const mie_regno = 0x304         // Machine interrupt-enable register
const mtvec_regno = 0x305       // Machine trap-handler base address
const mcounteren_regno = 0x306  // Machine counter enable

const mscratch_regno = 0x340
const mepc_regno = 0x341
const mcause_regno = 0x342
const mtval_regno = 0x343
const mip_regno = 0x344

const mcycle_regno = 0xB00
const minstret_regno = 0xB02
const mcycleh_regno = 0xB80
const minstreth_regno = 0xB82

const mvendorid_regno = 0xF11
const marchid_regno = 0xF12
const mimpid_regno = 0xF13
const mhartid_regno = 0xF14
const mconfigptr_regno = 0xF15



// MISA fields
const misa_a = Word32 1 << 0
const misa_b = Word32 1 << 1
const misa_c = Word32 1 << 2
const misa_f = Word32 1 << 5
const misa_i = Word32 1 << 8
const misa_m = Word32 1 << 12
const misa_s = Word32 1 << 18
const misa_u = Word32 1 << 20
const misa_x = Word32 1 << 23
const misa_xlen_32 = Word32 1 << 30
const misa_xlen_64 = Word32 2 << 30


