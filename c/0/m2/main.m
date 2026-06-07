// hello world for RISC-V in C

pragma unsafe

import "./riscv"
import "./console"

var int_cnt: @volatile Nat32 = 0


func init () -> Unit {
	//console.init()
	riscv.csrwMtvec(unsafe Word32 &__isr)
	return
}

func main () -> Int32 {
	init()
	console.puts("Hello, RISC-V world!\n")
	while int_cnt < 5 {
		//console.puts("Waiting for interrupt...\n")
	}
	return 0
}


@extern("C", "__isr")
func __isr() -> Unit {
	console.puts("Interupt handled\n")
	++int_cnt
	//while true {
		// Wait for interrupt to be handled
	//}
	return
}

