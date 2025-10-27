/*
 * RV32IM simple software implementation
 */

#include "hart.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include <stdarg.h>


#define TRACE_MODE  false

#define OP_L  0x3  // load
#define OP_I  0x13  // immediate
#define OP_S  0x23  // store
#define OP_R  0x33  // reg
#define OP_B  0x63  // branch

#define OP_LUI  0x37  // load upper immediate
#define OP_AUIPC  0x17  // add upper immediate to PC
#define OP_JAL  0x6F  // jump and link
#define OP_JALR  0x67  // jump and link by register

#define OP_SYSTEM  0x73  // system
#define OP_FENCE  0xF  // fence

#define INSTR_ECALL  (OP_SYSTEM | 0x0)
#define INSTR_EBREAK  (OP_SYSTEM | 0x100000)
#define INSTR_PAUSE  (OP_FENCE | 0x1000000)
#define INSTR_MRET  (OP_SYSTEM | 0x30200073)  // machine return from trap

// funct3 for CSR
#define FUNCT3_CSRRW  1
#define FUNCT3_CSRRS  2
#define FUNCT3_CSRRC  3
#define FUNCT3_CSRRWI  4
#define FUNCT3_CSRRSI  5
#define FUNCT3_CSRRCI  6

void hart_init(hart_Hart *hart, uint32_t id, hart_BusInterface *bus) {
	printf("hart #%d init\n", id);
	hart->csrs[CSR_CSR_MHARTID_ADR] = id;
	hart->csrs[CSR_CSR_MISA_ADR] = CSR_CSR_MISA_XLEN_32 | CSR_CSR_MISA_I | CSR_CSR_MISA_M;
	memset(&hart->regs, 0, sizeof(uint32_t[32]));
	hart->pc = 0;
	hart->bus = bus;
	hart->irq = 0x0;
	hart->end = false;
}


__attribute__((always_inline))
static inline uint32_t fetch(hart_Hart *hart) {
	return hart->bus->read(hart->pc, 4);
}



static void trace(uint32_t pc, char *form, ...);
static void exec(hart_Hart *hart, uint32_t instr);

void hart_cycle(hart_Hart *hart) {
	if (hart->irq != 0x0) {
		trace(hart->pc, "\nINT #%02X\n", hart->irq);
		const uint32_t adr = hart->csrs[CSR_CSR_MTVEC_ADR];
		printf("ADR = %08X\n", adr);
		//let vect_offset = Nat32 hart.irq * 4
		hart->csrs[CSR_CSR_MEPC_ADR] = hart->pc;
		hart->csrs[CSR_CSR_MCAUSE_ADR] = 0x0;
		hart->csrs[CSR_CSR_MTVAL_ADR] = 0x0;
		hart->pc = adr;

		hart->irq = 0x0;
	}

	const uint32_t instr = fetch(hart);
	exec(hart, instr);

	// count mcycle
	hart->csrs[CSR_CSR_MCYCLE_ADR] = (hart->csrs[CSR_CSR_MCYCLE_ADR] + 1);
}



static void execI(hart_Hart *hart, uint32_t instr);
static void execR(hart_Hart *hart, uint32_t instr);
static void execLUI(hart_Hart *hart, uint32_t instr);
static void execAUIPC(hart_Hart *hart, uint32_t instr);
static void execJAL(hart_Hart *hart, uint32_t instr);
static void execJALR(hart_Hart *hart, uint32_t instr);
static void execB(hart_Hart *hart, uint32_t instr);
static void execL(hart_Hart *hart, uint32_t instr);
static void execS(hart_Hart *hart, uint32_t instr);
static void execSystem(hart_Hart *hart, uint32_t instr);
static void execFence(hart_Hart *hart, uint32_t instr);

