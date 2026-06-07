
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "riscv.h"
#include "console.h"
static volatile uint32_t int_cnt = 0;

extern void __isr(void);

static void init(void) {
	riscv_csrwMtvec((uint32_t)&__isr);
	const uint32_t misa = riscv_csrMisa();
	console_puts("MISA = ");
	console_printNatHex(misa);
	console_puts("\n");
}

int32_t main(void) {
	init();
	console_puts("Hello, RISC-V world!\n");
	while (int_cnt < 5) {
	}
	return 0;
}

extern void __isr(void) {
	console_puts("Interupt handled\n");
	int_cnt = int_cnt + 1;
	return;
}

