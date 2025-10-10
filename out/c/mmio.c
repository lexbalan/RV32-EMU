
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "mmio.h"


#define consoleMMIOAdr  (0x10)
#define consolePutAdr  (consoleMMIOAdr + 0)
#define consoleGetAdr  (consoleMMIOAdr + 1)

#define consolePrintInt32Adr  (consoleMMIOAdr + 0x10)
#define consolePrintUInt32Adr  (consoleMMIOAdr + 0x14)
#define consolePrintInt32HexAdr  (consoleMMIOAdr + 0x18)
#define consolePrintUInt32HexAdr  (consoleMMIOAdr + 0x1C)

#define consolePrintInt64Adr  (consoleMMIOAdr + 0x20)
#define consolePrintUInt64Adr  (consoleMMIOAdr + 0x28)

void mmio_write8(uint32_t adr, uint8_t value) {
	if (adr == consolePutAdr) {
		putchar((int)value);
		return;
	}
}


void mmio_write16(uint32_t adr, uint16_t value) {
	if (adr == consolePutAdr) {
		putchar((int)value);
		return;
	}
}


void mmio_write32(uint32_t adr, uint32_t value) {
	if (adr == consolePutAdr) {
		putchar((int)value);
		return;
	} else if (adr == consolePrintInt32Adr) {
		printf("%u", value);
		return;
	} else if (adr == consolePrintUInt32Adr) {
		printf("%u", value);
		return;
	} else if (adr == consolePrintInt32HexAdr) {
		printf("%x", value);
		return;
	} else if (adr == consolePrintUInt32HexAdr) {
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


