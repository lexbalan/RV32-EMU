
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "bus.h"
#include "hart.h"
#include "csr.h"
#define TEXT_FILENAME "./image.bin"
static hart_Hart hart;

int main(void) {
	printf("RISC-V VM\n");
	const uint32_t nbytes = bus_load_rom(TEXT_FILENAME);
	if (nbytes <= 0U) {
		exit(1);
	}
	hart_BusInterface busctl = (hart_BusInterface){
		.read = &bus_read,
		.write = &bus_write
	};
	hart_init(&hart, 0U, &busctl);
	printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
	while (!hart.end) {
		hart_cycle(&hart);
	}
	printf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
	printf("mcycle = %u\n", hart.csrs[(uint32_t)CSR_MCYCLE_ADR]);
	printf("\nCore dump:\n");
	hart_show_regs(&hart);
	printf("\n");
	bus_show_ram();
	return 0;
}

