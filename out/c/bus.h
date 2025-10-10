//
//

#ifndef BUS_H
#define BUS_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include "mmio.h"
#define bus_ramSize  (16 * 1024)
#define bus_ramStart  (0x10000000)
#define bus_ramEnd  (bus_ramStart + bus_ramSize)

#define bus_romSize  (0x100000)
#define bus_romStart  (0x0)
#define bus_romEnd  (bus_romStart + bus_romSize)
uint32_t bus_read(uint32_t adr, uint8_t size);
void bus_write(uint32_t adr, uint32_t value, uint8_t size);
uint32_t bus_load_rom(char *filename);
void bus_show_ram();

#endif /* BUS_H */
