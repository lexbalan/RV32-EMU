
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

; MODULE: bus

; -- print includes --
; from included ctypes64
%Str = type %Str8;
%Char = type %Char8;
%ConstChar = type %Char;
%SignedChar = type %Int8;
%UnsignedChar = type %Nat8;
%Short = type %Int16;
%UnsignedShort = type %Nat16;
%Int = type %Int32;
%UnsignedInt = type %Nat32;
%LongInt = type %Int64;
%UnsignedLongInt = type %Nat64;
%Long = type %Int64;
%UnsignedLong = type %Nat64;
%LongLong = type %Int64;
%UnsignedLongLong = type %Nat64;
%LongLongInt = type %Int64;
%UnsignedLongLongInt = type %Nat64;
%Float = type %Float64;
%Double = type %Float64;
%LongDouble = type %Float64;
%SizeT = type %UnsignedLongInt;
%SSizeT = type %LongInt;
%IntPtrT = type %Nat64;
%PtrDiffT = type i8*;
%OffT = type %Int64;
%USecondsT = type %Nat32;
%PIDT = type %Int32;
%UIDT = type %Nat32;
%GIDT = type %Nat32;
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(%File* %f)
declare %Int @feof(%File* %f)
declare %Int @ferror(%File* %f)
declare %Int @fflush(%File* %f)
declare %Int @fgetpos(%File* %f, %FposT* %pos)
declare %File* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, %File* %f)
declare %File* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, %File* %f)
declare %Int @fseek(%File* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(%File* %f, %FposT* %pos)
declare %LongInt @ftell(%File* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(%File* %f)
declare void @setbuf(%File* %f, %CharStr* %buf)
declare %Int @setvbuf(%File* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare %File* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(%File* %f, %Str* %format, ...)
declare %Int @fscanf(%File* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @vfprintf(%File* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(%File* %f)
declare %Int @fputc(%Int %char, %File* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, %File* %f)
declare %Int @fputs(%ConstCharStr* %str, %File* %f)
declare %Int @getc(%File* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, %File* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, %File* %f)
declare void @perror(%ConstCharStr* %str)
; from included stdlib
declare void @abort()
declare %Int @abs(%Int %x)
declare %Int @atexit(void ()* %x)
declare %Double @atof([0 x %ConstChar]* %nptr)
declare %Int @atoi([0 x %ConstChar]* %nptr)
declare %LongInt @atol([0 x %ConstChar]* %nptr)
declare i8* @calloc(%SizeT %num, %SizeT %size)
declare void @exit(%Int %x)
declare void @free(i8* %ptr)
declare %Str* @getenv(%Str* %name)
declare %LongInt @labs(%LongInt %x)
declare %Str* @secure_getenv(%Str* %name)
declare i8* @malloc(%SizeT %size)
declare %Int @system([0 x %ConstChar]* %string)
; -- end print includes --
; -- print imports 'bus' --
; -- 1
; from included ctypes

; from import "mmio"
declare void @mmio_write8(%Nat32 %adr, %Word8 %value)
declare void @mmio_write16(%Nat32 %adr, %Word16 %value)
declare void @mmio_write32(%Nat32 %adr, %Word32 %value)
declare %Word8 @mmio_read8(%Nat32 %adr)
declare %Word16 @mmio_read16(%Nat32 %adr)
declare %Word32 @mmio_read32(%Nat32 %adr)

; end from import "mmio"
; -- end print imports 'bus' --
; -- strings --
@str1 = private constant [38 x i8] [i8 42, i8 42, i8 42, i8 32, i8 77, i8 69, i8 77, i8 79, i8 82, i8 89, i8 32, i8 86, i8 73, i8 79, i8 76, i8 65, i8 84, i8 73, i8 79, i8 78, i8 32, i8 39, i8 37, i8 99, i8 39, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 32, i8 42, i8 42, i8 42, i8 10, i8 0]
@str2 = private constant [10 x i8] [i8 76, i8 79, i8 65, i8 68, i8 58, i8 32, i8 37, i8 115, i8 10, i8 0]
@str3 = private constant [3 x i8] [i8 114, i8 98, i8 0]
@str4 = private constant [29 x i8] [i8 101, i8 114, i8 114, i8 111, i8 114, i8 58, i8 32, i8 99, i8 97, i8 110, i8 110, i8 111, i8 116, i8 32, i8 111, i8 112, i8 101, i8 110, i8 32, i8 102, i8 105, i8 108, i8 101, i8 32, i8 39, i8 37, i8 115, i8 39, i8 0]
@str5 = private constant [19 x i8] [i8 76, i8 79, i8 65, i8 68, i8 69, i8 68, i8 58, i8 32, i8 37, i8 122, i8 117, i8 32, i8 98, i8 121, i8 116, i8 101, i8 115, i8 10, i8 0]
@str6 = private constant [15 x i8] [i8 37, i8 48, i8 56, i8 122, i8 120, i8 58, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
@str7 = private constant [13 x i8] [i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 45, i8 10, i8 0]
@str8 = private constant [5 x i8] [i8 37, i8 48, i8 56, i8 88, i8 0]
@str9 = private constant [6 x i8] [i8 32, i8 37, i8 48, i8 50, i8 88, i8 0]
@str10 = private constant [2 x i8] [i8 10, i8 0]
; -- endstrings --;
;


; see mem.ld
@rom = internal global [1048576 x %Word8] zeroinitializer
@ram = internal global [16384 x %Word8] zeroinitializer
define %Word32 @bus_read(%Nat32 %adr, %Nat8 %size) {
; if_0
	%1 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %1 , label %then_0, label %else_0
then_0:
; if_1
	%2 = icmp eq %Nat8 %size, 1
	br %Bool %2 , label %then_1, label %else_1
then_1:
	%3 = sub %Nat32 %adr, 268435456
	%4 = bitcast %Nat32 %3 to %Nat32
	%5 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %4
	%6 = bitcast %Word8* %5 to i8*
	%7 = bitcast i8* %6 to %Word8*
	%8 = load %Word8, %Word8* %7
	%9 = zext %Word8 %8 to %Word32
	ret %Word32 %9
	br label %endif_1
else_1:
; if_2
	%11 = icmp eq %Nat8 %size, 2
	br %Bool %11 , label %then_2, label %else_2
then_2:
	%12 = sub %Nat32 %adr, 268435456
	%13 = bitcast %Nat32 %12 to %Nat32
	%14 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %13
	%15 = bitcast %Word8* %14 to i8*
	%16 = bitcast i8* %15 to %Word16*
	%17 = load %Word16, %Word16* %16
	%18 = zext %Word16 %17 to %Word32
	ret %Word32 %18
	br label %endif_2
else_2:
; if_3
	%20 = icmp eq %Nat8 %size, 4
	br %Bool %20 , label %then_3, label %endif_3
then_3:
	%21 = sub %Nat32 %adr, 268435456
	%22 = bitcast %Nat32 %21 to %Nat32
	%23 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %22
	%24 = bitcast %Word8* %23 to i8*
	%25 = bitcast i8* %24 to %Word32*
	%26 = load %Word32, %Word32* %25
	ret %Word32 %26
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
; if_4
	%28 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 0, %Nat32 1048576)
	br %Bool %28 , label %then_4, label %else_4
then_4:
; if_5
	%29 = icmp eq %Nat8 %size, 1
	br %Bool %29 , label %then_5, label %else_5
then_5:
	%30 = sub %Nat32 %adr, 0
	%31 = bitcast %Nat32 %30 to %Nat32
	%32 = getelementptr [1048576 x %Word8], [1048576 x %Word8]* @rom, %Int32 0, %Nat32 %31
	%33 = bitcast %Word8* %32 to i8*
	%34 = bitcast i8* %33 to %Word8*
	%35 = load %Word8, %Word8* %34
	%36 = zext %Word8 %35 to %Word32
	ret %Word32 %36
	br label %endif_5
else_5:
; if_6
	%38 = icmp eq %Nat8 %size, 2
	br %Bool %38 , label %then_6, label %else_6
then_6:
	%39 = sub %Nat32 %adr, 0
	%40 = bitcast %Nat32 %39 to %Nat32
	%41 = getelementptr [1048576 x %Word8], [1048576 x %Word8]* @rom, %Int32 0, %Nat32 %40
	%42 = bitcast %Word8* %41 to i8*
	%43 = bitcast i8* %42 to %Word16*
	%44 = load %Word16, %Word16* %43
	%45 = zext %Word16 %44 to %Word32
	ret %Word32 %45
	br label %endif_6
else_6:
; if_7
	%47 = icmp eq %Nat8 %size, 4
	br %Bool %47 , label %then_7, label %endif_7
then_7:
	%48 = sub %Nat32 %adr, 0
	%49 = bitcast %Nat32 %48 to %Nat32
	%50 = getelementptr [1048576 x %Word8], [1048576 x %Word8]* @rom, %Int32 0, %Nat32 %49
	%51 = bitcast %Word8* %50 to i8*
	%52 = bitcast i8* %51 to %Word32*
	%53 = load %Word32, %Word32* %52
	ret %Word32 %53
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
; if_8
	%55 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %55 , label %then_8, label %else_8
then_8:
	; MMIO Read
	br label %endif_8
else_8:
	call void @memoryViolation(%Char8 114, %Nat32 %adr)
	br label %endif_8
endif_8:
	br label %endif_4
endif_4:
	br label %endif_0
endif_0:
	%56 = zext i8 0 to %Word32
	ret %Word32 %56
}

define void @bus_write(%Nat32 %adr, %Word32 %value, %Nat8 %size) {
; if_0
	%1 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 268435456, %Nat32 268451840)
	br %Bool %1 , label %then_0, label %else_0
then_0:
; if_1
	%2 = icmp eq %Nat8 %size, 1
	br %Bool %2 , label %then_1, label %else_1
then_1:
	%3 = sub %Nat32 %adr, 268435456
	%4 = bitcast %Nat32 %3 to %Nat32
	%5 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %4
	%6 = bitcast %Word8* %5 to i8*
	%7 = bitcast i8* %6 to %Word8*
	%8 = trunc %Word32 %value to %Word8
	store %Word8 %8, %Word8* %7
	br label %endif_1
else_1:
; if_2
	%9 = icmp eq %Nat8 %size, 2
	br %Bool %9 , label %then_2, label %else_2
then_2:
	%10 = sub %Nat32 %adr, 268435456
	%11 = bitcast %Nat32 %10 to %Nat32
	%12 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %11
	%13 = bitcast %Word8* %12 to i8*
	%14 = bitcast i8* %13 to %Word16*
	%15 = trunc %Word32 %value to %Word16
	store %Word16 %15, %Word16* %14
	br label %endif_2
else_2:
; if_3
	%16 = icmp eq %Nat8 %size, 4
	br %Bool %16 , label %then_3, label %endif_3
then_3:
	%17 = sub %Nat32 %adr, 268435456
	%18 = bitcast %Nat32 %17 to %Nat32
	%19 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %18
	%20 = bitcast %Word8* %19 to i8*
	%21 = bitcast i8* %20 to %Word32*
	store %Word32 %value, %Word32* %21
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
; if_4
	%22 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 4027318272, %Nat32 4027383807)
	br %Bool %22 , label %then_4, label %else_4
then_4:
; if_5
	%23 = icmp eq %Nat8 %size, 1
	br %Bool %23 , label %then_5, label %else_5
then_5:
	%24 = sub %Nat32 %adr, 4027318272
	%25 = trunc %Word32 %value to %Word8
	call void @mmio_write8(%Nat32 %24, %Word8 %25)
	br label %endif_5
else_5:
; if_6
	%26 = icmp eq %Nat8 %size, 2
	br %Bool %26 , label %then_6, label %else_6
then_6:
	%27 = sub %Nat32 %adr, 4027318272
	%28 = trunc %Word32 %value to %Word16
	call void @mmio_write16(%Nat32 %27, %Word16 %28)
	br label %endif_6
else_6:
; if_7
	%29 = icmp eq %Nat8 %size, 4
	br %Bool %29 , label %then_7, label %endif_7
then_7:
	%30 = sub %Nat32 %adr, 4027318272
	call void @mmio_write32(%Nat32 %30, %Word32 %value)
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
; if_8
	%31 = call %Bool @isAdressInRange(%Nat32 %adr, %Nat32 0, %Nat32 1048576)
	br %Bool %31 , label %then_8, label %else_8
then_8:
	call void @memoryViolation(%Char8 119, %Nat32 %adr)
	br label %endif_8
else_8:
	call void @memoryViolation(%Char8 119, %Nat32 %adr)
	br label %endif_8
endif_8:
	br label %endif_4
endif_4:
	br label %endif_0
endif_0:
	ret void
}

define internal %Bool @isAdressInRange(%Nat32 %x, %Nat32 %a, %Nat32 %b) alwaysinline {
	%1 = icmp uge %Nat32 %x, %a
	%2 = icmp ult %Nat32 %x, %b
	%3 = and %Bool %1, %2
	ret %Bool %3
}

@memviolationCnt = internal global %Nat32 0
define internal void @memoryViolation(%Char8 %rw, %Nat32 %adr) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([38 x i8]* @str1 to [0 x i8]*), %Char8 %rw, %Nat32 %adr)
; if_0
	%2 = load %Nat32, %Nat32* @memviolationCnt
	%3 = icmp ugt %Nat32 %2, 10
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	call void @exit(%Int 1)
	br label %endif_0
endif_0:
	%4 = load %Nat32, %Nat32* @memviolationCnt
	%5 = add %Nat32 %4, 1
	store %Nat32 %5, %Nat32* @memviolationCnt
	;	memoryViolation_event(0x55) // !
	ret void
}

define %Nat32 @bus_load_rom(%Str8* %filename) {
	%1 = call %Nat32 @load(%Str8* %filename, [0 x %Word8]* bitcast ([1048576 x %Word8]* @rom to [0 x %Word8]*), %Nat32 1048576)
	ret %Nat32 %1
}

define internal %Nat32 @load(%Str8* %filename, [0 x %Word8]* %bufptr, %Nat32 %buf_size) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([10 x i8]* @str2 to [0 x i8]*), %Str8* %filename)
	%2 = call %File* @fopen(%Str8* %filename, %ConstCharStr* bitcast ([3 x i8]* @str3 to [0 x i8]*))
