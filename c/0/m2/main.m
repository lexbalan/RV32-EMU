// hello world for RISC-V in C

import "./console"


func main () -> Int32 {
	console.puts("Hello, RISC-V world!\n")
	return 0
}


@extern("C", "__isr")
func __isr() -> Unit {
	return
}

