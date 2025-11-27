
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Word8 = type i8
%Word16 = type i16
%Word32 = type i32
%Word64 = type i64
%Word128 = type i128
%Word256 = type i256
%Char8 = type i8
%Char16 = type i16
%Char32 = type i32
%Int8 = type i8
%Int16 = type i16
%Int32 = type i32
%Int64 = type i64
%Int128 = type i128
%Int256 = type i256
%Nat8 = type i8
%Nat16 = type i16
%Nat32 = type i32
%Nat64 = type i64
%Nat128 = type i128
%Nat256 = type i256
%Float32 = type float
%Float64 = type double
%Size = type i64
%Pointer = type i8*
%Str8 = type [0 x %Char8]
%Str16 = type [0 x %Char16]
%Str32 = type [0 x %Char32]
%__VA_List = type i8*
declare void @llvm.memcpy.p0.p0.i32(i8*, i8*, i32, i1)
declare void @llvm.memset.p0.i32(i8*, i8, i32, i1)

declare i8* @llvm.stacksave()

declare void @llvm.stackrestore(i8*)



%CPU.Word = type i64
define weak i1 @memeq(i8* %mem0, i8* %mem1, i64 %len) {
	%1 = udiv i64 %len, 8
	%2 = bitcast i8* %mem0 to [0 x %CPU.Word]*
	%3 = bitcast i8* %mem1 to [0 x %CPU.Word]*
	%4 = alloca i64
	store i64 0, i64* %4
	br label %again_1
again_1:
	%5 = load i64, i64* %4
	%6 = icmp ult i64 %5, %1
	br i1 %6 , label %body_1, label %break_1
body_1:
	%7 = load i64, i64* %4
	%8 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %7
	%9 = load %CPU.Word, %CPU.Word* %8
	%10 = load i64, i64* %4
	%11 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %10
	%12 = load %CPU.Word, %CPU.Word* %11
	%13 = icmp ne %CPU.Word %9, %12
	br i1 %13 , label %then_0, label %endif_0
then_0:
	ret i1 0
	br label %endif_0
endif_0:
	%15 = load i64, i64* %4
	%16 = add i64 %15, 1
	store i64 %16, i64* %4
	br label %again_1
break_1:
	%17 = urem i64 %len, 8
	%18 = load i64, i64* %4
	%19 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %2, i32 0, i64 %18
	%20 = bitcast %CPU.Word* %19 to [0 x i8]*
	%21 = load i64, i64* %4
	%22 = getelementptr inbounds [0 x %CPU.Word], [0 x %CPU.Word]* %3, i32 0, i64 %21
	%23 = bitcast %CPU.Word* %22 to [0 x i8]*
	store i64 0, i64* %4
	br label %again_2
again_2:
	%24 = load i64, i64* %4
	%25 = icmp ult i64 %24, %17
	br i1 %25 , label %body_2, label %break_2
body_2:
	%26 = load i64, i64* %4
	%27 = getelementptr inbounds [0 x i8], [0 x i8]* %20, i32 0, i64 %26
	%28 = load i8, i8* %27
	%29 = load i64, i64* %4
	%30 = getelementptr inbounds [0 x i8], [0 x i8]* %23, i32 0, i64 %29
	%31 = load i8, i8* %30
	%32 = icmp ne i8 %28, %31
	br i1 %32 , label %then_1, label %endif_1
then_1:
	ret i1 0
	br label %endif_1
endif_1:
	%34 = load i64, i64* %4
	%35 = add i64 %34, 1
	store i64 %35, i64* %4
	br label %again_2
break_2:
	ret i1 1
}

; MODULE: decode

; -- print includes --
; -- end print includes --
; -- print imports 'decode' --
; -- 0
; -- end print imports 'decode' --
; -- strings --
; -- endstrings --
define %Word8 @decode_extract_op(%Word32 %instr) {
	%1 = and %Word32 %instr, 127
	%2 = trunc %Word32 %1 to %Word8
	ret %Word8 %2
}

define %Word8 @decode_extract_funct2(%Word32 %instr) {
	%1 = zext i8 25 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 3
	%4 = trunc %Word32 %3 to %Word8
	ret %Word8 %4
}

define %Word8 @decode_extract_funct3(%Word32 %instr) {
	%1 = zext i8 12 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 7
	%4 = trunc %Word32 %3 to %Word8
	ret %Word8 %4
}

define %Word8 @decode_extract_funct5(%Word32 %instr) {
	%1 = zext i8 27 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 31
	%4 = trunc %Word32 %3 to %Word8
	ret %Word8 %4
}

define %Nat8 @decode_extract_rd(%Word32 %instr) {
	%1 = zext i8 7 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 31
	%4 = trunc %Word32 %3 to %Nat8
	ret %Nat8 %4
}

define %Nat8 @decode_extract_rs1(%Word32 %instr) {
	%1 = zext i8 15 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 31
	%4 = trunc %Word32 %3 to %Nat8
	ret %Nat8 %4
}

