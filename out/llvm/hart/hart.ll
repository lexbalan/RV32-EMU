
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
declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)
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

; MODULE: hart

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
; from included ctypes
; from included stdio
%File = type {
};

%FposT = type %Nat8;
%CharStr = type %Str;
%ConstCharStr = type %CharStr;
declare %Int @fclose(i8* %f)
declare %Int @feof(i8* %f)
declare %Int @ferror(i8* %f)
declare %Int @fflush(i8* %f)
declare %Int @fgetpos(i8* %f, %FposT* %pos)
declare i8* @fopen(%ConstCharStr* %fname, %ConstCharStr* %mode)
declare %SizeT @fread(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare %SizeT @fwrite(i8* %buf, %SizeT %size, %SizeT %count, i8* %f)
declare i8* @freopen(%ConstCharStr* %fname, %ConstCharStr* %mode, i8* %f)
declare %Int @fseek(i8* %f, %LongInt %offset, %Int %whence)
declare %Int @fsetpos(i8* %f, %FposT* %pos)
declare %LongInt @ftell(i8* %f)
declare %Int @remove(%ConstCharStr* %fname)
declare %Int @rename(%ConstCharStr* %old_filename, %ConstCharStr* %new_filename)
declare void @rewind(i8* %f)
declare void @setbuf(i8* %f, %CharStr* %buf)
declare %Int @setvbuf(i8* %f, %CharStr* %buf, %Int %mode, %SizeT %size)
declare i8* @tmpfile()
declare %CharStr* @tmpnam(%CharStr* %str)
declare %Int @printf(%ConstCharStr* %str, ...)
declare %Int @scanf(%ConstCharStr* %str, ...)
declare %Int @fprintf(i8* %f, %Str* %format, ...)
declare %Int @fscanf(i8* %f, %ConstCharStr* %format, ...)
declare %Int @sscanf(%ConstCharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @sprintf(%CharStr* %buf, %ConstCharStr* %format, ...)
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
declare %Int @vfprintf(i8* %f, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vprintf(%ConstCharStr* %format, %__VA_List %args)
declare %Int @vsprintf(%CharStr* %str, %ConstCharStr* %format, %__VA_List %args)
declare %Int @vsnprintf(%CharStr* %str, %SizeT %n, %ConstCharStr* %format, %__VA_List %args)
declare %Int @__vsnprintf_chk(%CharStr* %dest, %SizeT %len, %Int %flags, %SizeT %dstlen, %ConstCharStr* %format, %__VA_List %arg)
declare %Int @fgetc(i8* %f)
declare %Int @fputc(%Int %char, i8* %f)
declare %CharStr* @fgets(%CharStr* %str, %Int %n, i8* %f)
declare %Int @fputs(%ConstCharStr* %str, i8* %f)
declare %Int @getc(i8* %f)
declare %Int @getchar()
declare %CharStr* @gets(%CharStr* %str)
declare %Int @putc(%Int %char, i8* %f)
declare %Int @putchar(%Int %char)
declare %Int @puts(%ConstCharStr* %str)
declare %Int @ungetc(%Int %char, i8* %f)
declare void @perror(%ConstCharStr* %str)
; from included unistd
declare %Int @access([0 x %ConstChar]* %path, %Int %amode)
declare %UnsignedInt @alarm(%UnsignedInt %seconds)
declare %Int @brk(i8* %end_data_segment)
declare %Int @chdir([0 x %ConstChar]* %path)
declare %Int @chroot([0 x %ConstChar]* %path)
declare %Int @chown([0 x %ConstChar]* %pathname, %UIDT %owner, %GIDT %group)
declare %Int @close(%Int %fildes)
declare %SizeT @confstr(%Int %name, [0 x %Char]* %buf, %SizeT %len)
declare [0 x %Char]* @crypt([0 x %ConstChar]* %key, [0 x %ConstChar]* %salt)
declare [0 x %Char]* @ctermid([0 x %Char]* %s)
declare [0 x %Char]* @cuserid([0 x %Char]* %s)
declare %Int @dup(%Int %fildes)
declare %Int @dup2(%Int %fildes, %Int %fildes2)
declare void @encrypt([64 x %Char]* %block, %Int %edflag)
declare %Int @execl([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execle([0 x %ConstChar]* %path, [0 x %ConstChar]* %arg0, ...)
declare %Int @execlp([0 x %ConstChar]* %file, [0 x %ConstChar]* %arg0, ...)
declare %Int @execv([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv)
declare %Int @execve([0 x %ConstChar]* %path, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %envp)
declare %Int @execvp([0 x %ConstChar]* %file, [0 x %ConstChar]* %argv)
declare void @_exit(%Int %status)
declare %Int @fchown(%Int %fildes, %UIDT %owner, %GIDT %group)
declare %Int @fchdir(%Int %fildes)
declare %Int @fdatasync(%Int %fildes)
declare %PIDT @fork()
declare %LongInt @fpathconf(%Int %fildes, %Int %name)
declare %Int @fsync(%Int %fildes)
declare %Int @ftruncate(%Int %fildes, %OffT %length)
declare [0 x %Char]* @getcwd([0 x %Char]* %buf, %SizeT %size)
declare %Int @getdtablesize()
declare %GIDT @getegid()
declare %UIDT @geteuid()
declare %GIDT @getgid()
declare %Int @getgroups(%Int %gidsetsize, [0 x %GIDT]* %grouplist)
declare %Long @gethostid()
declare [0 x %Char]* @getlogin()
declare %Int @getlogin_r([0 x %Char]* %name, %SizeT %namesize)
declare %Int @getopt(%Int %argc, [0 x %ConstChar]* %argv, [0 x %ConstChar]* %optstring)
declare %Int @getpagesize()
declare [0 x %Char]* @getpass([0 x %ConstChar]* %prompt)
declare %PIDT @getpgid(%PIDT %pid)
declare %PIDT @getpgrp()
declare %PIDT @getpid()
declare %PIDT @getppid()
declare %PIDT @getsid(%PIDT %pid)
declare %UIDT @getuid()
declare [0 x %Char]* @getwd([0 x %Char]* %path_name)
declare %Int @isatty(%Int %fildes)
declare %Int @lchown([0 x %ConstChar]* %path, %UIDT %owner, %GIDT %group)
declare %Int @link([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare %Int @lockf(%Int %fildes, %Int %function, %OffT %size)
declare %OffT @lseek(%Int %fildes, %OffT %offset, %Int %whence)
declare %Int @nice(%Int %incr)
declare %LongInt @pathconf([0 x %ConstChar]* %path, %Int %name)
declare %Int @pause()
declare %Int @pipe([2 x %Int]* %fildes)
declare %SSizeT @pread(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @pwrite(%Int %fildes, i8* %buf, %SizeT %nbyte, %OffT %offset)
declare %SSizeT @read(%Int %fildes, i8* %buf, %SizeT %nbyte)
declare %Int @readlink([0 x %ConstChar]* %path, [0 x %Char]* %buf, %SizeT %bufsize)
declare %Int @rmdir([0 x %ConstChar]* %path)
declare i8* @sbrk(%IntPtrT %incr)
declare %Int @setgid(%GIDT %gid)
declare %Int @setpgid(%PIDT %pid, %PIDT %pgid)
declare %PIDT @setpgrp()
declare %Int @setregid(%GIDT %rgid, %GIDT %egid)
declare %Int @setreuid(%UIDT %ruid, %UIDT %euid)
declare %PIDT @setsid()
declare %Int @setuid(%UIDT %uid)
declare %UnsignedInt @sleep(%UnsignedInt %seconds)
declare void @swab(i8* %src, i8* %dst, %SSizeT %nbytes)
declare %Int @symlink([0 x %ConstChar]* %path1, [0 x %ConstChar]* %path2)
declare void @sync()
declare %LongInt @sysconf(%Int %name)
declare %PIDT @tcgetpgrp(%Int %fildes)
declare %Int @tcsetpgrp(%Int %fildes, %PIDT %pgid_id)
declare %Int @truncate([0 x %ConstChar]* %path, %OffT %length)
declare [0 x %Char]* @ttyname(%Int %fildes)
declare %Int @ttyname_r(%Int %fildes, [0 x %Char]* %name, %SizeT %namesize)
declare %USecondsT @ualarm(%USecondsT %useconds, %USecondsT %interval)
declare %Int @unlink([0 x %ConstChar]* %path)
declare %Int @usleep(%USecondsT %useconds)
declare %PIDT @vfork()
declare %SSizeT @write(%Int %fildes, i8* %buf, %SizeT %nbyte)
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
; from included decode
declare %Word8 @decode_extract_op(%Word32 %instr)
declare %Word8 @decode_extract_funct2(%Word32 %instr)
declare %Word8 @decode_extract_funct3(%Word32 %instr)
declare %Word8 @decode_extract_funct5(%Word32 %instr)
declare %Nat8 @decode_extract_rd(%Word32 %instr)
declare %Nat8 @decode_extract_rs1(%Word32 %instr)
declare %Nat8 @decode_extract_rs2(%Word32 %instr)
declare %Word8 @decode_extract_funct7(%Word32 %instr)
declare %Word32 @decode_extract_imm12(%Word32 %instr)
declare %Word32 @decode_extract_imm31_12(%Word32 %instr)
declare %Int16 @decode_extract_b_imm(%Word32 %instr)
declare %Word32 @decode_extract_jal_imm(%Word32 %instr)
declare %Int32 @decode_expand12(%Word32 %val_12bit)
declare %Int32 @decode_expand20(%Word32 %val_20bit)
; -- end print includes --
; -- print imports private 'hart' --

; from import "builtin"

; end from import "builtin"

; from import "csr"

; end from import "csr"
; -- end print imports private 'hart' --
; -- print imports public 'hart' --
; -- end print imports public 'hart' --
; -- strings --
@str1 = private constant [15 x i8] [i8 104, i8 97, i8 114, i8 116, i8 32, i8 35, i8 37, i8 100, i8 32, i8 105, i8 110, i8 105, i8 116, i8 10, i8 0]
@str2 = private constant [12 x i8] [i8 10, i8 73, i8 78, i8 84, i8 32, i8 35, i8 37, i8 48, i8 50, i8 88, i8 10, i8 0]
@str3 = private constant [12 x i8] [i8 65, i8 68, i8 82, i8 32, i8 61, i8 32, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@str4 = private constant [22 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 79, i8 80, i8 67, i8 79, i8 68, i8 69, i8 58, i8 32, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@str5 = private constant [19 x i8] [i8 97, i8 100, i8 100, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str6 = private constant [19 x i8] [i8 115, i8 108, i8 108, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str7 = private constant [19 x i8] [i8 115, i8 108, i8 116, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str8 = private constant [20 x i8] [i8 115, i8 108, i8 116, i8 105, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str9 = private constant [19 x i8] [i8 120, i8 111, i8 114, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str10 = private constant [19 x i8] [i8 115, i8 114, i8 108, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str11 = private constant [19 x i8] [i8 115, i8 114, i8 97, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str12 = private constant [18 x i8] [i8 111, i8 114, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str13 = private constant [19 x i8] [i8 97, i8 110, i8 100, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str14 = private constant [19 x i8] [i8 109, i8 117, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str15 = private constant [20 x i8] [i8 109, i8 117, i8 108, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str16 = private constant [22 x i8] [i8 109, i8 117, i8 108, i8 104, i8 115, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str17 = private constant [21 x i8] [i8 109, i8 117, i8 108, i8 104, i8 115, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 0]
@str18 = private constant [21 x i8] [i8 109, i8 117, i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str19 = private constant [21 x i8] [i8 109, i8 117, i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str20 = private constant [19 x i8] [i8 100, i8 105, i8 118, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str21 = private constant [20 x i8] [i8 100, i8 105, i8 118, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str22 = private constant [19 x i8] [i8 114, i8 101, i8 109, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str23 = private constant [20 x i8] [i8 114, i8 101, i8 109, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str24 = private constant [19 x i8] [i8 97, i8 100, i8 100, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str25 = private constant [19 x i8] [i8 115, i8 117, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str26 = private constant [19 x i8] [i8 115, i8 108, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str27 = private constant [19 x i8] [i8 115, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str28 = private constant [20 x i8] [i8 115, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str29 = private constant [19 x i8] [i8 120, i8 111, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str30 = private constant [19 x i8] [i8 115, i8 114, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str31 = private constant [19 x i8] [i8 115, i8 114, i8 97, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str32 = private constant [18 x i8] [i8 111, i8 114, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str33 = private constant [19 x i8] [i8 97, i8 110, i8 100, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 10, i8 0]
@str34 = private constant [15 x i8] [i8 108, i8 117, i8 105, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str35 = private constant [17 x i8] [i8 97, i8 117, i8 105, i8 112, i8 99, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 48, i8 120, i8 37, i8 88, i8 10, i8 0]
@str36 = private constant [13 x i8] [i8 106, i8 97, i8 108, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str37 = private constant [14 x i8] [i8 106, i8 97, i8 108, i8 114, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str38 = private constant [18 x i8] [i8 98, i8 101, i8 113, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str39 = private constant [18 x i8] [i8 98, i8 110, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str40 = private constant [18 x i8] [i8 98, i8 108, i8 116, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str41 = private constant [18 x i8] [i8 98, i8 103, i8 101, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str42 = private constant [19 x i8] [i8 98, i8 108, i8 116, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str43 = private constant [19 x i8] [i8 98, i8 103, i8 101, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 10, i8 0]
@str44 = private constant [17 x i8] [i8 108, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str45 = private constant [17 x i8] [i8 108, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str46 = private constant [17 x i8] [i8 108, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str47 = private constant [18 x i8] [i8 108, i8 98, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str48 = private constant [18 x i8] [i8 108, i8 104, i8 117, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str49 = private constant [17 x i8] [i8 115, i8 98, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str50 = private constant [17 x i8] [i8 115, i8 104, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str51 = private constant [17 x i8] [i8 115, i8 119, i8 32, i8 120, i8 37, i8 100, i8 44, i8 32, i8 37, i8 100, i8 40, i8 120, i8 37, i8 100, i8 41, i8 10, i8 0]
@str52 = private constant [28 x i8] [i8 83, i8 89, i8 83, i8 84, i8 69, i8 77, i8 32, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 58, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@str53 = private constant [7 x i8] [i8 101, i8 99, i8 97, i8 108, i8 108, i8 10, i8 0]
@str54 = private constant [17 x i8] [i8 69, i8 67, i8 65, i8 76, i8 76, i8 58, i8 32, i8 104, i8 97, i8 114, i8 116, i8 32, i8 35, i8 37, i8 100, i8 10, i8 0]
@str55 = private constant [6 x i8] [i8 109, i8 114, i8 101, i8 116, i8 10, i8 0]
@str56 = private constant [52 x i8] [i8 77, i8 82, i8 69, i8 84, i8 58, i8 32, i8 104, i8 97, i8 114, i8 116, i8 32, i8 35, i8 37, i8 100, i8 44, i8 32, i8 109, i8 101, i8 112, i8 99, i8 61, i8 37, i8 48, i8 56, i8 88, i8 44, i8 32, i8 109, i8 99, i8 97, i8 117, i8 115, i8 101, i8 61, i8 37, i8 48, i8 56, i8 88, i8 44, i8 32, i8 109, i8 116, i8 118, i8 97, i8 108, i8 61, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
@str57 = private constant [8 x i8] [i8 101, i8 98, i8 114, i8 101, i8 97, i8 107, i8 10, i8 0]
@str58 = private constant [34 x i8] [i8 85, i8 78, i8 75, i8 78, i8 79, i8 87, i8 78, i8 32, i8 83, i8 89, i8 83, i8 84, i8 69, i8 77, i8 32, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 58, i8 32, i8 48, i8 120, i8 37, i8 120, i8 10, i8 0]
@str59 = private constant [7 x i8] [i8 80, i8 65, i8 85, i8 83, i8 69, i8 10, i8 0]
@str60 = private constant [35 x i8] [i8 67, i8 83, i8 82, i8 95, i8 82, i8 87, i8 40, i8 99, i8 115, i8 114, i8 61, i8 48, i8 120, i8 37, i8 88, i8 44, i8 32, i8 114, i8 100, i8 61, i8 114, i8 37, i8 100, i8 44, i8 32, i8 114, i8 115, i8 49, i8 61, i8 114, i8 37, i8 100, i8 41, i8 10, i8 0]
@str61 = private constant [8 x i8] [i8 91, i8 37, i8 48, i8 56, i8 88, i8 93, i8 32, i8 0]
@str62 = private constant [3 x i8] [i8 37, i8 99, i8 0]
@str63 = private constant [8 x i8] [i8 91, i8 37, i8 48, i8 56, i8 88, i8 93, i8 32, i8 0]
@str64 = private constant [33 x i8] [i8 10, i8 10, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 95, i8 78, i8 79, i8 84, i8 95, i8 73, i8 77, i8 80, i8 76, i8 69, i8 77, i8 69, i8 78, i8 84, i8 69, i8 68, i8 58, i8 32, i8 34, i8 0]
@str65 = private constant [3 x i8] [i8 34, i8 10, i8 0]
@str66 = private constant [15 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 0]
@str67 = private constant [5 x i8] [i8 32, i8 32, i8 32, i8 32, i8 0]
@str68 = private constant [16 x i8] [i8 120, i8 37, i8 48, i8 50, i8 100, i8 32, i8 61, i8 32, i8 48, i8 120, i8 37, i8 48, i8 56, i8 120, i8 10, i8 0]
; -- endstrings --
%hart_Hart = type {
	[32 x %Word32],
	%Nat32,
	%hart_BusInterface*,
	%Word32,
	%Bool,
	[4096 x %Word32]
};

%hart_BusInterface = type {
	%Word32 (%Nat32, %Nat8)*,
	void (%Nat32, %Word32, %Nat8)*
};
; branch; jump and link by register; fence; machine return from trap
define void @hart_init(%hart_Hart* %hart, %Nat32 %id, %hart_BusInterface* %bus) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str1 to [0 x i8]*), %Nat32 %id)
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%3 = bitcast %Nat32 3860 to %Nat32
	%4 = getelementptr [4096 x %Word32], [4096 x %Word32]* %2, %Int32 0, %Nat32 %3
	%5 = bitcast %Nat32 %id to %Word32
	store %Word32 %5, %Word32* %4
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%7 = bitcast %Nat32 769 to %Nat32
	%8 = getelementptr [4096 x %Word32], [4096 x %Word32]* %6, %Int32 0, %Nat32 %7
	store %Word32 1073746176, %Word32* %8
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%10 = zext i8 32 to %Nat32
	%11 = mul %Nat32 %10, 4
	%12 = bitcast [32 x %Word32]* %9 to i8*
	call void (i8*, i8, i32, i1) @llvm.memset.p0.i32(i8* %12, i8 0, %Nat32 %11, i1 0)
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	store %Nat32 0, %Nat32* %13
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	store %hart_BusInterface* %bus, %hart_BusInterface** %14
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%16 = zext i8 0 to %Word32
	store %Word32 %16, %Word32* %15
	%17 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Bool 0, %Bool* %17
	ret void
}

define internal %Word32 @fetch(%hart_Hart* %hart) alwaysinline {
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%2 = load %Nat32, %Nat32* %1
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%4 = load %hart_BusInterface*, %hart_BusInterface** %3
	%5 = getelementptr %hart_BusInterface, %hart_BusInterface* %4, %Int32 0, %Int32 0
	%6 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %5
	%7 = call %Word32 %6(%Nat32 %2, %Nat8 4)
	ret %Word32 %7
}

define void @hart_cycle(%hart_Hart* %hart) {
; if_0
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%2 = zext i8 0 to %Word32
	%3 = load %Word32, %Word32* %1
	%4 = icmp ne %Word32 %3, %2
	br %Bool %4 , label %then_0, label %endif_0
then_0:
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%6 = load %Nat32, %Nat32* %5
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%8 = load %Word32, %Word32* %7
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %6, %Str8* bitcast ([12 x i8]* @str2 to [0 x i8]*), %Word32 %8)
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = bitcast %Nat32 773 to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	%12 = load %Word32, %Word32* %11
	%13 = bitcast %Word32 %12 to %Nat32
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([12 x i8]* @str3 to [0 x i8]*), %Nat32 %13)
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%16 = bitcast %Nat32 833 to %Nat32
	%17 = getelementptr [4096 x %Word32], [4096 x %Word32]* %15, %Int32 0, %Nat32 %16
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%19 = load %Nat32, %Nat32* %18
	%20 = bitcast %Nat32 %19 to %Word32
	store %Word32 %20, %Word32* %17
	%21 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%22 = bitcast %Nat32 834 to %Nat32
	%23 = getelementptr [4096 x %Word32], [4096 x %Word32]* %21, %Int32 0, %Nat32 %22
	%24 = zext i8 0 to %Word32
	store %Word32 %24, %Word32* %23
	%25 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%26 = bitcast %Nat32 835 to %Nat32
	%27 = getelementptr [4096 x %Word32], [4096 x %Word32]* %25, %Int32 0, %Nat32 %26
	%28 = zext i8 0 to %Word32
	store %Word32 %28, %Word32* %27
	%29 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	store %Nat32 %13, %Nat32* %29
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%31 = zext i8 0 to %Word32
	store %Word32 %31, %Word32* %30
	br label %endif_0
endif_0:
	%32 = call %Word32 @fetch(%hart_Hart* %hart)
	call void @exec(%hart_Hart* %hart, %Word32 %32)
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%34 = bitcast %Nat32 2816 to %Nat32
	%35 = getelementptr [4096 x %Word32], [4096 x %Word32]* %33, %Int32 0, %Nat32 %34
	%36 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%37 = bitcast %Nat32 2816 to %Nat32
	%38 = getelementptr [4096 x %Word32], [4096 x %Word32]* %36, %Int32 0, %Nat32 %37
	%39 = load %Word32, %Word32* %38
	%40 = bitcast %Word32 %39 to %Nat32
	%41 = add %Nat32 %40, 1
	%42 = bitcast %Nat32 %41 to %Word32
	store %Word32 %42, %Word32* %35
	ret void
}

define internal void @exec(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_op(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%4 = getelementptr [32 x %Word32], [32 x %Word32]* %3, %Int32 0, %Int32 0
	%5 = zext i8 0 to %Word32
	store %Word32 %5, %Word32* %4
	%6 = alloca %Nat32, align 4
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%8 = load %Nat32, %Nat32* %7
	%9 = add %Nat32 %8, 4
	store %Nat32 %9, %Nat32* %6
; if_0
	%10 = bitcast i8 19 to %Word8
	%11 = icmp eq %Word8 %1, %10
	br %Bool %11 , label %then_0, label %else_0
then_0:
	call void @execI(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_0
else_0:
; if_1
	%12 = bitcast i8 51 to %Word8
	%13 = icmp eq %Word8 %1, %12
	br %Bool %13 , label %then_1, label %else_1
then_1:
	call void @execR(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_1
else_1:
; if_2
	%14 = bitcast i8 55 to %Word8
	%15 = icmp eq %Word8 %1, %14
	br %Bool %15 , label %then_2, label %else_2
then_2:
	call void @execLUI(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_2
else_2:
; if_3
	%16 = bitcast i8 23 to %Word8
	%17 = icmp eq %Word8 %1, %16
	br %Bool %17 , label %then_3, label %else_3
then_3:
	call void @execAUIPC(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_3
else_3:
; if_4
	%18 = bitcast i8 111 to %Word8
	%19 = icmp eq %Word8 %1, %18
	br %Bool %19 , label %then_4, label %else_4
then_4:
	%20 = call %Nat32 @execJAL(%hart_Hart* %hart, %Word32 %instr)
	store %Nat32 %20, %Nat32* %6
	br label %endif_4
else_4:
; if_5
	%21 = bitcast i8 103 to %Word8
	%22 = icmp eq %Word8 %1, %21
	%23 = bitcast i8 0 to %Word8
	%24 = icmp eq %Word8 %2, %23
	%25 = and %Bool %22, %24
	br %Bool %25 , label %then_5, label %else_5
then_5:
	%26 = call %Nat32 @execJALR(%hart_Hart* %hart, %Word32 %instr)
	store %Nat32 %26, %Nat32* %6
	br label %endif_5
else_5:
; if_6
	%27 = bitcast i8 99 to %Word8
	%28 = icmp eq %Word8 %1, %27
	br %Bool %28 , label %then_6, label %else_6
then_6:
	%29 = call %Nat32 @execB(%hart_Hart* %hart, %Word32 %instr)
	store %Nat32 %29, %Nat32* %6
	br label %endif_6
else_6:
; if_7
	%30 = bitcast i8 3 to %Word8
	%31 = icmp eq %Word8 %1, %30
	br %Bool %31 , label %then_7, label %else_7
then_7:
	call void @execL(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_7
else_7:
; if_8
	%32 = bitcast i8 35 to %Word8
	%33 = icmp eq %Word8 %1, %32
	br %Bool %33 , label %then_8, label %else_8
then_8:
	call void @execS(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_8
else_8:
; if_9
	%34 = bitcast i8 115 to %Word8
	%35 = icmp eq %Word8 %1, %34
	br %Bool %35 , label %then_9, label %else_9
then_9:
	call void @execSystem(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_9
else_9:
; if_10
	%36 = bitcast i8 15 to %Word8
	%37 = icmp eq %Word8 %1, %36
	br %Bool %37 , label %then_10, label %else_10
then_10:
	call void @execFence(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_10
else_10:
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%39 = load %Nat32, %Nat32* %38
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %39, %Str8* bitcast ([22 x i8]* @str4 to [0 x i8]*), %Word8 %1)
	br label %endif_10
endif_10:
	br label %endif_9
endif_9:
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%40 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%41 = load %Nat32, %Nat32* %6
	store %Nat32 %41, %Nat32* %40
	ret void
}

define internal void @execI(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%7 = alloca %Word32, align 4
; if_0
	%8 = bitcast i8 0 to %Word8
	%9 = icmp eq %Word8 %1, %8
	br %Bool %9 , label %then_0, label %else_0
then_0:
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%11 = load %Nat32, %Nat32* %10
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %11, %Str8* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%13 = zext %Nat8 %6 to %Nat32
	%14 = getelementptr [32 x %Word32], [32 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = load %Word32, %Word32* %14
	%16 = bitcast %Word32 %15 to %Int32
	%17 = add %Int32 %16, %4
	%18 = bitcast %Int32 %17 to %Word32
	store %Word32 %18, %Word32* %7
	br label %endif_0
else_0:
; if_1
	%19 = bitcast i8 1 to %Word8
	%20 = icmp eq %Word8 %1, %19
	%21 = bitcast i8 0 to %Word8
	%22 = icmp eq %Word8 %2, %21
	%23 = and %Bool %20, %22
	br %Bool %23 , label %then_1, label %else_1
then_1:
	%24 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%25 = load %Nat32, %Nat32* %24
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %25, %Str8* bitcast ([19 x i8]* @str6 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%27 = zext %Nat8 %6 to %Nat32
	%28 = getelementptr [32 x %Word32], [32 x %Word32]* %26, %Int32 0, %Nat32 %27
	%29 = load %Word32, %Word32* %28
	%30 = trunc %Int32 %4 to %Nat8
	%31 = zext %Nat8 %30 to %Word32
	%32 = shl %Word32 %29, %31
	store %Word32 %32, %Word32* %7
	br label %endif_1
else_1:
; if_2
	%33 = bitcast i8 2 to %Word8
	%34 = icmp eq %Word8 %1, %33
	br %Bool %34 , label %then_2, label %else_2
then_2:
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%36 = load %Nat32, %Nat32* %35
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %36, %Str8* bitcast ([19 x i8]* @str7 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%37 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%38 = zext %Nat8 %6 to %Nat32
	%39 = getelementptr [32 x %Word32], [32 x %Word32]* %37, %Int32 0, %Nat32 %38
	%40 = load %Word32, %Word32* %39
	%41 = bitcast %Word32 %40 to %Int32
	%42 = icmp slt %Int32 %41, %4
	%43 = zext %Bool %42 to %Word32
	store %Word32 %43, %Word32* %7
	br label %endif_2
else_2:
; if_3
	%44 = bitcast i8 3 to %Word8
	%45 = icmp eq %Word8 %1, %44
	br %Bool %45 , label %then_3, label %else_3
then_3:
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%47 = load %Nat32, %Nat32* %46
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %47, %Str8* bitcast ([20 x i8]* @str8 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%48 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%49 = zext %Nat8 %6 to %Nat32
	%50 = getelementptr [32 x %Word32], [32 x %Word32]* %48, %Int32 0, %Nat32 %49
	%51 = load %Word32, %Word32* %50
	%52 = bitcast %Word32 %51 to %Nat32
	%53 = bitcast %Int32 %4 to %Nat32
	%54 = icmp ult %Nat32 %52, %53
	%55 = zext %Bool %54 to %Word32
	store %Word32 %55, %Word32* %7
	br label %endif_3
else_3:
; if_4
	%56 = bitcast i8 4 to %Word8
	%57 = icmp eq %Word8 %1, %56
	br %Bool %57 , label %then_4, label %else_4
then_4:
	%58 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%59 = load %Nat32, %Nat32* %58
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %59, %Str8* bitcast ([19 x i8]* @str9 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%60 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%61 = zext %Nat8 %6 to %Nat32
	%62 = getelementptr [32 x %Word32], [32 x %Word32]* %60, %Int32 0, %Nat32 %61
	%63 = bitcast %Int32 %4 to %Word32
	%64 = load %Word32, %Word32* %62
	%65 = xor %Word32 %64, %63
	store %Word32 %65, %Word32* %7
	br label %endif_4
else_4:
; if_5
	%66 = bitcast i8 5 to %Word8
	%67 = icmp eq %Word8 %1, %66
	%68 = bitcast i8 0 to %Word8
	%69 = icmp eq %Word8 %2, %68
	%70 = and %Bool %67, %69
	br %Bool %70 , label %then_5, label %else_5
then_5:
	%71 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%72 = load %Nat32, %Nat32* %71
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %72, %Str8* bitcast ([19 x i8]* @str10 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%73 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%74 = zext %Nat8 %6 to %Nat32
	%75 = getelementptr [32 x %Word32], [32 x %Word32]* %73, %Int32 0, %Nat32 %74
	%76 = load %Word32, %Word32* %75
	%77 = trunc %Int32 %4 to %Nat8
	%78 = zext %Nat8 %77 to %Word32
	%79 = lshr %Word32 %76, %78
	store %Word32 %79, %Word32* %7
	br label %endif_5
else_5:
; if_6
	%80 = bitcast i8 5 to %Word8
	%81 = icmp eq %Word8 %1, %80
	%82 = bitcast i8 32 to %Word8
	%83 = icmp eq %Word8 %2, %82
	%84 = and %Bool %81, %83
	br %Bool %84 , label %then_6, label %else_6
then_6:
	%85 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%86 = load %Nat32, %Nat32* %85
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %86, %Str8* bitcast ([19 x i8]* @str11 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%87 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%88 = zext %Nat8 %6 to %Nat32
	%89 = getelementptr [32 x %Word32], [32 x %Word32]* %87, %Int32 0, %Nat32 %88
	%90 = load %Word32, %Word32* %89
	%91 = trunc %Int32 %4 to %Nat8
	%92 = zext %Nat8 %91 to %Word32
	%93 = lshr %Word32 %90, %92
	store %Word32 %93, %Word32* %7
	br label %endif_6
else_6:
; if_7
	%94 = bitcast i8 6 to %Word8
	%95 = icmp eq %Word8 %1, %94
	br %Bool %95 , label %then_7, label %else_7
then_7:
	%96 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%97 = load %Nat32, %Nat32* %96
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %97, %Str8* bitcast ([18 x i8]* @str12 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%98 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%99 = zext %Nat8 %6 to %Nat32
	%100 = getelementptr [32 x %Word32], [32 x %Word32]* %98, %Int32 0, %Nat32 %99
	%101 = bitcast %Int32 %4 to %Word32
	%102 = load %Word32, %Word32* %100
	%103 = or %Word32 %102, %101
	store %Word32 %103, %Word32* %7
	br label %endif_7
else_7:
; if_8
	%104 = bitcast i8 7 to %Word8
	%105 = icmp eq %Word8 %1, %104
	br %Bool %105 , label %then_8, label %else_8
then_8:
	%106 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%107 = load %Nat32, %Nat32* %106
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %107, %Str8* bitcast ([19 x i8]* @str13 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%108 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%109 = zext %Nat8 %6 to %Nat32
	%110 = getelementptr [32 x %Word32], [32 x %Word32]* %108, %Int32 0, %Nat32 %109
	%111 = bitcast %Int32 %4 to %Word32
	%112 = load %Word32, %Word32* %110
	%113 = and %Word32 %112, %111
	store %Word32 %113, %Word32* %7
	br label %endif_8
else_8:
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%114 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%115 = zext %Nat8 %5 to %Nat32
	%116 = getelementptr [32 x %Word32], [32 x %Word32]* %114, %Int32 0, %Nat32 %115
	%117 = load %Word32, %Word32* %7
	store %Word32 %117, %Word32* %116
	ret void
}

define internal void @execR(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%4 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%5 = call %Nat8 @decode_extract_rs2(%Word32 %instr)
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%7 = zext %Nat8 %4 to %Nat32
	%8 = getelementptr [32 x %Word32], [32 x %Word32]* %6, %Int32 0, %Nat32 %7
	%9 = load %Word32, %Word32* %8
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%11 = zext %Nat8 %5 to %Nat32
	%12 = getelementptr [32 x %Word32], [32 x %Word32]* %10, %Int32 0, %Nat32 %11
	%13 = load %Word32, %Word32* %12
	%14 = alloca %Word32, align 4
; if_0
	%15 = bitcast i8 1 to %Word8
	%16 = icmp eq %Word8 %2, %15
	br %Bool %16 , label %then_0, label %else_0
then_0:
; if_1
	%17 = bitcast i8 0 to %Word8
	%18 = icmp eq %Word8 %1, %17
	br %Bool %18 , label %then_1, label %else_1
then_1:
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%20 = load %Nat32, %Nat32* %19
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %20, %Str8* bitcast ([19 x i8]* @str14 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%21 = bitcast %Word32 %9 to %Int32
	%22 = bitcast %Word32 %13 to %Int32
	%23 = mul %Int32 %21, %22
	%24 = bitcast %Int32 %23 to %Word32
	store %Word32 %24, %Word32* %14
	br label %endif_1
else_1:
; if_2
	%25 = bitcast i8 1 to %Word8
	%26 = icmp eq %Word8 %1, %25
	br %Bool %26 , label %then_2, label %else_2
then_2:
	%27 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%28 = load %Nat32, %Nat32* %27
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %28, %Str8* bitcast ([20 x i8]* @str15 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%29 = sext %Word32 %9 to %Int64
	%30 = sext %Word32 %13 to %Int64
	%31 = mul %Int64 %29, %30
	%32 = bitcast %Int64 %31 to %Word64
	%33 = zext i8 32 to %Word64
	%34 = lshr %Word64 %32, %33
	%35 = trunc %Word64 %34 to %Word32
	store %Word32 %35, %Word32* %14
	br label %endif_2
else_2:
; if_3
	%36 = bitcast i8 2 to %Word8
	%37 = icmp eq %Word8 %1, %36
	br %Bool %37 , label %then_3, label %else_3
then_3:
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%39 = load %Nat32, %Nat32* %38
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %39, %Str8* bitcast ([22 x i8]* @str16 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str17 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	br label %endif_3
else_3:
; if_4
	%40 = bitcast i8 3 to %Word8
	%41 = icmp eq %Word8 %1, %40
	br %Bool %41 , label %then_4, label %else_4
then_4:
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%43 = load %Nat32, %Nat32* %42
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %43, %Str8* bitcast ([21 x i8]* @str18 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str19 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	br label %endif_4
else_4:
; if_5
	%44 = bitcast i8 4 to %Word8
	%45 = icmp eq %Word8 %1, %44
	br %Bool %45 , label %then_5, label %else_5
then_5:
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%47 = load %Nat32, %Nat32* %46
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %47, %Str8* bitcast ([19 x i8]* @str20 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%48 = bitcast %Word32 %9 to %Int32
	%49 = bitcast %Word32 %13 to %Int32
	%50 = sdiv %Int32 %48, %49
	%51 = bitcast %Int32 %50 to %Word32
	store %Word32 %51, %Word32* %14
	br label %endif_5
else_5:
; if_6
	%52 = bitcast i8 5 to %Word8
	%53 = icmp eq %Word8 %1, %52
	br %Bool %53 , label %then_6, label %else_6
then_6:
	%54 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%55 = load %Nat32, %Nat32* %54
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %55, %Str8* bitcast ([20 x i8]* @str21 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%56 = bitcast %Word32 %9 to %Nat32
	%57 = bitcast %Word32 %13 to %Nat32
	%58 = udiv %Nat32 %56, %57
	%59 = bitcast %Nat32 %58 to %Word32
	store %Word32 %59, %Word32* %14
	br label %endif_6
else_6:
; if_7
	%60 = bitcast i8 6 to %Word8
	%61 = icmp eq %Word8 %1, %60
	br %Bool %61 , label %then_7, label %else_7
then_7:
	%62 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%63 = load %Nat32, %Nat32* %62
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %63, %Str8* bitcast ([19 x i8]* @str22 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%64 = bitcast %Word32 %9 to %Int32
	%65 = bitcast %Word32 %13 to %Int32
	%66 = srem %Int32 %64, %65
	%67 = bitcast %Int32 %66 to %Word32
	store %Word32 %67, %Word32* %14
	br label %endif_7
else_7:
; if_8
	%68 = bitcast i8 7 to %Word8
	%69 = icmp eq %Word8 %1, %68
	br %Bool %69 , label %then_8, label %endif_8
then_8:
	%70 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%71 = load %Nat32, %Nat32* %70
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %71, %Str8* bitcast ([20 x i8]* @str23 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%72 = bitcast %Word32 %9 to %Nat32
	%73 = bitcast %Word32 %13 to %Nat32
	%74 = urem %Nat32 %72, %73
	%75 = bitcast %Nat32 %74 to %Word32
	store %Word32 %75, %Word32* %14
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
; if_9
	%76 = bitcast i8 0 to %Word8
	%77 = icmp eq %Word8 %1, %76
	%78 = bitcast i8 0 to %Word8
	%79 = icmp eq %Word8 %2, %78
	%80 = and %Bool %77, %79
	br %Bool %80 , label %then_9, label %else_9
then_9:
	%81 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%82 = load %Nat32, %Nat32* %81
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %82, %Str8* bitcast ([19 x i8]* @str24 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%83 = bitcast %Word32 %9 to %Int32
	%84 = bitcast %Word32 %13 to %Int32
	%85 = add %Int32 %83, %84
	%86 = bitcast %Int32 %85 to %Word32
	store %Word32 %86, %Word32* %14
	br label %endif_9
else_9:
; if_10
	%87 = bitcast i8 0 to %Word8
	%88 = icmp eq %Word8 %1, %87
	%89 = bitcast i8 32 to %Word8
	%90 = icmp eq %Word8 %2, %89
	%91 = and %Bool %88, %90
	br %Bool %91 , label %then_10, label %else_10
then_10:
	%92 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%93 = load %Nat32, %Nat32* %92
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %93, %Str8* bitcast ([19 x i8]* @str25 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%94 = bitcast %Word32 %9 to %Int32
	%95 = bitcast %Word32 %13 to %Int32
	%96 = sub %Int32 %94, %95
	%97 = bitcast %Int32 %96 to %Word32
	store %Word32 %97, %Word32* %14
	br label %endif_10
else_10:
; if_11
	%98 = bitcast i8 1 to %Word8
	%99 = icmp eq %Word8 %1, %98
	br %Bool %99 , label %then_11, label %else_11
then_11:
	%100 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%101 = load %Nat32, %Nat32* %100
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %101, %Str8* bitcast ([19 x i8]* @str26 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%102 = trunc %Word32 %13 to %Nat8
	%103 = zext %Nat8 %102 to %Word32
	%104 = shl %Word32 %9, %103
	store %Word32 %104, %Word32* %14
	br label %endif_11
else_11:
; if_12
	%105 = bitcast i8 2 to %Word8
	%106 = icmp eq %Word8 %1, %105
	br %Bool %106 , label %then_12, label %else_12
then_12:
	%107 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%108 = load %Nat32, %Nat32* %107
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %108, %Str8* bitcast ([19 x i8]* @str27 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%109 = bitcast %Word32 %9 to %Int32
	%110 = bitcast %Word32 %13 to %Int32
	%111 = icmp slt %Int32 %109, %110
	%112 = zext %Bool %111 to %Word32
	store %Word32 %112, %Word32* %14
	br label %endif_12
else_12:
; if_13
	%113 = bitcast i8 3 to %Word8
	%114 = icmp eq %Word8 %1, %113
	br %Bool %114 , label %then_13, label %else_13
then_13:
	%115 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%116 = load %Nat32, %Nat32* %115
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %116, %Str8* bitcast ([20 x i8]* @str28 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%117 = bitcast %Word32 %9 to %Nat32
	%118 = bitcast %Word32 %13 to %Nat32
	%119 = icmp ult %Nat32 %117, %118
	%120 = zext %Bool %119 to %Word32
	store %Word32 %120, %Word32* %14
	br label %endif_13
else_13:
; if_14
	%121 = bitcast i8 4 to %Word8
	%122 = icmp eq %Word8 %1, %121
	br %Bool %122 , label %then_14, label %else_14
then_14:
	%123 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%124 = load %Nat32, %Nat32* %123
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %124, %Str8* bitcast ([19 x i8]* @str29 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%125 = xor %Word32 %9, %13
	store %Word32 %125, %Word32* %14
	br label %endif_14
else_14:
; if_15
	%126 = bitcast i8 5 to %Word8
	%127 = icmp eq %Word8 %1, %126
	%128 = bitcast i8 0 to %Word8
	%129 = icmp eq %Word8 %2, %128
	%130 = and %Bool %127, %129
	br %Bool %130 , label %then_15, label %else_15
then_15:
	%131 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%132 = load %Nat32, %Nat32* %131
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %132, %Str8* bitcast ([19 x i8]* @str30 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%133 = trunc %Word32 %13 to %Nat8
	%134 = zext %Nat8 %133 to %Word32
	%135 = lshr %Word32 %9, %134
	store %Word32 %135, %Word32* %14
	br label %endif_15
else_15:
; if_16
	%136 = bitcast i8 5 to %Word8
	%137 = icmp eq %Word8 %1, %136
	%138 = bitcast i8 32 to %Word8
	%139 = icmp eq %Word8 %2, %138
	%140 = and %Bool %137, %139
	br %Bool %140 , label %then_16, label %else_16
then_16:
	%141 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%142 = load %Nat32, %Nat32* %141
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %142, %Str8* bitcast ([19 x i8]* @str31 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	br label %endif_16
else_16:
; if_17
	%143 = bitcast i8 6 to %Word8
	%144 = icmp eq %Word8 %1, %143
	br %Bool %144 , label %then_17, label %else_17
then_17:
	%145 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%146 = load %Nat32, %Nat32* %145
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %146, %Str8* bitcast ([18 x i8]* @str32 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%147 = or %Word32 %9, %13
	store %Word32 %147, %Word32* %14
	br label %endif_17
else_17:
; if_18
	%148 = bitcast i8 7 to %Word8
	%149 = icmp eq %Word8 %1, %148
	br %Bool %149 , label %then_18, label %endif_18
then_18:
	%150 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%151 = load %Nat32, %Nat32* %150
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %151, %Str8* bitcast ([19 x i8]* @str33 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%152 = and %Word32 %9, %13
	store %Word32 %152, %Word32* %14
	br label %endif_18
endif_18:
	br label %endif_17
endif_17:
	br label %endif_16
endif_16:
	br label %endif_15
endif_15:
	br label %endif_14
endif_14:
	br label %endif_13
endif_13:
	br label %endif_12
endif_12:
	br label %endif_11
endif_11:
	br label %endif_10
endif_10:
	br label %endif_9
endif_9:
	br label %endif_0
endif_0:
	%153 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%154 = zext %Nat8 %3 to %Nat32
	%155 = getelementptr [32 x %Word32], [32 x %Word32]* %153, %Int32 0, %Nat32 %154
	%156 = load %Word32, %Word32* %14
	store %Word32 %156, %Word32* %155
	ret void
}

define internal void @execLUI(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%4 = load %Nat32, %Nat32* %3
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %4, %Str8* bitcast ([15 x i8]* @str34 to [0 x i8]*), %Nat8 %2, %Word32 %1)
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %2 to %Nat32
	%7 = getelementptr [32 x %Word32], [32 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = zext i8 12 to %Word32
	%9 = shl %Word32 %1, %8
	store %Word32 %9, %Word32* %7
	ret void
}

define internal void @execAUIPC(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word32 @decode_extract_imm31_12(%Word32 %instr)
	%2 = call %Int32 @decode_expand12(%Word32 %1)
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%4 = bitcast %Int32 %2 to %Word32
	%5 = zext i8 12 to %Word32
	%6 = shl %Word32 %4, %5
	%7 = bitcast %Word32 %6 to %Nat32
	%8 = load %Nat32, %Nat32* %3
	%9 = add %Nat32 %8, %7
	%10 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%12 = load %Nat32, %Nat32* %11
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %12, %Str8* bitcast ([17 x i8]* @str35 to [0 x i8]*), %Nat8 %10, %Int32 %2)
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%14 = zext %Nat8 %10 to %Nat32
	%15 = getelementptr [32 x %Word32], [32 x %Word32]* %13, %Int32 0, %Nat32 %14
	%16 = bitcast %Nat32 %9 to %Word32
	store %Word32 %16, %Word32* %15
	ret void
}

define internal %Nat32 @execJAL(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%2 = call %Word32 @decode_extract_jal_imm(%Word32 %instr)
	%3 = call %Int32 @decode_expand20(%Word32 %2)
	%4 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%5 = load %Nat32, %Nat32* %4
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %5, %Str8* bitcast ([13 x i8]* @str36 to [0 x i8]*), %Nat8 %1, %Int32 %3)
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%7 = zext %Nat8 %1 to %Nat32
	%8 = getelementptr [32 x %Word32], [32 x %Word32]* %6, %Int32 0, %Nat32 %7
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	%11 = add %Nat32 %10, 4
	%12 = bitcast %Nat32 %11 to %Word32
	store %Word32 %12, %Word32* %8
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%14 = load %Nat32, %Nat32* %13
	%15 = bitcast %Nat32 %14 to %Int32
	%16 = add %Int32 %15, %3
	%17 = bitcast %Int32 %16 to %Nat32
	ret %Nat32 %17
}

define internal %Nat32 @execJALR(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%6 = load %Nat32, %Nat32* %5
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %6, %Str8* bitcast ([14 x i8]* @str37 to [0 x i8]*), %Int32 %4, %Nat8 %1)
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%8 = load %Nat32, %Nat32* %7
	%9 = add %Nat32 %8, 4
	%10 = bitcast %Nat32 %9 to %Int32
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%12 = zext %Nat8 %1 to %Nat32
	%13 = getelementptr [32 x %Word32], [32 x %Word32]* %11, %Int32 0, %Nat32 %12
	%14 = load %Word32, %Word32* %13
	%15 = bitcast %Word32 %14 to %Int32
	%16 = add %Int32 %15, %4
	%17 = bitcast %Int32 %16 to %Word32
	%18 = bitcast i32 4294967294 to %Word32
	%19 = and %Word32 %17, %18
	%20 = bitcast %Word32 %19 to %Nat32
	%21 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%22 = zext %Nat8 %2 to %Nat32
	%23 = getelementptr [32 x %Word32], [32 x %Word32]* %21, %Int32 0, %Nat32 %22
	%24 = bitcast %Int32 %10 to %Word32
	store %Word32 %24, %Word32* %23
	ret %Nat32 %20
}

define internal %Nat32 @execB(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%3 = call %Nat8 @decode_extract_rs2(%Word32 %instr)
	%4 = call %Int16 @decode_extract_b_imm(%Word32 %instr)
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %2 to %Nat32
	%7 = getelementptr [32 x %Word32], [32 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%10 = zext %Nat8 %3 to %Nat32
	%11 = getelementptr [32 x %Word32], [32 x %Word32]* %9, %Int32 0, %Nat32 %10
	%12 = load %Word32, %Word32* %11
	%13 = alloca %Nat32, align 4
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%15 = load %Nat32, %Nat32* %14
	%16 = add %Nat32 %15, 4
	store %Nat32 %16, %Nat32* %13
; if_0
	%17 = bitcast i8 0 to %Word8
	%18 = icmp eq %Word8 %1, %17
	br %Bool %18 , label %then_0, label %else_0
then_0:
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%20 = load %Nat32, %Nat32* %19
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %20, %Str8* bitcast ([18 x i8]* @str38 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_1
	%21 = icmp eq %Word32 %8, %12
	br %Bool %21 , label %then_1, label %endif_1
then_1:
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%23 = load %Nat32, %Nat32* %22
	%24 = bitcast %Nat32 %23 to %Int32
	%25 = sext %Int16 %4 to %Int32
	%26 = add %Int32 %24, %25
	%27 = bitcast %Int32 %26 to %Nat32
	store %Nat32 %27, %Nat32* %13
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
; if_2
	%28 = bitcast i8 1 to %Word8
	%29 = icmp eq %Word8 %1, %28
	br %Bool %29 , label %then_2, label %else_2
then_2:
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%31 = load %Nat32, %Nat32* %30
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %31, %Str8* bitcast ([18 x i8]* @str39 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_3
	%32 = icmp ne %Word32 %8, %12
	br %Bool %32 , label %then_3, label %endif_3
then_3:
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%34 = load %Nat32, %Nat32* %33
	%35 = bitcast %Nat32 %34 to %Int32
	%36 = sext %Int16 %4 to %Int32
	%37 = add %Int32 %35, %36
	%38 = bitcast %Int32 %37 to %Nat32
	store %Nat32 %38, %Nat32* %13
	br label %endif_3
endif_3:
	br label %endif_2
else_2:
; if_4
	%39 = bitcast i8 4 to %Word8
	%40 = icmp eq %Word8 %1, %39
	br %Bool %40 , label %then_4, label %else_4
then_4:
	%41 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%42 = load %Nat32, %Nat32* %41
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %42, %Str8* bitcast ([18 x i8]* @str40 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_5
	%43 = bitcast %Word32 %8 to %Int32
	%44 = bitcast %Word32 %12 to %Int32
	%45 = icmp slt %Int32 %43, %44
	br %Bool %45 , label %then_5, label %endif_5
then_5:
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%47 = load %Nat32, %Nat32* %46
	%48 = bitcast %Nat32 %47 to %Int32
	%49 = sext %Int16 %4 to %Int32
	%50 = add %Int32 %48, %49
	%51 = bitcast %Int32 %50 to %Nat32
	store %Nat32 %51, %Nat32* %13
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
; if_6
	%52 = bitcast i8 5 to %Word8
	%53 = icmp eq %Word8 %1, %52
	br %Bool %53 , label %then_6, label %else_6
then_6:
	%54 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%55 = load %Nat32, %Nat32* %54
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %55, %Str8* bitcast ([18 x i8]* @str41 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_7
	%56 = bitcast %Word32 %8 to %Int32
	%57 = bitcast %Word32 %12 to %Int32
	%58 = icmp sge %Int32 %56, %57
	br %Bool %58 , label %then_7, label %endif_7
then_7:
	%59 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%60 = load %Nat32, %Nat32* %59
	%61 = bitcast %Nat32 %60 to %Int32
	%62 = sext %Int16 %4 to %Int32
	%63 = add %Int32 %61, %62
	%64 = bitcast %Int32 %63 to %Nat32
	store %Nat32 %64, %Nat32* %13
	br label %endif_7
endif_7:
	br label %endif_6
else_6:
; if_8
	%65 = bitcast i8 6 to %Word8
	%66 = icmp eq %Word8 %1, %65
	br %Bool %66 , label %then_8, label %else_8
then_8:
	%67 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%68 = load %Nat32, %Nat32* %67
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %68, %Str8* bitcast ([19 x i8]* @str42 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_9
	%69 = bitcast %Word32 %8 to %Nat32
	%70 = bitcast %Word32 %12 to %Nat32
	%71 = icmp ult %Nat32 %69, %70
	br %Bool %71 , label %then_9, label %endif_9
then_9:
	%72 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%73 = load %Nat32, %Nat32* %72
	%74 = bitcast %Nat32 %73 to %Int32
	%75 = sext %Int16 %4 to %Int32
	%76 = add %Int32 %74, %75
	%77 = bitcast %Int32 %76 to %Nat32
	store %Nat32 %77, %Nat32* %13
	br label %endif_9
endif_9:
	br label %endif_8
else_8:
; if_10
	%78 = bitcast i8 7 to %Word8
	%79 = icmp eq %Word8 %1, %78
	br %Bool %79 , label %then_10, label %else_10
then_10:
	%80 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%81 = load %Nat32, %Nat32* %80
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %81, %Str8* bitcast ([19 x i8]* @str43 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_11
	%82 = bitcast %Word32 %8 to %Nat32
	%83 = bitcast %Word32 %12 to %Nat32
	%84 = icmp uge %Nat32 %82, %83
	br %Bool %84 , label %then_11, label %endif_11
then_11:
	%85 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%86 = load %Nat32, %Nat32* %85
	%87 = bitcast %Nat32 %86 to %Int32
	%88 = sext %Int16 %4 to %Int32
	%89 = add %Int32 %87, %88
	%90 = bitcast %Int32 %89 to %Nat32
	store %Nat32 %90, %Nat32* %13
	br label %endif_11
endif_11:
	br label %endif_10
else_10:
	br label %endif_10
endif_10:
	br label %endif_8
endif_8:
	br label %endif_6
endif_6:
	br label %endif_4
endif_4:
	br label %endif_2
endif_2:
	br label %endif_0
endif_0:
	%91 = load %Nat32, %Nat32* %13
	ret %Nat32 %91
}

define internal void @execL(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%3 = call %Int32 @decode_expand12(%Word32 %2)
	%4 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%5 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%6 = call %Nat8 @decode_extract_rs2(%Word32 %instr)
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%8 = zext %Nat8 %5 to %Nat32
	%9 = getelementptr [32 x %Word32], [32 x %Word32]* %7, %Int32 0, %Nat32 %8
	%10 = load %Word32, %Word32* %9
	%11 = bitcast %Word32 %10 to %Int32
	%12 = add %Int32 %11, %3
	%13 = bitcast %Int32 %12 to %Nat32
	%14 = alloca %Word32, align 4
; if_0
	%15 = bitcast i8 0 to %Word8
	%16 = icmp eq %Word8 %1, %15
	br %Bool %16 , label %then_0, label %else_0
then_0:
	%17 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%18 = load %Nat32, %Nat32* %17
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %18, %Str8* bitcast ([17 x i8]* @str44 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%20 = load %hart_BusInterface*, %hart_BusInterface** %19
	%21 = getelementptr %hart_BusInterface, %hart_BusInterface* %20, %Int32 0, %Int32 0
	%22 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %21
	%23 = call %Word32 %22(%Nat32 %13, %Nat8 1)
	store %Word32 %23, %Word32* %14
	br label %endif_0
else_0:
; if_1
	%24 = bitcast i8 1 to %Word8
	%25 = icmp eq %Word8 %1, %24
	br %Bool %25 , label %then_1, label %else_1
then_1:
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%27 = load %Nat32, %Nat32* %26
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %27, %Str8* bitcast ([17 x i8]* @str45 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%29 = load %hart_BusInterface*, %hart_BusInterface** %28
	%30 = getelementptr %hart_BusInterface, %hart_BusInterface* %29, %Int32 0, %Int32 0
	%31 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %30
	%32 = call %Word32 %31(%Nat32 %13, %Nat8 2)
	store %Word32 %32, %Word32* %14
	br label %endif_1
else_1:
; if_2
	%33 = bitcast i8 2 to %Word8
	%34 = icmp eq %Word8 %1, %33
	br %Bool %34 , label %then_2, label %else_2
then_2:
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%36 = load %Nat32, %Nat32* %35
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %36, %Str8* bitcast ([17 x i8]* @str46 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%37 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%38 = load %hart_BusInterface*, %hart_BusInterface** %37
	%39 = getelementptr %hart_BusInterface, %hart_BusInterface* %38, %Int32 0, %Int32 0
	%40 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %39
	%41 = call %Word32 %40(%Nat32 %13, %Nat8 4)
	store %Word32 %41, %Word32* %14
	br label %endif_2
else_2:
; if_3
	%42 = bitcast i8 4 to %Word8
	%43 = icmp eq %Word8 %1, %42
	br %Bool %43 , label %then_3, label %else_3
then_3:
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%45 = load %Nat32, %Nat32* %44
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %45, %Str8* bitcast ([18 x i8]* @str47 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%47 = load %hart_BusInterface*, %hart_BusInterface** %46
	%48 = getelementptr %hart_BusInterface, %hart_BusInterface* %47, %Int32 0, %Int32 0
	%49 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %48
	%50 = call %Word32 %49(%Nat32 %13, %Nat8 1)
	store %Word32 %50, %Word32* %14
	br label %endif_3
else_3:
; if_4
	%51 = bitcast i8 5 to %Word8
	%52 = icmp eq %Word8 %1, %51
	br %Bool %52 , label %then_4, label %endif_4
then_4:
	%53 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%54 = load %Nat32, %Nat32* %53
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %54, %Str8* bitcast ([18 x i8]* @str48 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%55 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%56 = load %hart_BusInterface*, %hart_BusInterface** %55
	%57 = getelementptr %hart_BusInterface, %hart_BusInterface* %56, %Int32 0, %Int32 0
	%58 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %57
	%59 = call %Word32 %58(%Nat32 %13, %Nat8 2)
	store %Word32 %59, %Word32* %14
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	%60 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%61 = zext %Nat8 %4 to %Nat32
	%62 = getelementptr [32 x %Word32], [32 x %Word32]* %60, %Int32 0, %Nat32 %61
	%63 = load %Word32, %Word32* %14
	store %Word32 %63, %Word32* %62
	ret void
}

define internal void @execS(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%4 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%5 = call %Nat8 @decode_extract_rs2(%Word32 %instr)
	%6 = zext %Nat8 %3 to %Nat32
	%7 = zext %Word8 %2 to %Nat32
	%8 = bitcast %Nat32 %7 to %Word32
	%9 = zext i8 5 to %Word32
	%10 = shl %Word32 %8, %9
	%11 = bitcast %Nat32 %6 to %Word32
	%12 = or %Word32 %10, %11
	%13 = call %Int32 @decode_expand12(%Word32 %12)
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%15 = zext %Nat8 %4 to %Nat32
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %14, %Int32 0, %Nat32 %15
	%17 = load %Word32, %Word32* %16
	%18 = bitcast %Word32 %17 to %Int32
	%19 = add %Int32 %18, %13
	%20 = bitcast %Int32 %19 to %Word32
	%21 = bitcast %Word32 %20 to %Nat32
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%23 = zext %Nat8 %5 to %Nat32
	%24 = getelementptr [32 x %Word32], [32 x %Word32]* %22, %Int32 0, %Nat32 %23
	%25 = load %Word32, %Word32* %24
; if_0
	%26 = bitcast i8 0 to %Word8
	%27 = icmp eq %Word8 %1, %26
	br %Bool %27 , label %then_0, label %else_0
then_0:
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%29 = load %Nat32, %Nat32* %28
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %29, %Str8* bitcast ([17 x i8]* @str49 to [0 x i8]*), %Nat8 %5, %Int32 %13, %Nat8 %4)
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%31 = load %hart_BusInterface*, %hart_BusInterface** %30
	%32 = getelementptr %hart_BusInterface, %hart_BusInterface* %31, %Int32 0, %Int32 1
	%33 = load void (%Nat32, %Word32, %Nat8)*, void (%Nat32, %Word32, %Nat8)** %32
	call void %33(%Nat32 %21, %Word32 %25, %Nat8 1)
	br label %endif_0
else_0:
; if_1
	%34 = bitcast i8 1 to %Word8
	%35 = icmp eq %Word8 %1, %34
	br %Bool %35 , label %then_1, label %else_1
then_1:
	%36 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%37 = load %Nat32, %Nat32* %36
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %37, %Str8* bitcast ([17 x i8]* @str50 to [0 x i8]*), %Nat8 %5, %Int32 %13, %Nat8 %4)
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%39 = load %hart_BusInterface*, %hart_BusInterface** %38
	%40 = getelementptr %hart_BusInterface, %hart_BusInterface* %39, %Int32 0, %Int32 1
	%41 = load void (%Nat32, %Word32, %Nat8)*, void (%Nat32, %Word32, %Nat8)** %40
	call void %41(%Nat32 %21, %Word32 %25, %Nat8 2)
	br label %endif_1
else_1:
; if_2
	%42 = bitcast i8 2 to %Word8
	%43 = icmp eq %Word8 %1, %42
	br %Bool %43 , label %then_2, label %endif_2
then_2:
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%45 = load %Nat32, %Nat32* %44
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %45, %Str8* bitcast ([17 x i8]* @str51 to [0 x i8]*), %Nat8 %5, %Int32 %13, %Nat8 %4)
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%47 = load %hart_BusInterface*, %hart_BusInterface** %46
	%48 = getelementptr %hart_BusInterface, %hart_BusInterface* %47, %Int32 0, %Int32 1
	%49 = load void (%Nat32, %Word32, %Nat8)*, void (%Nat32, %Word32, %Nat8)** %48
	call void %49(%Nat32 %21, %Word32 %25, %Nat8 4)
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @execSystem(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%3 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%4 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%5 = trunc %Word32 %4 to %Nat16
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([28 x i8]* @str52 to [0 x i8]*), %Word32 %instr)
; if_0
	%7 = zext i8 115 to %Word32
	%8 = icmp eq %Word32 %instr, %7
	br %Bool %8 , label %then_0, label %else_0
then_0:
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %10, %Str8* bitcast ([7 x i8]* @str53 to [0 x i8]*))
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%12 = bitcast %Nat32 3860 to %Nat32
	%13 = getelementptr [4096 x %Word32], [4096 x %Word32]* %11, %Int32 0, %Nat32 %12
	%14 = load %Word32, %Word32* %13
	%15 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str54 to [0 x i8]*), %Word32 %14)
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%17 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%18 = zext i8 8 to %Word32
	%19 = load %Word32, %Word32* %17
	%20 = or %Word32 %19, %18
	store %Word32 %20, %Word32* %16
	br label %endif_0
else_0:
; if_1
	%21 = zext i32 807403635 to %Word32
	%22 = icmp eq %Word32 %instr, %21
	br %Bool %22 , label %then_1, label %else_1
then_1:
	%23 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%24 = load %Nat32, %Nat32* %23
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %24, %Str8* bitcast ([6 x i8]* @str55 to [0 x i8]*))
	%25 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%26 = bitcast %Nat32 833 to %Nat32
	%27 = getelementptr [4096 x %Word32], [4096 x %Word32]* %25, %Int32 0, %Nat32 %26
	%28 = load %Word32, %Word32* %27
	%29 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%30 = bitcast %Nat32 834 to %Nat32
	%31 = getelementptr [4096 x %Word32], [4096 x %Word32]* %29, %Int32 0, %Nat32 %30
	%32 = load %Word32, %Word32* %31
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%34 = bitcast %Nat32 835 to %Nat32
	%35 = getelementptr [4096 x %Word32], [4096 x %Word32]* %33, %Int32 0, %Nat32 %34
	%36 = load %Word32, %Word32* %35
	%37 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%38 = bitcast %Nat32 3860 to %Nat32
	%39 = getelementptr [4096 x %Word32], [4096 x %Word32]* %37, %Int32 0, %Nat32 %38
	%40 = load %Word32, %Word32* %39
	%41 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([52 x i8]* @str56 to [0 x i8]*), %Word32 %40, %Word32 %28, %Word32 %32, %Word32 %36)
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%43 = bitcast %Word32 %28 to %Nat32
	store %Nat32 %43, %Nat32* %42
	br label %endif_1
else_1:
; if_2
	%44 = zext i32 1048691 to %Word32
	%45 = icmp eq %Word32 %instr, %44
	br %Bool %45 , label %then_2, label %else_2
then_2:
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%47 = load %Nat32, %Nat32* %46
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %47, %Str8* bitcast ([8 x i8]* @str57 to [0 x i8]*))
	%48 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Bool 1, %Bool* %48
	br label %endif_2
else_2:
; if_3
	%49 = bitcast i8 1 to %Word8
	%50 = icmp eq %Word8 %1, %49
	br %Bool %50 , label %then_3, label %else_3
then_3:
	call void @csr_rw(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_3
else_3:
; if_4
	%51 = bitcast i8 2 to %Word8
	%52 = icmp eq %Word8 %1, %51
	br %Bool %52 , label %then_4, label %else_4
then_4:
	call void @csr_rs(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_4
else_4:
; if_5
	%53 = bitcast i8 3 to %Word8
	%54 = icmp eq %Word8 %1, %53
	br %Bool %54 , label %then_5, label %else_5
then_5:
	call void @csr_rc(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_5
else_5:
; if_6
	%55 = bitcast i8 4 to %Word8
	%56 = icmp eq %Word8 %1, %55
	br %Bool %56 , label %then_6, label %else_6
then_6:
	call void @csr_rwi(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_6
else_6:
; if_7
	%57 = bitcast i8 5 to %Word8
	%58 = icmp eq %Word8 %1, %57
	br %Bool %58 , label %then_7, label %else_7
then_7:
	call void @csr_rsi(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_7
else_7:
; if_8
	%59 = bitcast i8 6 to %Word8
	%60 = icmp eq %Word8 %1, %59
	br %Bool %60 , label %then_8, label %else_8
then_8:
	call void @csr_rci(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_8
else_8:
	%61 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%62 = load %Nat32, %Nat32* %61
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %62, %Str8* bitcast ([34 x i8]* @str58 to [0 x i8]*), %Word32 %instr)
	%63 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Bool 1, %Bool* %63
	br label %endif_8
endif_8:
	br label %endif_7
endif_7:
	br label %endif_6
endif_6:
	br label %endif_5
endif_5:
	br label %endif_4
endif_4:
	br label %endif_3
endif_3:
	br label %endif_2
endif_2:
	br label %endif_1
endif_1:
	br label %endif_0
endif_0:
	ret void
}

define internal void @execFence(%hart_Hart* %hart, %Word32 %instr) {
; if_0
	%1 = zext i32 16777231 to %Word32
	%2 = icmp eq %Word32 %instr, %1
	br %Bool %2 , label %then_0, label %endif_0
then_0:
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%4 = load %Nat32, %Nat32* %3
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %4, %Str8* bitcast ([7 x i8]* @str59 to [0 x i8]*))
	br label %endif_0
endif_0:
	ret void
}

define internal void @csr_rw(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str60 to [0 x i8]*), %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1)
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rs1 to %Nat32
	%4 = getelementptr [32 x %Word32], [32 x %Word32]* %2, %Int32 0, %Nat32 %3
	%5 = load %Word32, %Word32* %4
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%7 = zext %Nat8 %rd to %Nat32
	%8 = getelementptr [32 x %Word32], [32 x %Word32]* %6, %Int32 0, %Nat32 %7
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = zext %Nat16 %csr to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	%12 = load %Word32, %Word32* %11
	store %Word32 %12, %Word32* %8
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%14 = zext %Nat16 %csr to %Nat32
	%15 = getelementptr [4096 x %Word32], [4096 x %Word32]* %13, %Int32 0, %Nat32 %14
	store %Word32 %5, %Word32* %15
	ret void
}

define internal void @csr_rs(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%2 = zext %Nat8 %rs1 to %Nat32
	%3 = getelementptr [32 x %Word32], [32 x %Word32]* %1, %Int32 0, %Nat32 %2
	%4 = load %Word32, %Word32* %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %rd to %Nat32
	%7 = getelementptr [32 x %Word32], [32 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%9 = zext %Nat16 %csr to %Nat32
	%10 = getelementptr [4096 x %Word32], [4096 x %Word32]* %8, %Int32 0, %Nat32 %9
	%11 = load %Word32, %Word32* %10
	store %Word32 %11, %Word32* %7
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%13 = zext %Nat16 %csr to %Nat32
	%14 = getelementptr [4096 x %Word32], [4096 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%16 = zext %Nat16 %csr to %Nat32
	%17 = getelementptr [4096 x %Word32], [4096 x %Word32]* %15, %Int32 0, %Nat32 %16
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%19 = zext %Nat8 %rs1 to %Nat32
	%20 = getelementptr [32 x %Word32], [32 x %Word32]* %18, %Int32 0, %Nat32 %19
	%21 = load %Word32, %Word32* %17
	%22 = load %Word32, %Word32* %20
	%23 = or %Word32 %21, %22
	store %Word32 %23, %Word32* %14
	ret void
}

define internal void @csr_rc(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%2 = zext %Nat8 %rs1 to %Nat32
	%3 = getelementptr [32 x %Word32], [32 x %Word32]* %1, %Int32 0, %Nat32 %2
	%4 = load %Word32, %Word32* %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %rd to %Nat32
	%7 = getelementptr [32 x %Word32], [32 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%9 = zext %Nat16 %csr to %Nat32
	%10 = getelementptr [4096 x %Word32], [4096 x %Word32]* %8, %Int32 0, %Nat32 %9
	%11 = load %Word32, %Word32* %10
	store %Word32 %11, %Word32* %7
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%13 = zext %Nat16 %csr to %Nat32
	%14 = getelementptr [4096 x %Word32], [4096 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%16 = zext %Nat16 %csr to %Nat32
	%17 = getelementptr [4096 x %Word32], [4096 x %Word32]* %15, %Int32 0, %Nat32 %16
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%19 = zext %Nat8 %rs1 to %Nat32
	%20 = getelementptr [32 x %Word32], [32 x %Word32]* %18, %Int32 0, %Nat32 %19
	%21 = load %Word32, %Word32* %20
	%22 = xor %Word32 %21, -1
	%23 = load %Word32, %Word32* %17
	%24 = and %Word32 %23, %22
	store %Word32 %24, %Word32* %14
	ret void
}

define internal void @csr_rwi(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rd to %Nat32
	%4 = getelementptr [32 x %Word32], [32 x %Word32]* %2, %Int32 0, %Nat32 %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%6 = zext %Nat16 %csr to %Nat32
	%7 = getelementptr [4096 x %Word32], [4096 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	store %Word32 %8, %Word32* %4
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = zext %Nat16 %csr to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	store %Word32 %1, %Word32* %11
	ret void
}

define internal void @csr_rsi(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rd to %Nat32
	%4 = getelementptr [32 x %Word32], [32 x %Word32]* %2, %Int32 0, %Nat32 %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%6 = zext %Nat16 %csr to %Nat32
	%7 = getelementptr [4096 x %Word32], [4096 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	store %Word32 %8, %Word32* %4
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = zext %Nat16 %csr to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%13 = zext %Nat16 %csr to %Nat32
	%14 = getelementptr [4096 x %Word32], [4096 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = load %Word32, %Word32* %14
	%16 = or %Word32 %15, %1
	store %Word32 %16, %Word32* %11
	ret void
}

define internal void @csr_rci(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rd to %Nat32
	%4 = getelementptr [32 x %Word32], [32 x %Word32]* %2, %Int32 0, %Nat32 %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%6 = zext %Nat16 %csr to %Nat32
	%7 = getelementptr [4096 x %Word32], [4096 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	store %Word32 %8, %Word32* %4
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = zext %Nat16 %csr to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%13 = zext %Nat16 %csr to %Nat32
	%14 = getelementptr [4096 x %Word32], [4096 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = xor %Word32 %1, -1
	%16 = load %Word32, %Word32* %14
	%17 = and %Word32 %16, %15
	store %Word32 %17, %Word32* %11
	ret void
}

define internal void @trace(%Nat32 %pc, %Str8* %form, ...) {
; if_0
	%1 = xor %Bool 0, 1
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	ret void
	br label %endif_0
endif_0:
	%3 = alloca %__VA_List, align 1
	%4 = bitcast %__VA_List* %3 to i8*
	call void @llvm.va_start(i8* %4)
	%5 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str61 to [0 x i8]*), %Nat32 %pc)
	%6 = load %__VA_List, %__VA_List* %3
	%7 = call %Int @vprintf(%Str8* %form, %__VA_List %6)
	%8 = bitcast %__VA_List* %3 to i8*
	call void @llvm.va_end(i8* %8)
	%9 = alloca %Char8, align 1
	%10 = call %Int (%ConstCharStr*, ...) @scanf(%ConstCharStr* bitcast ([3 x i8]* @str62 to [0 x i8]*), %Char8* %9)
	ret void
}

define internal void @trace2(%Nat32 %pc, %Str8* %form, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([8 x i8]* @str63 to [0 x i8]*), %Nat32 %pc)
	%4 = load %__VA_List, %__VA_List* %1
	%5 = call %Int @vprintf(%Str8* %form, %__VA_List %4)
	%6 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %6)
	ret void
}

define internal void @fatal(%Str8* %form, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = load %__VA_List, %__VA_List* %1
	%4 = call %Int @vprintf(%Str8* %form, %__VA_List %3)
	%5 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %5)
	call void @exit(%Int -1)
	ret void
}

define internal void @notImplemented(%Str8* %form, ...) {
	%1 = alloca %__VA_List, align 1
	%2 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_start(i8* %2)
	%3 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([33 x i8]* @str64 to [0 x i8]*))
	%4 = load %__VA_List, %__VA_List* %1
	%5 = call %Int @vprintf(%Str8* %form, %__VA_List %4)
	%6 = bitcast %__VA_List* %1 to i8*
	call void @llvm.va_end(i8* %6)
	%7 = call %Int @puts(%ConstCharStr* bitcast ([3 x i8]* @str65 to [0 x i8]*))
	call void @exit(%Int -1)
	ret void
}

define void @hart_show_regs(%hart_Hart* %hart) {
	%1 = alloca %Nat16, align 2
	store %Nat16 0, %Nat16* %1
; while_1
	br label %again_1
again_1:
	%2 = load %Nat16, %Nat16* %1
	%3 = icmp ult %Nat16 %2, 16
	br %Bool %3 , label %body_1, label %break_1
body_1:
	%4 = load %Nat16, %Nat16* %1
	%5 = load %Nat16, %Nat16* %1
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%7 = zext %Nat16 %5 to %Nat32
	%8 = getelementptr [32 x %Word32], [32 x %Word32]* %6, %Int32 0, %Nat32 %7
	%9 = load %Word32, %Word32* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str66 to [0 x i8]*), %Nat16 %4, %Word32 %9)
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str67 to [0 x i8]*))
	%12 = load %Nat16, %Nat16* %1
	%13 = add %Nat16 %12, 16
	%14 = load %Nat16, %Nat16* %1
	%15 = add %Nat16 %14, 16
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%17 = zext %Nat16 %15 to %Nat32
	%18 = getelementptr [32 x %Word32], [32 x %Word32]* %16, %Int32 0, %Nat32 %17
	%19 = load %Word32, %Word32* %18
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str68 to [0 x i8]*), %Nat16 %13, %Word32 %19)
	%21 = load %Nat16, %Nat16* %1
	%22 = add %Nat16 %21, 1
	store %Nat16 %22, %Nat16* %1
	br label %again_1
break_1:
	ret void
}


