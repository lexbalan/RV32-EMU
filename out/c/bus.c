
#include "bus.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "mmio.h"



/* anonymous records */
struct __anonymous_struct_1 {
	uint32_t from;
	uint32_t to;
};


// see mem.ld

#define MMIO_SIZE  (0xFFFF)
#define MMIO_START  (0xF00C0000L)
#define MMIO_END  (MMIO_START + MMIO_SIZE)

static uint8_t ram[BUS_RAM_SIZE];
static uint8_t rom[BUS_ROM_SIZE];


__attribute__((always_inline))
static inline bool isAdressInRegion(uint32_t x, struct __anonymous_struct_1 region);
static uint32_t readFrom(void *ptr, uint32_t adr, uint8_t size);
void bus_memoryViolation(char rw, uint32_t adr);

uint32_t bus_read(uint32_t adr, uint8_t size) {
	if (isAdressInRegion(adr, (struct __anonymous_struct_1)BUS_RAM_REGION)) {
		void *const ramPtr = (void *)&ram[adr - BUS_RAM_START];
		return readFrom(ramPtr, adr, size);
	} else if (isAdressInRegion(adr, (struct __anonymous_struct_1)BUS_ROM_REGION)) {
		void *const romPtr = (void *)&rom[adr - BUS_ROM_START];
		return readFrom(romPtr, adr, size);
	} else if (isAdressInRegion(adr, (struct __anonymous_struct_1)BUS_MMIO_REGION)) {
	} else {
		bus_memoryViolation('r', adr);
	}

	return 0x0;
}



static void writeTo(void *ptr, uint32_t adr, uint32_t value, uint8_t size);

void bus_write(uint32_t adr, uint32_t value, uint8_t size) {
	if (isAdressInRegion(adr, (struct __anonymous_struct_1)BUS_RAM_REGION)) {
		void *const ramPtr = (void *)&ram[adr - BUS_RAM_START];
		writeTo(ramPtr, adr, value, size);
	} else if (isAdressInRegion(adr, (struct __anonymous_struct_1)BUS_MMIO_REGION)) {
		const uint32_t mmioAdr = adr - MMIO_START;
		if (size == 1) {
			mmio_write8(mmioAdr, (uint8_t)value);
		} else if (size == 2) {
			mmio_write16(mmioAdr, (uint16_t)value);
		} else if (size == 4) {
			mmio_write32(mmioAdr, value);
		}
	} else if (isAdressInRegion(adr, (struct __anonymous_struct_1)BUS_ROM_REGION)) {
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
static inline bool isAdressInRegion(uint32_t x, struct __anonymous_struct_1 region) {
	return x >= region.from && x < region.to;
}


uint32_t bus_memviolationCnt = 0;
void bus_memoryViolation(char rw, uint32_t adr) {
	printf("*** MEMORY VIOLATION '%c' 0x%08x ***\n", rw, adr);
	if (bus_memviolationCnt > 10) {
		exit(1);
	}
	bus_memviolationCnt = bus_memviolationCnt + 1;
}



static uint32_t load(char *filename, uint8_t (*bufptr)[], uint32_t buf_size);

uint32_t bus_load_rom(char *filename) {
	return load(filename, &rom, BUS_ROM_SIZE);
}


static uint32_t load(char *filename, uint8_t (*bufptr)[], uint32_t buf_size) {
	printf("LOAD: %s\n", filename);

	FILE *const fp = fopen(filename, "rb");

	if (fp == NULL) {
		printf("error: cannot open file '%s'", filename);
		return 0;
	}

	const size_t n = fread((void *)bufptr, 1, (size_t)buf_size, fp);

	printf("LOADED: %zu bytes\n", n);

	if (BUS_SHOW_TEXT) {
		size_t i = 0;
		while (i < (n / 4)) {
			printf("%08zx: 0x%08x\n", i, (*((uint32_t (*)[])bufptr))[i]);
			i = i + 4;
		}

		printf("-----------\n");
	}

	fclose(fp);

	return (uint32_t)n;
}


void bus_show_ram(void) {
	uint32_t i = 0;
	uint8_t (*const ramptr)[BUS_RAM_SIZE] = &ram;
	while (i < 256) {
		printf("%08X", i * 16);

		uint32_t j = 0;
		while (j < 16) {
			printf(" %02X", (*ramptr)[i + j]);
			j = j + 1;
		}

		printf("\n");

		i = i + 16;
	}
}


