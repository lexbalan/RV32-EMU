
.global vectors
.global _stack_start
.global _stack_end
.global _trap
.global __isr
.global __mem_violation
.global trap_empty
.global system
.global _start


.section .isr_vector
.align 8

vectors:
	jr zero, %lo(_start)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(system)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)
	jr zero, %lo(__mem_violation)
	jr zero, %lo(trap_empty)
	jr zero, %lo(trap_empty)



_trap:
	jal ra, __isr
	mret


_start:
	# setup stack pointer
	lui sp, %hi(_stack_start)
	addi sp, sp, %lo(_stack_start)

	# setup mtvec
#	lui a0, %hi(_trap)
#	addi a0, a0, %lo(_trap)
#	csrrw zero, mtvec, a0

	jal ra, startup

	ebreak

	j trap_empty



__mem_violation:
	#j __mem_violation
	ebreak


system:
	ebreak
	mret
	#j system

