
#ifndef MMIO_H
#define MMIO_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>

void mmio_write8(uint32_t adr, uint8_t value);
void mmio_write16(uint32_t adr, uint16_t value);
void mmio_write32(uint32_t adr, uint32_t value);
uint8_t mmio_read8(uint32_t adr);
uint16_t mmio_read16(uint32_t adr);
uint32_t mmio_read32(uint32_t adr);

#endif /* MMIO_H */
