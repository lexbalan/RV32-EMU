
#ifndef DECODE_H
#define DECODE_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

uint8_t decode_extract_op(uint32_t instr);
uint8_t decode_extract_funct2(uint32_t instr);
uint8_t decode_extract_funct3(uint32_t instr);
uint8_t decode_extract_funct5(uint32_t instr);
uint8_t decode_extract_rd(uint32_t instr);
uint8_t decode_extract_rs1(uint32_t instr);
uint8_t decode_extract_rs2(uint32_t instr);
uint8_t decode_extract_funct7(uint32_t instr);
uint32_t decode_extract_imm12(uint32_t instr);
uint32_t decode_extract_imm31_12(uint32_t instr);
int16_t decode_extract_b_imm(uint32_t instr);
uint32_t decode_extract_jal_imm(uint32_t instr);
int32_t decode_expand12(uint32_t val_12bit);
int32_t decode_expand20(uint32_t val_20bit);

#endif /* DECODE_H */