define %Nat8 @decode_extract_rs2(%Word32 %instr) {
	%1 = zext i8 20 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 31
	%4 = trunc %Word32 %3 to %Nat8
	ret %Nat8 %4
}

define %Word8 @decode_extract_funct7(%Word32 %instr) {
	%1 = zext i8 25 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 127
	%4 = trunc %Word32 %3 to %Word8
	ret %Word8 %4
}

define %Word32 @decode_extract_imm12(%Word32 %instr) {
	%1 = zext i8 20 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 4095
	ret %Word32 %3
}

define %Word32 @decode_extract_imm31_12(%Word32 %instr) {
	%1 = zext i8 12 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = and %Word32 %2, 1048575
	ret %Word32 %3
}

define %Int16 @decode_extract_b_imm(%Word32 %instr) {
	%1 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%2 = zext %Nat8 %1 to %Word16
	%3 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%4 = and %Word16 %2, 30
	%5 = and %Word8 %3, 63
	%6 = zext %Word8 %5 to %Word16
	%7 = zext i8 5 to %Word16
	%8 = shl %Word16 %6, %7
	%9 = and %Word16 %2, 1
	%10 = zext i8 11 to %Word16
	%11 = shl %Word16 %9, %10
	%12 = and %Word8 %3, 64
	%13 = zext %Word8 %12 to %Word16
	%14 = zext i8 6 to %Word16
	%15 = shl %Word16 %13, %14
	%16 = alloca %Word16, align 2
	%17 = or %Word16 %8, %4
	%18 = or %Word16 %11, %17
	%19 = or %Word16 %15, %18
	store %Word16 %19, %Word16* %16

	; распространяем знак (если он есть)
; if_0
	%20 = load %Word16, %Word16* %16
	%21 = and %Word16 %20, 4096
	%22 = zext i8 0 to %Word16
	%23 = icmp ne %Word16 %21, %22
	br %Bool %23 , label %then_0, label %endif_0
then_0:
	%24 = load %Word16, %Word16* %16
	%25 = or %Word16 61440, %24
	store %Word16 %25, %Word16* %16
	br label %endif_0
endif_0:
	%26 = load %Word16, %Word16* %16
	%27 = bitcast %Word16 %26 to %Int16
	ret %Int16 %27
}

define %Word32 @decode_extract_jal_imm(%Word32 %instr) {
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = zext i8 0 to %Word32
	%3 = lshr %Word32 %1, %2
	%4 = and %Word32 %3, 255
	%5 = zext i8 12 to %Word32
	%6 = shl %Word32 %4, %5
	%7 = zext i8 8 to %Word32
	%8 = lshr %Word32 %1, %7
	%9 = and %Word32 %8, 1
	%10 = zext i8 11 to %Word32
	%11 = shl %Word32 %9, %10
	%12 = zext i8 9 to %Word32
	%13 = lshr %Word32 %1, %12
	%14 = and %Word32 %13, 1023
	%15 = zext i8 1 to %Word32
	%16 = shl %Word32 %14, %15
	%17 = zext i8 20 to %Word32
	%18 = lshr %Word32 %1, %17
	%19 = and %Word32 %18, 1
	%20 = zext i8 20 to %Word32
	%21 = shl %Word32 %19, %20
	%22 = or %Word32 %11, %16
	%23 = or %Word32 %6, %22
	%24 = or %Word32 %21, %23
	ret %Word32 %24
}

define %Int32 @decode_expand12(%Word32 %val_12bit) {
	%1 = alloca %Word32, align 4
	store %Word32 %val_12bit, %Word32* %1
; if_0
	%2 = load %Word32, %Word32* %1
	%3 = and %Word32 %2, 2048
	%4 = zext i8 0 to %Word32
	%5 = icmp ne %Word32 %3, %4
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = load %Word32, %Word32* %1
	%7 = or %Word32 %6, 4294963200
	store %Word32 %7, %Word32* %1
	br label %endif_0
endif_0:
	%8 = load %Word32, %Word32* %1
	%9 = bitcast %Word32 %8 to %Int32
	ret %Int32 %9
}

define %Int32 @decode_expand20(%Word32 %val_20bit) {
	%1 = alloca %Word32, align 4
	store %Word32 %val_20bit, %Word32* %1
; if_0
	%2 = load %Word32, %Word32* %1
	%3 = and %Word32 %2, 524288
	%4 = zext i8 0 to %Word32
	%5 = icmp ne %Word32 %3, %4
	br %Bool %5 , label %then_0, label %endif_0
then_0:
	%6 = load %Word32, %Word32* %1
	%7 = or %Word32 %6, 4293918720
	store %Word32 %7, %Word32* %1
	br label %endif_0
endif_0:
	%8 = load %Word32, %Word32* %1
	%9 = bitcast %Word32 %8 to %Int32
	ret %Int32 %9
}


