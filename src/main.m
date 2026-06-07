include "libc/stdlib"
include "libc/stdio"

import "bus"
import "hart/hart" as rvHart
import "hart/csr" as csr


const text_filename = "./image.bin"


var hart: rvHart.Hart


func main () -> Int {
	printf("RISC-V VM\n")

	let nbytes = bus.load_rom(text_filename)
	if nbytes <= 0 {
		exit(1)
	}

	var busctl = rvHart.BusInterface {
		read = &bus.read
		write = &bus.write
	}

	rvHart.init(&hart, 0, &busctl)

	printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")

	var timer_cnt: Nat32 = 0

	while true {
		// Hart beat
		if not rvHart.cycle(&hart) {
			break
		}

		// Generate timer interrupt (intSysTimer)
		++timer_cnt
		if timer_cnt == 1000 {
			timer_cnt = 0
			//printf("Timer interrupt generated\n")
			hart.irq = hart.irq | rvHart.intSysTimer
		}
	}

	printf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
	printf("mcycle = %u\n", hart.csrs[Nat32 csr.mcycle_adr])

	printf("\nCore dump:\n")
	rvHart.show_regs(&hart)
	printf("\n")
	bus.show_ram()

	return 0
}



