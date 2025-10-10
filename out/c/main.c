
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "main.h"


#define text_filename  "./image.bin"

static hart_Hart hart;

int main() {
	printf("RISC-V VM\n");

	const uint32_t nbytes = bus_load_rom(text_filename);
	if (nbytes <= 0) {
		exit(1);
	}

	hart_BusInterface busctl = (hart_BusInterface){
		.read = &bus_read,
		.write = &bus_write
	};

	hart_init(&hart, 0, &busctl);

	printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");

	while (!hart.end) {
		hart_cycle(&hart);
	}

	printf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
	printf("mcycle = %u\n", hart.csrs[csr_csr_mcycle_adr]);

	printf("\nCore dump:\n");
	hart_show_regs(&hart);
	printf("\n");
	bus_show_ram();

	return 0;
}


