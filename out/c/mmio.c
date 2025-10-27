
#include "mmio.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



#define CONSOLE_MMIOADR  (0x10)
#define CONSOLE_PUT_ADR  (CONSOLE_MMIOADR + 0)
#define CONSOLE_GET_ADR  (CONSOLE_MMIOADR + 1)

#define CONSOLE_PRINT_INT32_ADR  (CONSOLE_MMIOADR + 0x10)
#define CONSOLE_PRINT_UINT32_ADR  (CONSOLE_MMIOADR + 0x14)
#define CONSOLE_PRINT_INT32_HEX_ADR  (CONSOLE_MMIOADR + 0x18)
#define CONSOLE_PRINT_UINT32_HEX_ADR  (CONSOLE_MMIOADR + 0x1C)

#define CONSOLE_PRINT_INT64_ADR  (CONSOLE_MMIOADR + 0x20)
#define CONSOLE_PRINT_UINT64_ADR  (CONSOLE_MMIOADR + 0x28)

void mmio_write8(uint32_t adr, uint8_t value) {
	if (adr == CONSOLE_PUT_ADR) {
		putchar((int)value);
		return;
	}
}


void mmio_write16(uint32_t adr, uint16_t value) {
	if (adr == CONSOLE_PUT_ADR) {
		putchar((int)value);
		return;
	}
}


void mmio_write32(uint32_t adr, uint32_t value) {
	if (adr == CONSOLE_PUT_ADR) {
		putchar((int)value);
		return;
	} else if (adr == CONSOLE_PRINT_INT32_ADR) {
		printf("%u", value);
		return;
	} else if (adr == CONSOLE_PRINT_UINT32_ADR) {
		printf("%u", value);
		return;
	} else if (adr == CONSOLE_PRINT_INT32_HEX_ADR) {
		printf("%x", value);
		return;
	} else if (adr == CONSOLE_PRINT_UINT32_HEX_ADR) {
		printf("%ux", value);
		return;
	}
}


uint8_t mmio_read8(uint32_t adr) {
	return 0x0;
}


uint16_t mmio_read16(uint32_t adr) {
	return 0x0;
}


uint32_t mmio_read32(uint32_t adr) {
	return 0x0;
}


