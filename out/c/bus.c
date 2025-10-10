//
//

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "bus.h"


#define showText  false

// see mem.ld

#define mmioSize  (0xFFFF)
#define mmioStart  (0xF00C0000UL)
#define mmioEnd  (mmioStart + mmioSize)

static uint8_t rom[bus_romSize];
static uint8_t ram[bus_ramSize];


static inline bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b);
static void memoryViolation(char rw, uint32_t adr);

uint32_t bus_read(uint32_t adr, uint8_t size) {
	if (isAdressInRange(adr, bus_ramStart, bus_ramEnd)) {
		if (size == 1) {
			uint8_t *const ptr = (uint8_t *)&ram[adr - bus_ramStart];
			return (uint32_t)*ptr;
		} else if (size == 2) {
			uint16_t *const ptr = (uint16_t *)&ram[adr - bus_ramStart];
			return (uint32_t)*ptr;
		} else if (size == 4) {
			uint32_t *const ptr = (uint32_t *)&ram[adr - bus_ramStart];
			return *ptr;
		}
	} else if (isAdressInRange(adr, bus_romStart, bus_romEnd)) {
		if (size == 1) {
			uint8_t *const ptr = (uint8_t *)&rom[adr - bus_romStart];
			return (uint32_t)*ptr;
		} else if (size == 2) {
			uint16_t *const ptr = (uint16_t *)&rom[adr - bus_romStart];
			return (uint32_t)*ptr;
		} else if (size == 4) {
			uint32_t *const ptr = (uint32_t *)&rom[adr - bus_romStart];
			return *ptr;
		}
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		// MMIO Read
	} else {
		memoryViolation('r', adr);
	}

	return 0x0;
}


void bus_write(uint32_t adr, uint32_t value, uint8_t size) {
	if (isAdressInRange(adr, bus_ramStart, bus_ramEnd)) {
		if (size == 1) {
			uint8_t *const ptr = (uint8_t *)&ram[adr - bus_ramStart];
			*ptr = (uint8_t)value;
		} else if (size == 2) {
			uint16_t *const ptr = (uint16_t *)&ram[adr - bus_ramStart];
			*ptr = (uint16_t)value;
		} else if (size == 4) {
			uint32_t *const ptr = (uint32_t *)&ram[adr - bus_ramStart];
			*ptr = value;
		}
	} else if (isAdressInRange(adr, mmioStart, mmioEnd)) {
		if (size == 1) {
			mmio_write8(adr - mmioStart, (uint8_t)value);
		} else if (size == 2) {
			mmio_write16(adr - mmioStart, (uint16_t)value);
		} else if (size == 4) {
			mmio_write32(adr - mmioStart, value);
		}
	} else if (isAdressInRange(adr, bus_romStart, bus_romEnd)) {
		memoryViolation('w', adr);
	} else {
		memoryViolation('w', adr);
	}
}


__attribute__((always_inline))
static inline bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b) {
	return x >= a && x < b;
}


static uint32_t memviolationCnt = 0;
static void memoryViolation(char rw, uint32_t adr) {
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr);
	if (memviolationCnt > 10) {
		exit(1);
	}
	memviolationCnt = memviolationCnt + 1;
	//	memoryViolation_event(0x55) // !
}



static uint32_t load(char *filename, uint8_t *bufptr, uint32_t buf_size);

uint32_t bus_load_rom(char *filename) {
	return load(filename, (uint8_t *)&rom, bus_romSize);
}


static uint32_t load(char *filename, uint8_t *bufptr, uint32_t buf_size) {
	printf("LOAD: %s\n", filename);

	FILE *const fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return 0;
	}

	const size_t n = fread(bufptr, 1, (size_t)buf_size, fp);

	printf("LOADED: %zu bytes\n", n);

	if (showText) {
		size_t i = 0;
		while (i < (n / 4)) {
			printf("%08zx: 0x%08x\n", i, ((uint32_t *)bufptr)[i]);
			i = i + 4;
		}

		printf("-----------\n");
	}

	fclose(fp);

	return (uint32_t)n;
}


void bus_show_ram() {
	uint32_t i = 0;
	uint8_t *const ramptr = &ram;
	while (i < 256) {
		printf("%08X", i * 16);

		uint32_t j = 0;
		while (j < 16) {
			printf(" %02X", ramptr[i + j]);
			j = j + 1;
		}

		printf("\n");

		i = i + 16;
	}
}