static void exec(hart_Hart *hart, uint32_t instr) {
	const uint8_t op = decode_extract_op(instr);
	const uint8_t funct3 = decode_extract_funct3(instr);

	hart->regs[0] = 0x0;

	if (op == OP_I) {
		execI(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_R) {
		execR(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_LUI) {
		execLUI(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_AUIPC) {
		execAUIPC(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_JAL) {
		execJAL(hart, instr);
	} else if (op == OP_JALR && funct3 == 0x0) {
		execJALR(hart, instr);
	} else if (op == OP_B) {
		execB(hart, instr);
	} else if (op == OP_L) {
		execL(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_S) {
		execS(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_SYSTEM) {
		execSystem(hart, instr);
		hart->pc = hart->pc + 4;
	} else if (op == OP_FENCE) {
		execFence(hart, instr);
		hart->pc = hart->pc + 4;
	} else {
		trace(hart->pc, "UNKNOWN OPCODE: %08X\n", op);
	}
}


// Immediate instructions
static void execI(hart_Hart *hart, uint32_t instr) {
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const int32_t imm = decode_expand12(decode_extract_imm12(instr));
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);

	if (funct3 == 0x0) {
		/* Add immediate */

		trace(hart->pc, "addi x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = (uint32_t)((int32_t)hart->regs[rs1] + imm);
	} else if (funct3 == 0x1 && funct7 == 0x0) {
		/* SLLI is a logical left shift (zeros are shifted
		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). */

		trace(hart->pc, "slli x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = hart->regs[rs1] << (uint8_t)abs((int)imm);
	} else if (funct3 == 0x2) {
		/* SLTI - set [1 to rd if rs1] less than immediate */

		trace(hart->pc, "slti x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = (uint32_t)((int32_t)hart->regs[rs1] < imm);
	} else if (funct3 == 0x3) {
		trace(hart->pc, "sltiu x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = (uint32_t)(hart->regs[rs1] < (uint32_t)abs((int)imm));
	} else if (funct3 == 0x4) {
		trace(hart->pc, "xori x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = hart->regs[rs1] ^ (uint32_t)imm;
	} else if (funct3 == 0x5 && funct7 == 0x0) {
		trace(hart->pc, "srli x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = (hart->regs[rs1] >> (uint8_t)abs((int)imm));
	} else if (funct3 == 0x5 && funct7 == 0x20) {
		trace(hart->pc, "srai x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = hart->regs[rs1] >> (uint8_t)abs((int)imm);
	} else if (funct3 == 0x6) {
		trace(hart->pc, "ori x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = hart->regs[rs1] | (uint32_t)imm;
	} else if (funct3 == 0x7) {
		trace(hart->pc, "andi x%d, x%d, %d\n", rd, rs1, imm);

		//
		hart->regs[rd] = hart->regs[rs1] & (uint32_t)imm;
	}
}


// Register to register

static void notImplemented(char *form, ...);

static void execR(hart_Hart *hart, uint32_t instr) {
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint32_t v0 = hart->regs[rs1];
	const uint32_t v1 = hart->regs[rs2];

	if (funct7 == 0x1) {

		//
		// "M" extension
		//

		if (funct3 == 0x0) {
			// MUL rd, rs1, rs2
			trace(hart->pc, "mul x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->regs[rd] = (uint32_t)((int32_t)v0 * (int32_t)v1);
		} else if (funct3 == 0x1) {
			// MULH rd, rs1, rs2
			// Записывает в целевой регистр старшие биты
			// которые бы не поместились в него при обычном умножении
			trace(hart->pc, "mulh x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->regs[rd] = (uint32_t)((uint64_t)((int64_t)v0 * (int64_t)v1) >> 32);
		} else if (funct3 == 0x2) {
			// MULHSU rd, rs1, rs2
			// mul high signed unsigned
			trace(hart->pc, "mulhsu x%d, x%d, x%d\n", rd, rs1, rs2);

			// NOT IMPLEMENTED!
			notImplemented("mulhsu x%d, x%d, x%d", rd, rs1, rs2);
			//hart.regs[rd] = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)
		} else if (funct3 == 0x3) {
			// MULHU rd, rs1, rs2
			trace(hart->pc, "mulhu x%d, x%d, x%d\n", rd, rs1, rs2);

			// multiply unsigned high
			notImplemented("mulhu x%d, x%d, x%d\n", rd, rs1, rs2);
			//hart.regs[rd] = unsafe Word32 (Word64 (Nat64 v0 * Nat64 v1) >> 32)
		} else if (funct3 == 0x4) {
			// DIV rd, rs1, rs2
			trace(hart->pc, "div x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->regs[rd] = (uint32_t)((int32_t)v0 / (int32_t)v1);
		} else if (funct3 == 0x5) {
			// DIVU rd, rs1, rs2
			trace(hart->pc, "divu x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->regs[rd] = (v0 / v1);
		} else if (funct3 == 0x6) {
			// REM rd, rs1, rs2
			trace(hart->pc, "rem x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->regs[rd] = (uint32_t)((int32_t)v0 % (int32_t)v1);
		} else if (funct3 == 0x7) {
			// REMU rd, rs1, rs2
			trace(hart->pc, "remu x%d, x%d, x%d\n", rd, rs1, rs2);

			hart->regs[rd] = (v0 % v1);
		}

		return;
	}

	if (funct3 == 0x0 && funct7 == 0x0) {
		trace(hart->pc, "add x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = (uint32_t)((int32_t)v0 + (int32_t)v1);
	} else if (funct3 == 0x0 && funct7 == 0x20) {
		trace(hart->pc, "sub x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = (uint32_t)((int32_t)v0 - (int32_t)v1);
	} else if (funct3 == 0x1) {
		// shift left logical

		trace(hart->pc, "sll x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		//printf("?%x\n", v0)
		hart->regs[rd] = v0 << (uint8_t)v1;
	} else if (funct3 == 0x2) {
		// set less than

		trace(hart->pc, "slt x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = (uint32_t)((int32_t)v0 < (int32_t)v1);
	} else if (funct3 == 0x3) {
		// set less than unsigned

		trace(hart->pc, "sltu x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = (uint32_t)(v0 < v1);
	} else if (funct3 == 0x4) {

		trace(hart->pc, "xor x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = v0 ^ v1;
	} else if (funct3 == 0x5 && funct7 == 0x0) {
		// shift right logical

		trace(hart->pc, "srl x%d, x%d, x%d\n", rd, rs1, rs2);

		hart->regs[rd] = v0 >> (uint8_t)v1;
	} else if (funct3 == 0x5 && funct7 == 0x20) {
		// shift right arithmetical

		trace(hart->pc, "sra x%d, x%d, x%d\n", rd, rs1, rs2);

		// ERROR: не реализован арифм сдвиг!
		//hart.regs[rd] = v0 >> Int32 v1
	} else if (funct3 == 0x6) {
		trace(hart->pc, "or x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = v0 | v1;
		//printf("=%08x (%08x, %08x)\n", hart.regs[rd], v0, v1)
	} else if (funct3 == 0x7) {
		trace(hart->pc, "and x%d, x%d, x%d\n", rd, rs1, rs2);

		//
		hart->regs[rd] = v0 & v1;
		//printf("=%08x (%08x, %08x)\n", hart.regs[rd], v0, v1)
	}
}


// Load upper immediate
static void execLUI(hart_Hart *hart, uint32_t instr) {

	const uint32_t imm = decode_extract_imm31_12(instr);
	const uint8_t rd = decode_extract_rd(instr);

	trace(hart->pc, "lui x%d, 0x%X\n", rd, imm);

	hart->regs[rd] = imm << 12;
}


// Add upper immediate to PC
static void execAUIPC(hart_Hart *hart, uint32_t instr) {
	const int32_t imm = decode_expand12(decode_extract_imm31_12(instr));
	const uint32_t x = hart->pc + ((uint32_t)imm << 12);
	const uint8_t rd = decode_extract_rd(instr);

	trace(hart->pc, "auipc x%d, 0x%X\n", rd, imm);

	hart->regs[rd] = x;
}


// Jump and link
static void execJAL(hart_Hart *hart, uint32_t instr) {
	const uint8_t rd = decode_extract_rd(instr);
	const uint32_t raw_imm = decode_extract_jal_imm(instr);
	const int32_t imm = decode_expand20(raw_imm);

	trace(hart->pc, "jal x%d, %d\n", rd, imm);

	hart->regs[rd] = (hart->pc + 4);
	hart->pc = (uint32_t)abs((int)((int32_t)hart->pc + imm));
}


// Jump and link (by register)
static void execJALR(hart_Hart *hart, uint32_t instr) {
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const int32_t imm = decode_expand12(decode_extract_imm12(instr));

	trace(hart->pc, "jalr %d(x%d)\n", imm, rs1);

	// rd <- pc + 4
	// pc <- (rs1 + imm) & ~1

	const int32_t next_instr_ptr = (int32_t)(hart->pc + 4);
	const uint32_t nexpc = (uint32_t)((int32_t)hart->regs[rs1] + imm) & 0xFFFFFFFEUL;
	hart->regs[rd] = (uint32_t)next_instr_ptr;
	hart->pc = nexpc;
}


// Branch instructions
static void execB(hart_Hart *hart, uint32_t instr) {
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);
	const int16_t imm = decode_extract_b_imm(instr);

	uint32_t nexpc = hart->pc + 4;

	if (funct3 == 0x0) {
		// BEQ - Branch if equal

		trace(hart->pc, "beq x%d, x%d, %d\n", rs1, rs2, imm);

		// Branch if two registers are equal
		if (hart->regs[rs1] == hart->regs[rs2]) {
			nexpc = (uint32_t)abs((int)((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 0x1) {
		// BNE - Branch if not equal

		trace(hart->pc, "bne x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (hart->regs[rs1] != hart->regs[rs2]) {
			nexpc = (uint32_t)abs((int)((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 0x4) {
		// BLT - Branch if less than (signed)

		trace(hart->pc, "blt x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)hart->regs[rs1] < (int32_t)hart->regs[rs2]) {
			nexpc = (uint32_t)abs((int)((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 0x5) {
		// BGE - Branch if greater or equal (signed)

		trace(hart->pc, "bge x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if ((int32_t)hart->regs[rs1] >= (int32_t)hart->regs[rs2]) {
			nexpc = (uint32_t)abs((int)((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 0x6) {
		// BLTU - Branch if less than (unsigned)

		trace(hart->pc, "bltu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (hart->regs[rs1] < hart->regs[rs2]) {
			nexpc = (uint32_t)abs((int)((int32_t)hart->pc + (int32_t)imm));
		}
	} else if (funct3 == 0x7) {
		// BGEU - Branch if greater or equal (unsigned)

		trace(hart->pc, "bgeu x%d, x%d, %d\n", rs1, rs2, imm);

		//
		if (hart->regs[rs1] >= hart->regs[rs2]) {
			nexpc = (uint32_t)abs((int)((int32_t)hart->pc + (int32_t)imm));
		}
	}

	hart->pc = nexpc;
}


// Load instructions
static void execL(hart_Hart *hart, uint32_t instr) {
	const uint8_t funct3 = decode_extract_funct3(instr);
	const int32_t imm = decode_expand12(decode_extract_imm12(instr));
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint32_t adr = (uint32_t)abs((int)((int32_t)hart->regs[rs1] + imm));

	if (funct3 == 0x0) {
		// LB (Load 8-bit signed integer value)

		trace(hart->pc, "lb x%d, %d(x%d)\n", rd, imm, rs1);

		hart->regs[rd] = hart->bus->read(adr, 1);
	} else if (funct3 == 0x1) {
		// LH (Load 16-bit signed integer value)

		trace(hart->pc, "lh x%d, %d(x%d)\n", rd, imm, rs1);

		hart->regs[rd] = hart->bus->read(adr, 2);
	} else if (funct3 == 0x2) {
		// LW (Load 32-bit signed integer value)

		trace(hart->pc, "lw x%d, %d(x%d)\n", rd, imm, rs1);

		hart->regs[rd] = hart->bus->read(adr, 4);
	} else if (funct3 == 0x4) {
		// LBU (Load 8-bit unsigned integer value)

		trace(hart->pc, "lbu x%d, %d(x%d)\n", rd, imm, rs1);

		hart->regs[rd] = hart->bus->read(adr, 1);
	} else if (funct3 == 0x5) {
		// LHU (Load 16-bit unsigned integer value)

		trace(hart->pc, "lhu x%d, %d(x%d)\n", rd, imm, rs1);

		hart->regs[rd] = hart->bus->read(adr, 2);
	}
}


// Store instructions
static void execS(hart_Hart *hart, uint32_t instr) {
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t funct7 = decode_extract_funct7(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint8_t rs2 = decode_extract_rs2(instr);

	const uint32_t imm4to0 = (uint32_t)rd;
	const uint32_t imm11to5 = (uint32_t)funct7;
	const uint32_t _imm = (imm11to5 << 5) | imm4to0;
	const int32_t imm = decode_expand12(_imm);

	const uint32_t adr = (uint32_t)((int32_t)hart->regs[rs1] + imm);
	const uint32_t val = hart->regs[rs2];

	if (funct3 == 0x0) {
		// SB (save 8-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart->pc, "sb x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		hart->bus->write(adr, val, 1);
	} else if (funct3 == 0x1) {
		// SH (save 16-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart->pc, "sh x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		hart->bus->write(adr, val, 2);
	} else if (funct3 == 0x2) {
		// SW (save 32-bit value)
		// <source:reg>, <offset:12bit_imm>(<address:reg>)

		trace(hart->pc, "sw x%d, %d(x%d)\n", rs2, imm, rs1);

		//
		hart->bus->write(adr, val, 4);
	}
}



static void csr_rw(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rs(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rc(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1);
static void csr_rwi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm);
static void csr_rsi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm);
static void csr_rci(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm);

static void execSystem(hart_Hart *hart, uint32_t instr) {
	const uint8_t funct3 = decode_extract_funct3(instr);
	const uint8_t rd = decode_extract_rd(instr);
	const uint8_t rs1 = decode_extract_rs1(instr);
	const uint16_t csr = (uint16_t)decode_extract_imm12(instr);

	printf("SYSTEM INSTRUCTION: instr=0x%08X\n", instr);
	if (instr == INSTR_ECALL) {
		trace(hart->pc, "ecall\n");
		printf("ECALL: hart #%d\n", hart->csrs[CSR_CSR_MHARTID_ADR]);
		//
		hart->irq = hart->irq | HART_INT_SYS_CALL;
	} else if (instr == INSTR_MRET) {
		trace(hart->pc, "mret\n");
		// Machine return from trap
		const uint32_t mepc = hart->csrs[CSR_CSR_MEPC_ADR];
		const uint32_t mcause = hart->csrs[CSR_CSR_MCAUSE_ADR];
		const uint32_t mtval = hart->csrs[CSR_CSR_MTVAL_ADR];
		printf("MRET: hart #%d, mepc=%08X, mcause=%08X, mtval=%08X\n",
			hart->csrs[CSR_CSR_MHARTID_ADR],
			mepc, mcause, mtval
		);
		hart->pc = mepc;
	} else if (instr == INSTR_EBREAK) {
		trace(hart->pc, "ebreak\n");
		hart->end = true;

		// CSR instructions
	} else if (funct3 == FUNCT3_CSRRW) {
		// CSR read & write
		csr_rw(hart, csr, rd, rs1);
	} else if (funct3 == FUNCT3_CSRRS) {
		// CSR read & set bit
		const uint8_t mask_reg = rs1;
		csr_rs(hart, csr, rd, mask_reg);
	} else if (funct3 == FUNCT3_CSRRC) {
		// CSR read & clear bit
		const uint8_t mask_reg = rs1;
		csr_rc(hart, csr, rd, mask_reg);
	} else if (funct3 == FUNCT3_CSRRWI) {
		const uint8_t imm = rs1;
		csr_rwi(hart, csr, rd, imm);
	} else if (funct3 == FUNCT3_CSRRSI) {
		const uint8_t imm = rs1;
		csr_rsi(hart, csr, rd, imm);
	} else if (funct3 == FUNCT3_CSRRCI) {
		const uint8_t imm = rs1;
		csr_rci(hart, csr, rd, imm);
	} else {
		trace(hart->pc, "UNKNOWN SYSTEM INSTRUCTION: 0x%x\n", instr);
		hart->end = true;
	}
}


static void execFence(hart_Hart *hart, uint32_t instr) {
	if (instr == INSTR_PAUSE) {
		trace(hart->pc, "PAUSE\n");
	}
}


/*
The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
*/
static void csr_rw(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1) {
	printf("CSR_RW(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1);
	const uint32_t nv = hart->regs[rs1];
	hart->regs[rd] = hart->csrs[csr];
	hart->csrs[csr] = nv;
}


/*
The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
static void csr_rs(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1) {
	// csrrs rd, csr, rs
	//printf("CSR_RS(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	const uint32_t set = hart->regs[rs1];
	hart->regs[rd] = hart->csrs[csr];
	hart->csrs[csr] = hart->csrs[csr] | hart->regs[rs1];
}


/*
The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
*/
static void csr_rc(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t rs1) {
	// csrrc rd, csr, rs
	//printf("CSR_RC(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	const uint32_t set = hart->regs[rs1];
	hart->regs[rd] = hart->csrs[csr];
	hart->csrs[csr] = hart->csrs[csr] & ~hart->regs[rs1];
}


// read+write immediate(5-bit)
static void csr_rwi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm) {
	const uint32_t imm32 = (uint32_t)imm;
	//printf("CSR_RWI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
	hart->regs[rd] = hart->csrs[csr];
	hart->csrs[csr] = imm32;
}


// read+clear immediate(5-bit)
static void csr_rsi(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm) {
	const uint32_t imm32 = (uint32_t)imm;
	//printf("CSR_RSI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
	hart->regs[rd] = hart->csrs[csr];
	hart->csrs[csr] = hart->csrs[csr] | imm32;
}


// read+clear immediate(5-bit)
static void csr_rci(hart_Hart *hart, uint16_t csr, uint8_t rd, uint8_t imm) {
	const uint32_t imm32 = (uint32_t)imm;
	//printf("CSR_RCI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
	hart->regs[rd] = hart->csrs[csr];
	hart->csrs[csr] = hart->csrs[csr] & ~imm32;
}


static void trace(uint32_t pc, char *form, ...) {
	if (!TRACE_MODE) {
		return;
	}

	va_list va;
	va_start(va, form);
	printf("[%08X] ", pc);
	vprintf(form, va);
	va_end(va);

	char c;
	scanf("%c", &c);
}


static void trace2(uint32_t pc, char *form, ...) {
	va_list va;
	va_start(va, form);
	printf("[%08X] ", pc);
	vprintf(form, va);
	va_end(va);
}


static void fatal(char *form, ...) {
	va_list va;
	va_start(va, form);
	vprintf(form, va);
	va_end(va);
	exit(-1);
}


static void notImplemented(char *form, ...) {
	va_list va;
	va_start(va, form);
	printf("\n\nINSTRUCTION_NOT_IMPLEMENTED: \"");
	vprintf(form, va);
	va_end(va);
	puts("\"\n");
	exit(-1);
}


void hart_show_regs(hart_Hart *hart) {
	uint16_t i = 0;
	while (i < 16) {
		printf("x%02d = 0x%08x", i, hart->regs[i]);
		printf("    ");
		printf("x%02d = 0x%08x\n", i + 16, hart->regs[i + 16]);
		i = i + 1;
	}
}


