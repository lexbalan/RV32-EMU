import "builtin"
import "bus"
import "hart/hart"
import "hart/csr"
include "stdlib"
include "stdio"

include "libc/stdlib"
include "libc/stdio"
import "bus" as bus
import "hart/hart" as rvHart
import "hart/csr" as csr


const text_filename = "./image.bin"


var hart: Hart


@nonstatic
func main () -> Int {
	printf("RISC-V VM\n")

	let nbytes: Nat32 = bus.load_rom(text_filename)
	if nbytes <= 0 {
		exit(1)
	}

	var busctl = BusInterface {
		read = &bus.read
		write = &bus.write
	}

	rvHart.init(&hart, 0, &busctl)

	printf(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")

	var timer_cnt: Nat32 = 0

	while true {
		if not rvHart.cycle(&hart) {
			break
		}
		timer_cnt = timer_cnt + 1
		if timer_cnt == 1000 {
			timer_cnt = 0
			rvHart.interrupt(&hart, rvHart.intSysTimer)
		}
	}

	printf("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
	printf("mcycle = %u\n", rvHart.getCsr(&hart, csr.mcycle_regno))

	printf("\nCore dump:\n")
	rvHart.show_regs(&hart)
	printf("\n")
	bus.show_ram()

	return 0
}

