
#include <stdint.h>
#include <stdarg.h>

#include "../sys/printf.h"
#include "../sys/console.h"
#include "../sys/system.h"
#include "../sys/base.h"
#include "../sys/vm_sys.h"


volatile int __mtrap_flag = 0;

int main() {
	printf("Hello World!\n");

	//asm("ecall");

	if (__mtrap_flag) {
		printf("Machine trap occurred!\n");
	} else {
		printf("No machine trap occurred.\n");
	}

	//asm("ebreak");

	return 0;
}


// This function is called when a machine trap occurs.
// It is defined in the assembly file vect.S and linked to the mtvec register.
void __isr() {
	__mtrap_flag = 1;
}


