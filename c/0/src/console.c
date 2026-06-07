
#include "console.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "riscv_emu.h"


void console_putc(char x) {
	console_put_code((uint32_t)x);
}


char console_getc(void) {
	return (char)(uint8_t)console_get_code();
}


void console_put_code(uint32_t x) {
	*(uint8_t *)(void *)RISCV_EMU_CONSOLE_PRINT_CHAR8_ADR = x;
}

uint32_t console_get_code(void) {
	return 0;
}


void console_print_int(int32_t x) {
	*(int32_t *)(void *)RISCV_EMU_CONSOLE_PRINT_INT32_ADR = x;
}


void console_print_uint(uint32_t x) {
	*(uint32_t *)(void *)RISCV_EMU_CONSOLE_PRINT_UINT32_ADR = x;
}


void console_print_uint_hex(uint32_t x) {
	*(uint32_t *)(void *)RISCV_EMU_CONSOLE_PRINT_UINT32_HEX_ADR = x;
}

void console_puts(char *x) {
	uint32_t i = 0;
	while (true) {
		const char c = x[i];
		if (c == '\x0') {
			break;
		}
		console_putc(c);
		i = i + 1;
	}
}

