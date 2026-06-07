
//#include "../sys/printf.h"
//#include "../sys/console.h"
//#include "../sys/system.h"
//#include "../sys/base.h"
//#include "../sys/vm_sys.h"

import "./console"

@extern("C", "print")
func print(format: *Str8, ...) -> Int32

func main () -> Int32 {
	//print("Hello, RISC-V world!\n")
	console.puts("Hello, RISC-V world!\n")
	return 0
}

@extern("C", "__isr")
func __isr() -> Unit {
	return
}

