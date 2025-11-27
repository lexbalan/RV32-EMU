
#ifndef CSR_H
#define CSR_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


#define CSR_MSTATUS_ADR  0x300
#define CSR_MISA_ADR  0x301
#define CSR_MEDELEG_ADR  0x302
#define CSR_MIDELEG_ADR  0x303
#define CSR_MIE_ADR  0x304
#define CSR_MTVEC_ADR  0x305
#define CSR_MCOUNTEREN_ADR  0x306

#define CSR_MSCRATCH_ADR  0x340
#define CSR_MEPC_ADR  0x341
#define CSR_MCAUSE_ADR  0x342
#define CSR_MTVAL_ADR  0x343
#define CSR_MIP_ADR  0x344

#define CSR_MCYCLE_ADR  0xB00
#define CSR_MINSTRET_ADR  0xB02
#define CSR_MCYCLEH_ADR  0xB80
#define CSR_MINSTRETH_ADR  0xB82

#define CSR_MVENDORID_ADR  0xF11
#define CSR_MARCHID_ADR  0xF12
#define CSR_MIMPID_ADR  0xF13
#define CSR_MHARTID_ADR  0xF14
#define CSR_MCONFIGPTR_ADR  0xF15
#define CSR_MISA_A  (0x1 << 0)
#define CSR_MISA_B  (0x1 << 1)
#define CSR_MISA_C  (0x1 << 2)
#define CSR_MISA_F  (0x1 << 5)
#define CSR_MISA_I  (0x1 << 8)
#define CSR_MISA_M  (0x1 << 12)
#define CSR_MISA_S  (0x1 << 18)
#define CSR_MISA_U  (0x1 << 20)
#define CSR_MISA_X  (0x1 << 23)
#define CSR_MISA_XLEN_32  (0x1 << 30)
#define CSR_MISA_XLEN_64  (0x2 << 30)

#endif /* CSR_H */
