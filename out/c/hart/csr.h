
#if !defined(CSR_H)
#define CSR_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
//
// CSR's
// see: https://five-embeddev.com/riscv-isa-manual/latest/priv-csrs.html
//
#define CSR_MSTATUS_ADR 768
#define CSR_MISA_ADR 769
#define CSR_MEDELEG_ADR 770
#define CSR_MIDELEG_ADR 771
#define CSR_MIE_ADR 772
#define CSR_MTVEC_ADR 773
#define CSR_MCOUNTEREN_ADR 774
// Machine counter enable
#define CSR_MSCRATCH_ADR 832
#define CSR_MEPC_ADR 833
#define CSR_MCAUSE_ADR 834
#define CSR_MTVAL_ADR 835
#define CSR_MIP_ADR 836
#define CSR_MCYCLE_ADR 2816
#define CSR_MINSTRET_ADR 2818
#define CSR_MCYCLEH_ADR 2944
#define CSR_MINSTRETH_ADR 2946
#define CSR_MVENDORID_ADR 3857
#define CSR_MARCHID_ADR 3858
#define CSR_MIMPID_ADR 3859
#define CSR_MHARTID_ADR 3860
#define CSR_MCONFIGPTR_ADR 3861
#define CSR_MISA_A (0x1U << 0)
#define CSR_MISA_B (0x1U << 1)
#define CSR_MISA_C (0x1U << 2)
#define CSR_MISA_F (0x1U << 5)
#define CSR_MISA_I (0x1U << 8)
#define CSR_MISA_M (0x1U << 12)
#define CSR_MISA_S (0x1U << 18)
#define CSR_MISA_U (0x1U << 20)
#define CSR_MISA_X (0x1U << 23)
#define CSR_MISA_XLEN_32 (0x1U << 30)
#define CSR_MISA_XLEN_64 (0x2U << 30)
#endif