; if_0
	%3 = icmp eq %File* %2, null
	br %Bool %3 , label %then_0, label %endif_0
then_0:
	%4 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([29 x i8]* @str4 to [0 x i8]*), %Str8* %filename)
	ret %Nat32 0
	br label %endif_0
endif_0:
	%6 = bitcast [0 x %Word8]* %bufptr to i8*
	%7 = zext %Nat32 %buf_size to %SizeT
	%8 = call %SizeT @fread(i8* %6, %SizeT 1, %SizeT %7, %File* %2)
	%9 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([19 x i8]* @str5 to [0 x i8]*), %SizeT %8)
; if_1
	br %Bool 0 , label %then_1, label %endif_1
then_1:
	%10 = alloca %SizeT, align 8
	store %SizeT 0, %SizeT* %10
; while_1
	br label %again_1
again_1:
	%11 = udiv %SizeT %8, 4
	%12 = load %SizeT, %SizeT* %10
	%13 = icmp ult %SizeT %12, %11
	br %Bool %13 , label %body_1, label %break_1
body_1:
	%14 = load %SizeT, %SizeT* %10
	%15 = load %SizeT, %SizeT* %10
	%16 = bitcast [0 x %Word8]* %bufptr to [0 x %Nat32]*
	%17 = trunc %SizeT %15 to %Nat32
	%18 = getelementptr [0 x %Nat32], [0 x %Nat32]* %16, %Int32 0, %Nat32 %17
	%19 = load %Nat32, %Nat32* %18
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str6 to [0 x i8]*), %SizeT %14, %Nat32 %19)
	%21 = load %SizeT, %SizeT* %10
	%22 = add %SizeT %21, 4
	store %SizeT %22, %SizeT* %10
	br label %again_1
