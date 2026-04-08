private import "builtin"


public func extract_op (instr: Word32) -> Word8 {
	return unsafe Word8 (instr & 0x7F)
}


public func extract_funct2 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 25) & 0x03)
}


public func extract_funct3 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 12) & 0x07)
}


public func extract_funct5 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 27) & 0x01F)
}


public func extract_rd (instr: Word32) -> Nat8 {
	return unsafe Nat8 ((instr >> 7) & 0x1F)
}


public func extract_rs1 (instr: Word32) -> Nat8 {
	return unsafe Nat8 ((instr >> 15) & 0x1F)
}


public func extract_rs2 (instr: Word32) -> Nat8 {
	return unsafe Nat8 ((instr >> 20) & 0x1F)
}


public func extract_funct7 (instr: Word32) -> Word8 {
	return unsafe Word8 ((instr >> 25) & 0x7F)
}


// bits: (31 .. 20)
public func extract_imm12 (instr: Word32) -> Word32 {
	return (instr >> 20) & 0xFFF
}


public func extract_imm31_12 (instr: Word32) -> Word32 {
	return (instr >> 12) & 0xFFFFF
}


public func extract_b_imm (instr: Word32) -> Int16 {
	let imm4to1_11 = Word16 extract_rd(instr)
	let imm12_10to5: Word8 = extract_funct7(instr)
	let bit4to1: Word16 = imm4to1_11 & 0x1E
	let bit10to5: Word16 = Word16 (imm12_10to5 & 0x3F) << 5
	let bit11: Word16 = (imm4to1_11 & 0x1) << 11
	let bit12: Word16 = Word16 (imm12_10to5 & 0x40) << 6

	var imm_bits: Word16 = bit12 | bit11 | bit10to5 | bit4to1
	if (imm_bits & (Word16 1 << 12)) != 0 {
		imm_bits = 0xF000 | imm_bits
	}

	return Int16 imm_bits
}


public func extract_jal_imm (instr: Word32) -> Word32 {
	let imm: Word32 = extract_imm31_12(instr)
	let bit19to12_msk: Word32 = ((imm >> 0) & 0xFF) << 12
	let bit11_msk: Word32 = ((imm >> 8) & 0x1) << 11
	let bit10to1: Word32 = ((imm >> 9) & 0x3FF) << 1
	let bit20_msk: Word32 = ((imm >> 20) & 0x1) << 20
	return bit20_msk | bit19to12_msk | bit11_msk | bit10to1
}


// sign expand (12bit -> 32bit)
public func expand12 (val_12bit: Word32) -> Int32 {
	var v: Word32 = val_12bit
	if v & 0x800 != 0 {
		v = v | 0xFFFFF000
	}
	return Int32 v
}


// sign expand (20bit -> 32bit)
public func expand20 (val_20bit: Word32) -> Int32 {
	var v: Word32 = val_20bit
	if v & 0x80000 != 0 {
		v = v | 0xFFF00000
	}
	return Int32 v
}

