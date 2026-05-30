
#if !defined(BUS_H)
#define BUS_H
#include <stdio.h>
#include <stdlib.h>
#include "mmio.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
uint32_t bus_read(uint32_t adr, uint8_t size);
void bus_write(uint32_t adr, uint32_t value, uint8_t size);
void bus_memoryViolation(char rw, uint32_t adr);
uint32_t bus_load_rom(char *filename);
void bus_show_ram(void);
#endif

