
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
struct hart_hart {
	uint32_t regs[32];
	uint32_t pc;
	hart_BusInterface *bus;

	bool end;
	uint32_t csrs[4096];
};
void hart_interrupt(struct hart_hart *hart, uint32_t int_num);
typedef struct hart_bus_interface hart_BusInterface;
struct hart_bus_interface {
	uint32_t (*read)(uint32_t adr, uint8_t size);
	void (*write)(uint32_t adr, uint32_t value, uint8_t size);
};
// branch
// jump and link by register
// fence
// machine return from trap
#define HART_INT_SYS_TIMER 0x01
#define HART_INT_SYS_CALL 0x08
#define HART_INT_MEM_VIOLATION 0x0B
void hart_init(struct hart_hart *hart, uint32_t id, hart_BusInterface *bus);
bool hart_cycle(struct hart_hart *hart);
uint32_t hart_getCsr(struct hart_hart *hart, uint16_t csrno);
void hart_setCsr(struct hart_hart *hart, uint16_t csrno, uint32_t value);
void hart_show_regs(struct hart_hart *hart);
#endif

