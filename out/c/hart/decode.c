
#include "decode.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

uint8_t decode_extract_op(uint32_t instr) {
	return (uint8_t)(instr & 0x7FU);
}

uint8_t decode_extract_funct2(uint32_t instr) {
	return (uint8_t)(instr >> 25 & 0x3U);
}

uint8_t decode_extract_funct3(uint32_t instr) {
	return (uint8_t)(instr >> 12 & 0x7U);
}

uint8_t decode_extract_funct5(uint32_t instr) {
	return (uint8_t)(instr >> 27 & 0x1FU);
}

uint8_t decode_extract_rd(uint32_t instr) {
	return (uint8_t)(instr >> 7 & 0x1FU);
}

uint8_t decode_extract_rs1(uint32_t instr) {
	return (uint8_t)(instr >> 15 & 0x1FU);
}

uint8_t decode_extract_rs2(uint32_t instr) {
	return (uint8_t)(instr >> 20 & 0x1FU);
}

uint8_t decode_extract_funct7(uint32_t instr) {
	return (uint8_t)(instr >> 25 & 0x7FU);
}

uint32_t decode_extract_imm12(uint32_t instr) {
	return instr >> 20 & 0xFFFU;
}

uint32_t decode_extract_imm31_12(uint32_t instr) {
	return instr >> 12 & 0xFFFFFU;
}

int16_t decode_extract_b_imm(uint32_t instr) {
	const uint16_t imm4to1_11 = (uint16_t)decode_extract_rd(instr);
	const uint8_t imm12_10to5 = decode_extract_funct7(instr);
	const uint16_t bit4to1 = imm4to1_11 & 0x1E;
	const uint16_t bit10to5 = (uint16_t)(imm12_10to5 & 0x3F) << 5;
	const uint16_t bit11 = (imm4to1_11 & 0x1) << 11;
	const uint16_t bit12 = (uint16_t)(imm12_10to5 & 0x40) << 6;
	uint16_t imm_bits = bit12 | bit11 | bit10to5 | bit4to1;
	if ((imm_bits & 0x1 << 12) != 0x0) {
		imm_bits = 0xF000 | imm_bits;
	}
	return imm_bits;
}

uint32_t decode_extract_jal_imm(uint32_t instr) {
	const uint32_t imm = decode_extract_imm31_12(instr);
	const uint32_t bit19to12_msk = (imm >> 0 & 0xFFU) << 12;
	const uint32_t bit11_msk = (imm >> 8 & 0x1U) << 11;
	const uint32_t bit10to1 = (imm >> 9 & 0x3FFU) << 1;
	const uint32_t bit20_msk = (imm >> 20 & 0x1U) << 20;
	return bit20_msk | bit19to12_msk | bit11_msk | bit10to1;
}

int32_t decode_expand12(uint32_t val_12bit) {
	uint32_t v = val_12bit;
	if ((v & 0x800U) != 0x0U) {
		v = v | 0xFFFFF000U;
	}
	return v;
}

int32_t decode_expand20(uint32_t val_20bit) {
	uint32_t v = val_20bit;
	if ((v & 0x80000U) != 0x0U) {
		v = v | 0xFFF00000U;
	}
	return v;
}

