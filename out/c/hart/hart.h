/*
 * RV32IM simple software implementation
 */

#ifndef HART_H
#define HART_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "decode.h"
#include "csr.h"



struct hart_BusInterface;
typedef struct hart_BusInterface hart_BusInterface;
struct hart_Hart {
	uint32_t regs[32];
	uint32_t pc;
	hart_BusInterface *bus;
	uint32_t irq;
	bool end;
	uint32_t csrs[4096];
};
typedef struct hart_Hart hart_Hart;

struct hart_BusInterface {
	uint32_t(*read)(uint32_t adr, uint8_t size);
	void(*write)(uint32_t adr, uint32_t value, uint8_t size);
};

#define HART_INT_SYS_CALL  0x8
#define HART_INT_MEM_VIOLATION  0xB
void hart_init(hart_Hart *hart, uint32_t id, hart_BusInterface *bus);
void hart_cycle(hart_Hart *hart);
void hart_show_regs(hart_Hart *hart);

#endif /* HART_H */
