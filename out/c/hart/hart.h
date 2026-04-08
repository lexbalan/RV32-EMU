
#if !defined(HART_H)
#define HART_H
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "decode.h"
#include "csr.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
struct hart_bus_interface;
typedef struct hart_bus_interface hart_BusInterface;
typedef struct hart_hart hart_Hart;
struct hart_hart {
	uint32_t regs[32];
	uint32_t pc;
	hart_BusInterface *bus;
	uint32_t irq;
	bool end;
	uint32_t csrs[4096];
};
struct hart_bus_interface {
	uint32_t (*read)(uint32_t adr, uint8_t size);
	void (*write)(uint32_t adr, uint32_t value, uint8_t size);
};
// branch
// jump and link by register
// fence
// machine return from trap
#define HART_INT_SYS_CALL 8
#define HART_INT_MEM_VIOLATION 11
void hart_init(hart_Hart *hart, uint32_t id, hart_BusInterface *bus);
void hart_cycle(hart_Hart *hart);
void hart_show_regs(hart_Hart *hart);
#endif

