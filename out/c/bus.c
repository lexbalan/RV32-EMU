
#include "bus.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>




// see mem.ld

#define MMIO_SIZE  (0xFFFF)
#define MMIO_START  (0xF00C0000UL)
#define MMIO_END  (MMIO_START + MMIO_SIZE)

static uint8_t ram[BUS_RAM_SIZE];
static uint8_t rom[BUS_ROM_SIZE];


static inline bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b);
static uint32_t readFrom(void *ptr, uint32_t adr, uint8_t size);
void bus_memoryViolation(char rw, uint32_t adr);

uint32_t bus_read(uint32_t adr, uint8_t size) {
	if (isAdressInRange(adr, BUS_RAM_START, BUS_RAM_END)) {
		void *const ramPtr = (void *)&ram[adr - BUS_RAM_START];
		return readFrom(ramPtr, adr, size);
	} else if (isAdressInRange(adr, BUS_ROM_START, BUS_ROM_END)) {
		void *const romPtr = (void *)&rom[adr - BUS_ROM_START];
		return readFrom(romPtr, adr, size);
	} else if (isAdressInRange(adr, MMIO_START, MMIO_END)) {
		// MMIO Read
	} else {
		bus_memoryViolation('r', adr);
	}

	return 0x0;
}



static void writeTo(void *ptr, uint32_t adr, uint32_t value, uint8_t size);

void bus_write(uint32_t adr, uint32_t value, uint8_t size) {
	if (isAdressInRange(adr, BUS_RAM_START, BUS_RAM_END)) {
		void *const ramPtr = (void *)&ram[adr - BUS_RAM_START];
		writeTo(ramPtr, adr, value, size);
	} else if (isAdressInRange(adr, MMIO_START, MMIO_END)) {
		const uint32_t mmioAdr = adr - MMIO_START;
		if (size == 1) {
			mmio_write8(mmioAdr, (uint8_t)value);
		} else if (size == 2) {
			mmio_write16(mmioAdr, (uint16_t)value);
		} else if (size == 4) {
			mmio_write32(mmioAdr, value);
		}
	} else if (isAdressInRange(adr, BUS_ROM_START, BUS_ROM_END)) {
		bus_memoryViolation('w', adr);
	} else {
		bus_memoryViolation('w', adr);
	}
}


static uint32_t readFrom(void *ptr, uint32_t adr, uint8_t size) {
	if (size == 1) {
		return (uint32_t)*((uint8_t *)ptr);
	} else if (size == 2) {
		return (uint32_t)*((uint16_t *)ptr);
	} else if (size == 4) {
		return *((uint32_t *)ptr);
	}
	return 0x0;
}


static void writeTo(void *ptr, uint32_t adr, uint32_t value, uint8_t size) {
	if (size == 1) {
		*((uint8_t *)ptr) = (uint8_t)value;
	} else if (size == 2) {
		*((uint16_t *)ptr) = (uint16_t)value;
	} else if (size == 4) {
		*((uint32_t *)ptr) = value;
	}
}


__attribute__((always_inline))
static inline bool isAdressInRange(uint32_t x, uint32_t a, uint32_t b) {
	return x >= a && x < b;
}


uint32_t bus_memviolationCnt = 0;
void bus_memoryViolation(char rw, uint32_t adr) {
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr);
	if (bus_memviolationCnt > 10) {
		exit(1);
	}
	bus_memviolationCnt = bus_memviolationCnt + 1;
	//	memoryViolation_event(0x55) // !
}



static uint32_t load(char *filename, uint8_t *bufptr, uint32_t buf_size);

uint32_t bus_load_rom(char *filename) {
	return load(filename, (uint8_t *)&rom, BUS_ROM_SIZE);
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

	if (BUS_SHOW_TEXT) {
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


void bus_show_ram(void) {
	uint32_t i = 0;
	uint8_t *const ramptr = (uint8_t *)&ram;
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


