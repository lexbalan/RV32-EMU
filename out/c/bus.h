
#ifndef BUS_H
#define BUS_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include "mmio.h"


#define BUS_SHOW_TEXT  false
#define BUS_RAM_SIZE  (16 * 1024)
#define BUS_RAM_START  (0x10000000)
#define BUS_RAM_END  (BUS_RAM_START + BUS_RAM_SIZE)

#define BUS_ROM_SIZE  (0x100000)
#define BUS_ROM_START  (0x0)
#define BUS_ROM_END  (BUS_ROM_START + BUS_ROM_SIZE)
uint32_t bus_read(uint32_t adr, uint8_t size);
void bus_write(uint32_t adr, uint32_t value, uint8_t size);

extern uint32_t bus_memviolationCnt;
void bus_memoryViolation(char rw, uint32_t adr);
uint32_t bus_load_rom(char *filename);
void bus_show_ram(void);

#endif /* BUS_H */
