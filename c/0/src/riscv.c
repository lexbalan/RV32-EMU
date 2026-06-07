
#include "riscv.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


uint32_t riscv_csrwMtvec(uint32_t adr) {
	uint32_t old;
	__asm__ volatile ("csrw mtvec, %0" : "=r" (old) : "r" (adr) :);
	return old;
}