break_1:
	%23 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([13 x i8]* @str7 to [0 x i8]*))
	br label %endif_1
endif_1:
	%24 = call %Int @fclose(%File* %2)
	%25 = trunc %SizeT %8 to %Nat32
	ret %Nat32 %25
}

define void @bus_show_ram() {
	%1 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat32, %Nat32* %1
	%3 = icmp ult %Nat32 %2, 256
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat32, %Nat32* %1
	%5 = mul %Nat32 %4, 16
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str8 to [0 x i8]*), %Nat32 %5)
	%7 = alloca %Nat32, align 4
	store %Nat32 0, %Nat32* %7
; while_2
	br label %again_2
again_2:
	%8 = load %Nat32, %Nat32* %7
	%9 = icmp ult %Nat32 %8, 16
	br %Bool %9 , label %body_2, label %break_2
body_2:
	%10 = load %Nat32, %Nat32* %1
	%11 = load %Nat32, %Nat32* %7
	%12 = add %Nat32 %10, %11
	%13 = bitcast %Nat32 %12 to %Nat32
	%14 = getelementptr [16384 x %Word8], [16384 x %Word8]* @ram, %Int32 0, %Nat32 %13
	%15 = load %Word8, %Word8* %14
	%16 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([6 x i8]* @str9 to [0 x i8]*), %Word8 %15)
	%17 = load %Nat32, %Nat32* %7
	%18 = add %Nat32 %17, 1
	store %Nat32 %18, %Nat32* %7
	br label %again_2
break_2:
	%19 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([2 x i8]* @str10 to [0 x i8]*))
	%20 = load %Nat32, %Nat32* %1
	%21 = add %Nat32 %20, 16
	store %Nat32 %21, %Nat32* %1
	br label %again_1
break_1:
	ret void
}


