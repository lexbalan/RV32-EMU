
#if !defined(RISCV_H)
#define RISCV_H
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
uint32_t riscv_csrwMtvec(uint32_t adr);
uint32_t riscv_csrMisa(void);
#endif

