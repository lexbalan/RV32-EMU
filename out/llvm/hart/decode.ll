
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-macosx12.0.0"


%Unit = type i1
%Bool = type i1
%Byte = type i8
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
%Fixed32 = type i32
%Fixed64 = type i64
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
; -- print imports private 'decode' --

; from import "builtin"

; end from import "builtin"
; -- end print imports private 'decode' --
; -- print imports public 'decode' --
; -- end print imports public 'decode' --
; -- strings --
; -- endstrings --
define %Word8 @decode_extract_op(%Word32 %instr) {
	%1 = zext i8 127 to %Word32
	%2 = and %Word32 %instr, %1
	%3 = trunc %Word32 %2 to %Word8
	ret %Word8 %3
}

define %Word8 @decode_extract_funct2(%Word32 %instr) {
	%1 = zext i8 25 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 3 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Word8
	ret %Word8 %5
}

define %Word8 @decode_extract_funct3(%Word32 %instr) {
	%1 = zext i8 12 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 7 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Word8
	ret %Word8 %5
}

define %Word8 @decode_extract_funct5(%Word32 %instr) {
	%1 = zext i8 27 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 31 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Word8
	ret %Word8 %5
}

define %Nat8 @decode_extract_rd(%Word32 %instr) {
	%1 = zext i8 7 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 31 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Nat8
	ret %Nat8 %5
}

define %Nat8 @decode_extract_rs1(%Word32 %instr) {
	%1 = zext i8 15 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 31 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Nat8
	ret %Nat8 %5
}

define %Nat8 @decode_extract_rs2(%Word32 %instr) {
	%1 = zext i8 20 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 31 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Nat8
	ret %Nat8 %5
}

define %Word8 @decode_extract_funct7(%Word32 %instr) {
	%1 = zext i8 25 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i8 127 to %Word32
	%4 = and %Word32 %2, %3
	%5 = trunc %Word32 %4 to %Word8
	ret %Word8 %5
}

define %Word32 @decode_extract_imm12(%Word32 %instr) {
	%1 = zext i8 20 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = zext i16 4095 to %Word32
	%4 = and %Word32 %2, %3
	ret %Word32 %4
}

define %Word32 @decode_extract_imm31_12(%Word32 %instr) {
	%1 = zext i8 12 to %Word32
	%2 = lshr %Word32 %instr, %1
	%3 = bitcast i32 1048575 to %Word32
	%4 = and %Word32 %2, %3
	ret %Word32 %4
}

define %Int16 @decode_extract_b_imm(%Word32 %instr) {
	%1 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%2 = zext %Nat8 %1 to %Word16
	%3 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%4 = zext i8 30 to %Word16
	%5 = and %Word16 %2, %4
	%6 = bitcast i8 63 to %Word8
	%7 = and %Word8 %3, %6
	%8 = zext %Word8 %7 to %Word16
	%9 = zext i8 5 to %Word16
	%10 = shl %Word16 %8, %9
	%11 = zext i8 1 to %Word16
	%12 = and %Word16 %2, %11
	%13 = zext i8 11 to %Word16
	%14 = shl %Word16 %12, %13
	%15 = bitcast i8 64 to %Word8
	%16 = and %Word8 %3, %15
	%17 = zext %Word8 %16 to %Word16
	%18 = zext i8 6 to %Word16
	%19 = shl %Word16 %17, %18
	%20 = alloca %Word16, align 2
	%21 = or %Word16 %10, %5
	%22 = or %Word16 %14, %21
	%23 = or %Word16 %19, %22
	store %Word16 %23, %Word16* %20
; if_0
	%24 = load %Word16, %Word16* %20
	%25 = and %Word16 %24, 4096
	%26 = zext i8 0 to %Word16
	%27 = icmp ne %Word16 %25, %26
	br %Bool %27 , label %then_0, label %endif_0
then_0:
	%28 = bitcast i16 61440 to %Word16
	%29 = load %Word16, %Word16* %20
	%30 = or %Word16 %28, %29
	store %Word16 %30, %Word16* %20
	br label %endif_0
endif_0:
	%31 = load %Word16, %Word16* %20
	%32 = bitcast %Word16 %31 to %Int16
	ret %Int16 %32
}

define %Word32 @decode_extract_jal_imm(%Word32 %instr) {
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = zext i8 0 to %Word32
	%3 = lshr %Word32 %1, %2
	%4 = zext i8 255 to %Word32
	%5 = and %Word32 %3, %4
	%6 = zext i8 12 to %Word32
	%7 = shl %Word32 %5, %6
	%8 = zext i8 8 to %Word32
	%9 = lshr %Word32 %1, %8
	%10 = zext i8 1 to %Word32
	%11 = and %Word32 %9, %10
	%12 = zext i8 11 to %Word32
	%13 = shl %Word32 %11, %12
	%14 = zext i8 9 to %Word32
	%15 = lshr %Word32 %1, %14
	%16 = zext i16 1023 to %Word32
	%17 = and %Word32 %15, %16
	%18 = zext i8 1 to %Word32
	%19 = shl %Word32 %17, %18
	%20 = zext i8 20 to %Word32
	%21 = lshr %Word32 %1, %20
	%22 = zext i8 1 to %Word32
	%23 = and %Word32 %21, %22
	%24 = zext i8 20 to %Word32
	%25 = shl %Word32 %23, %24
	%26 = or %Word32 %13, %19
	%27 = or %Word32 %7, %26
	%28 = or %Word32 %25, %27
	ret %Word32 %28
}

define %Int32 @decode_expand12(%Word32 %val_12bit) {
	%1 = alloca %Word32, align 4
	store %Word32 %val_12bit, %Word32* %1
; if_0
	%2 = zext i16 2048 to %Word32
	%3 = load %Word32, %Word32* %1
	%4 = and %Word32 %3, %2
	%5 = zext i8 0 to %Word32
	%6 = icmp ne %Word32 %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = bitcast i32 4294963200 to %Word32
	%8 = load %Word32, %Word32* %1
	%9 = or %Word32 %8, %7
	store %Word32 %9, %Word32* %1
	br label %endif_0
endif_0:
	%10 = load %Word32, %Word32* %1
	%11 = bitcast %Word32 %10 to %Int32
	ret %Int32 %11
}

define %Int32 @decode_expand20(%Word32 %val_20bit) {
	%1 = alloca %Word32, align 4
	store %Word32 %val_20bit, %Word32* %1
; if_0
	%2 = bitcast i32 524288 to %Word32
	%3 = load %Word32, %Word32* %1
	%4 = and %Word32 %3, %2
	%5 = zext i8 0 to %Word32
	%6 = icmp ne %Word32 %4, %5
	br %Bool %6 , label %then_0, label %endif_0
then_0:
	%7 = bitcast i32 4293918720 to %Word32
	%8 = load %Word32, %Word32* %1
	%9 = or %Word32 %8, %7
	store %Word32 %9, %Word32* %1
	br label %endif_0
endif_0:
	%10 = load %Word32, %Word32* %1
	%11 = bitcast %Word32 %10 to %Int32
	ret %Int32 %11
}


