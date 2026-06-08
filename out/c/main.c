
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include "bus.h"
#include "hart.h"
#include "csr.h"
#define TEXT_FILENAME "./image.bin"
static struct hart_hart hart;

int main(void) {
	printf("RISC-V VM\n");
	const uint32_t nbytes = bus_load_rom(TEXT_FILENAME);
	if (nbytes <= 0) {
		exit(1);
	}
	hart_BusInterface busctl = (hart_BusInterface){
		.read = &bus_read,
		.write = &bus_write
	};
	hart_init(&hart, 0, &busctl);
	printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
	uint32_t timer_cnt = 0;
	while (true) {
		if (!hart_cycle(&hart)) {
			break;
		}
		timer_cnt = timer_cnt + 1;
		if (timer_cnt == 1000) {
			timer_cnt = 0;
			hart_interrupt(&hart, HART_INT_SYS_TIMER);
		}
	}
	printf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
	printf("mcycle = %u\n", hart_getCsr(&hart, CSR_MCYCLE_REGNO));
	printf("\nCore dump:\n");
	hart_show_regs(&hart);
	printf("\n");
	bus_show_ram();
	return 0;
}

