
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "console.h"
extern int32_t print(char *format, ...);

int32_t main(void) {
	console_puts("Hello, RISC-V world!\n");
	return 0;
}

extern void __isr(void) {
	return;
}

