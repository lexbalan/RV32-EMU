
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
; -- print imports 'hart' --
; -- 1

; from import "csr"

; end from import "csr"
; -- end print imports 'hart' --
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
@str52 = private constant [34 x i8] [i8 83, i8 89, i8 83, i8 84, i8 69, i8 77, i8 32, i8 73, i8 78, i8 83, i8 84, i8 82, i8 85, i8 67, i8 84, i8 73, i8 79, i8 78, i8 58, i8 32, i8 105, i8 110, i8 115, i8 116, i8 114, i8 61, i8 48, i8 120, i8 37, i8 48, i8 56, i8 88, i8 10, i8 0]
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
; -- endstrings --;
; * RV32IM simple software implementation
; 
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
; load; immediate; store; reg; branch; load upper immediate; add upper immediate to PC; jump and link; jump and link by register; system; fence; machine return from trap

; funct3 for CSR
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
	store %Word32 0, %Word32* %15
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Bool 0, %Bool* %16
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
	;let vect_offset = Nat32 hart.irq * 4
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

	; count mcycle
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
; if_0
	%6 = icmp eq %Word8 %1, 19
	br %Bool %6 , label %then_0, label %else_0
then_0:
	call void @execI(%hart_Hart* %hart, %Word32 %instr)
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%9 = load %Nat32, %Nat32* %8
	%10 = add %Nat32 %9, 4
	store %Nat32 %10, %Nat32* %7
	br label %endif_0
else_0:
; if_1
	%11 = icmp eq %Word8 %1, 51
	br %Bool %11 , label %then_1, label %else_1
then_1:
	call void @execR(%hart_Hart* %hart, %Word32 %instr)
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%14 = load %Nat32, %Nat32* %13
	%15 = add %Nat32 %14, 4
	store %Nat32 %15, %Nat32* %12
	br label %endif_1
else_1:
; if_2
	%16 = icmp eq %Word8 %1, 55
	br %Bool %16 , label %then_2, label %else_2
then_2:
	call void @execLUI(%hart_Hart* %hart, %Word32 %instr)
	%17 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%19 = load %Nat32, %Nat32* %18
	%20 = add %Nat32 %19, 4
	store %Nat32 %20, %Nat32* %17
	br label %endif_2
else_2:
; if_3
	%21 = icmp eq %Word8 %1, 23
	br %Bool %21 , label %then_3, label %else_3
then_3:
	call void @execAUIPC(%hart_Hart* %hart, %Word32 %instr)
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%23 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%24 = load %Nat32, %Nat32* %23
	%25 = add %Nat32 %24, 4
	store %Nat32 %25, %Nat32* %22
	br label %endif_3
else_3:
; if_4
	%26 = icmp eq %Word8 %1, 111
	br %Bool %26 , label %then_4, label %else_4
then_4:
	call void @execJAL(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_4
else_4:
; if_5
	%27 = icmp eq %Word8 %1, 103
	%28 = bitcast i8 0 to %Word8
	%29 = icmp eq %Word8 %2, %28
	%30 = and %Bool %27, %29
	br %Bool %30 , label %then_5, label %else_5
then_5:
	call void @execJALR(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_5
else_5:
; if_6
	%31 = icmp eq %Word8 %1, 99
	br %Bool %31 , label %then_6, label %else_6
then_6:
	call void @execB(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_6
else_6:
; if_7
	%32 = icmp eq %Word8 %1, 3
	br %Bool %32 , label %then_7, label %else_7
then_7:
	call void @execL(%hart_Hart* %hart, %Word32 %instr)
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%34 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%35 = load %Nat32, %Nat32* %34
	%36 = add %Nat32 %35, 4
	store %Nat32 %36, %Nat32* %33
	br label %endif_7
else_7:
; if_8
	%37 = icmp eq %Word8 %1, 35
	br %Bool %37 , label %then_8, label %else_8
then_8:
	call void @execS(%hart_Hart* %hart, %Word32 %instr)
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%39 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%40 = load %Nat32, %Nat32* %39
	%41 = add %Nat32 %40, 4
	store %Nat32 %41, %Nat32* %38
	br label %endif_8
else_8:
; if_9
	%42 = icmp eq %Word8 %1, 115
	br %Bool %42 , label %then_9, label %else_9
then_9:
	call void @execSystem(%hart_Hart* %hart, %Word32 %instr)
	%43 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%45 = load %Nat32, %Nat32* %44
	%46 = add %Nat32 %45, 4
	store %Nat32 %46, %Nat32* %43
	br label %endif_9
else_9:
; if_10
	%47 = icmp eq %Word8 %1, 15
	br %Bool %47 , label %then_10, label %else_10
then_10:
	call void @execFence(%hart_Hart* %hart, %Word32 %instr)
	%48 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%49 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%50 = load %Nat32, %Nat32* %49
	%51 = add %Nat32 %50, 4
	store %Nat32 %51, %Nat32* %48
	br label %endif_10
else_10:
	%52 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%53 = load %Nat32, %Nat32* %52
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %53, %Str8* bitcast ([22 x i8]* @str4 to [0 x i8]*), %Word8 %1)
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
	ret void
}



; Immediate instructions
define internal void @execI(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
; if_0
	%7 = bitcast i8 0 to %Word8
	%8 = icmp eq %Word8 %1, %7
	br %Bool %8 , label %then_0, label %else_0
then_0:
; Add immediate 
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %10, %Str8* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%12 = zext %Nat8 %5 to %Nat32
	%13 = getelementptr [32 x %Word32], [32 x %Word32]* %11, %Int32 0, %Nat32 %12
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%15 = zext %Nat8 %6 to %Nat32
	%16 = getelementptr [32 x %Word32], [32 x %Word32]* %14, %Int32 0, %Nat32 %15
	%17 = load %Word32, %Word32* %16
	%18 = bitcast %Word32 %17 to %Int32
	%19 = add %Int32 %18, %4
	%20 = bitcast %Int32 %19 to %Word32
	store %Word32 %20, %Word32* %13
	br label %endif_0
else_0:
; if_1
	%21 = bitcast i8 1 to %Word8
	%22 = icmp eq %Word8 %1, %21
	%23 = bitcast i8 0 to %Word8
	%24 = icmp eq %Word8 %2, %23
	%25 = and %Bool %22, %24
	br %Bool %25 , label %then_1, label %else_1
then_1:
; SLLI is a logical left shift (zeros are shifted
;		into the lower bits); SRLI is a logical right shift (zeros are shifted into the upper bits); and SRAI
;		is an arithmetic right shift (the original sign bit is copied into the vacated upper bits). 
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%27 = load %Nat32, %Nat32* %26
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %27, %Str8* bitcast ([19 x i8]* @str6 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%29 = zext %Nat8 %5 to %Nat32
	%30 = getelementptr [32 x %Word32], [32 x %Word32]* %28, %Int32 0, %Nat32 %29
	%31 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%32 = zext %Nat8 %6 to %Nat32
	%33 = getelementptr [32 x %Word32], [32 x %Word32]* %31, %Int32 0, %Nat32 %32
	%34 = load %Word32, %Word32* %33
	%35 = trunc %Int32 %4 to %Nat8
	%36 = zext %Nat8 %35 to %Word32
	%37 = shl %Word32 %34, %36
	store %Word32 %37, %Word32* %30
	br label %endif_1
else_1:
; if_2
	%38 = bitcast i8 2 to %Word8
	%39 = icmp eq %Word8 %1, %38
	br %Bool %39 , label %then_2, label %else_2
then_2:
; SLTI - set [1 to rd if rs1] less than immediate 
	%40 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%41 = load %Nat32, %Nat32* %40
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %41, %Str8* bitcast ([19 x i8]* @str7 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%43 = zext %Nat8 %5 to %Nat32
	%44 = getelementptr [32 x %Word32], [32 x %Word32]* %42, %Int32 0, %Nat32 %43
	%45 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%46 = zext %Nat8 %6 to %Nat32
	%47 = getelementptr [32 x %Word32], [32 x %Word32]* %45, %Int32 0, %Nat32 %46
	%48 = load %Word32, %Word32* %47
	%49 = bitcast %Word32 %48 to %Int32
	%50 = icmp slt %Int32 %49, %4
	%51 = zext %Bool %50 to %Word32
	store %Word32 %51, %Word32* %44
	br label %endif_2
else_2:
; if_3
	%52 = bitcast i8 3 to %Word8
	%53 = icmp eq %Word8 %1, %52
	br %Bool %53 , label %then_3, label %else_3
then_3:
	%54 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%55 = load %Nat32, %Nat32* %54
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %55, %Str8* bitcast ([20 x i8]* @str8 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%56 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%57 = zext %Nat8 %5 to %Nat32
	%58 = getelementptr [32 x %Word32], [32 x %Word32]* %56, %Int32 0, %Nat32 %57
	%59 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%60 = zext %Nat8 %6 to %Nat32
	%61 = getelementptr [32 x %Word32], [32 x %Word32]* %59, %Int32 0, %Nat32 %60
	%62 = load %Word32, %Word32* %61
	%63 = bitcast %Word32 %62 to %Nat32
	%64 = bitcast %Int32 %4 to %Nat32
	%65 = icmp ult %Nat32 %63, %64
	%66 = zext %Bool %65 to %Word32
	store %Word32 %66, %Word32* %58
	br label %endif_3
else_3:
; if_4
	%67 = bitcast i8 4 to %Word8
	%68 = icmp eq %Word8 %1, %67
	br %Bool %68 , label %then_4, label %else_4
then_4:
	%69 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%70 = load %Nat32, %Nat32* %69
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %70, %Str8* bitcast ([19 x i8]* @str9 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%71 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%72 = zext %Nat8 %5 to %Nat32
	%73 = getelementptr [32 x %Word32], [32 x %Word32]* %71, %Int32 0, %Nat32 %72
	%74 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%75 = zext %Nat8 %6 to %Nat32
	%76 = getelementptr [32 x %Word32], [32 x %Word32]* %74, %Int32 0, %Nat32 %75
	%77 = bitcast %Int32 %4 to %Word32
	%78 = load %Word32, %Word32* %76
	%79 = xor %Word32 %78, %77
	store %Word32 %79, %Word32* %73
	br label %endif_4
else_4:
; if_5
	%80 = bitcast i8 5 to %Word8
	%81 = icmp eq %Word8 %1, %80
	%82 = bitcast i8 0 to %Word8
	%83 = icmp eq %Word8 %2, %82
	%84 = and %Bool %81, %83
	br %Bool %84 , label %then_5, label %else_5
then_5:
	%85 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%86 = load %Nat32, %Nat32* %85
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %86, %Str8* bitcast ([19 x i8]* @str10 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%87 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%88 = zext %Nat8 %5 to %Nat32
	%89 = getelementptr [32 x %Word32], [32 x %Word32]* %87, %Int32 0, %Nat32 %88
	%90 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%91 = zext %Nat8 %6 to %Nat32
	%92 = getelementptr [32 x %Word32], [32 x %Word32]* %90, %Int32 0, %Nat32 %91
	%93 = load %Word32, %Word32* %92
	%94 = trunc %Int32 %4 to %Nat8
	%95 = zext %Nat8 %94 to %Word32
	%96 = lshr %Word32 %93, %95
	store %Word32 %96, %Word32* %89
	br label %endif_5
else_5:
; if_6
	%97 = bitcast i8 5 to %Word8
	%98 = icmp eq %Word8 %1, %97
	%99 = icmp eq %Word8 %2, 32
	%100 = and %Bool %98, %99
	br %Bool %100 , label %then_6, label %else_6
then_6:
	%101 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%102 = load %Nat32, %Nat32* %101
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %102, %Str8* bitcast ([19 x i8]* @str11 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%103 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%104 = zext %Nat8 %5 to %Nat32
	%105 = getelementptr [32 x %Word32], [32 x %Word32]* %103, %Int32 0, %Nat32 %104
	%106 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%107 = zext %Nat8 %6 to %Nat32
	%108 = getelementptr [32 x %Word32], [32 x %Word32]* %106, %Int32 0, %Nat32 %107
	%109 = load %Word32, %Word32* %108
	%110 = trunc %Int32 %4 to %Nat8
	%111 = zext %Nat8 %110 to %Word32
	%112 = lshr %Word32 %109, %111
	store %Word32 %112, %Word32* %105
	br label %endif_6
else_6:
; if_7
	%113 = bitcast i8 6 to %Word8
	%114 = icmp eq %Word8 %1, %113
	br %Bool %114 , label %then_7, label %else_7
then_7:
	%115 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%116 = load %Nat32, %Nat32* %115
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %116, %Str8* bitcast ([18 x i8]* @str12 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%117 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%118 = zext %Nat8 %5 to %Nat32
	%119 = getelementptr [32 x %Word32], [32 x %Word32]* %117, %Int32 0, %Nat32 %118
	%120 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%121 = zext %Nat8 %6 to %Nat32
	%122 = getelementptr [32 x %Word32], [32 x %Word32]* %120, %Int32 0, %Nat32 %121
	%123 = bitcast %Int32 %4 to %Word32
	%124 = load %Word32, %Word32* %122
	%125 = or %Word32 %124, %123
	store %Word32 %125, %Word32* %119
	br label %endif_7
else_7:
; if_8
	%126 = bitcast i8 7 to %Word8
	%127 = icmp eq %Word8 %1, %126
	br %Bool %127 , label %then_8, label %endif_8
then_8:
	%128 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%129 = load %Nat32, %Nat32* %128
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %129, %Str8* bitcast ([19 x i8]* @str13 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)

	;
	%130 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%131 = zext %Nat8 %5 to %Nat32
	%132 = getelementptr [32 x %Word32], [32 x %Word32]* %130, %Int32 0, %Nat32 %131
	%133 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%134 = zext %Nat8 %6 to %Nat32
	%135 = getelementptr [32 x %Word32], [32 x %Word32]* %133, %Int32 0, %Nat32 %134
	%136 = bitcast %Int32 %4 to %Word32
	%137 = load %Word32, %Word32* %135
	%138 = and %Word32 %137, %136
	store %Word32 %138, %Word32* %132
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



; Register to register
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
; if_0
	%14 = bitcast i8 1 to %Word8
	%15 = icmp eq %Word8 %2, %14
	br %Bool %15 , label %then_0, label %endif_0
then_0:

	;
	; "M" extension
	;
; if_1
	%16 = bitcast i8 0 to %Word8
	%17 = icmp eq %Word8 %1, %16
	br %Bool %17 , label %then_1, label %else_1
then_1:
	; MUL rd, rs1, rs2
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%19 = load %Nat32, %Nat32* %18
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %19, %Str8* bitcast ([19 x i8]* @str14 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%20 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%21 = zext %Nat8 %3 to %Nat32
	%22 = getelementptr [32 x %Word32], [32 x %Word32]* %20, %Int32 0, %Nat32 %21
	%23 = bitcast %Word32 %9 to %Int32
	%24 = bitcast %Word32 %13 to %Int32
	%25 = mul %Int32 %23, %24
	%26 = bitcast %Int32 %25 to %Word32
	store %Word32 %26, %Word32* %22
	br label %endif_1
else_1:
; if_2
	%27 = bitcast i8 1 to %Word8
	%28 = icmp eq %Word8 %1, %27
	br %Bool %28 , label %then_2, label %else_2
then_2:
	; MULH rd, rs1, rs2
	; Записывает в целевой регистр старшие биты
	; которые бы не поместились в него при обычном умножении
	%29 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%30 = load %Nat32, %Nat32* %29
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %30, %Str8* bitcast ([20 x i8]* @str15 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%31 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%32 = zext %Nat8 %3 to %Nat32
	%33 = getelementptr [32 x %Word32], [32 x %Word32]* %31, %Int32 0, %Nat32 %32
	%34 = sext %Word32 %9 to %Int64
	%35 = sext %Word32 %13 to %Int64
	%36 = mul %Int64 %34, %35
	%37 = bitcast %Int64 %36 to %Word64
	%38 = zext i8 32 to %Word64
	%39 = lshr %Word64 %37, %38
	%40 = trunc %Word64 %39 to %Word32
	store %Word32 %40, %Word32* %33
	br label %endif_2
else_2:
; if_3
	%41 = bitcast i8 2 to %Word8
	%42 = icmp eq %Word8 %1, %41
	br %Bool %42 , label %then_3, label %else_3
then_3:
	; MULHSU rd, rs1, rs2
	; mul high signed unsigned
	%43 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%44 = load %Nat32, %Nat32* %43
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %44, %Str8* bitcast ([22 x i8]* @str16 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	; NOT IMPLEMENTED!
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str17 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	;hart.regs[rd] = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)
	br label %endif_3
else_3:
; if_4
	%45 = bitcast i8 3 to %Word8
	%46 = icmp eq %Word8 %1, %45
	br %Bool %46 , label %then_4, label %else_4
then_4:
	; MULHU rd, rs1, rs2
	%47 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%48 = load %Nat32, %Nat32* %47
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %48, %Str8* bitcast ([21 x i8]* @str18 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	; multiply unsigned high
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str19 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	;hart.regs[rd] = unsafe Word32 (Word64 (Nat64 v0 * Nat64 v1) >> 32)
	br label %endif_4
else_4:
; if_5
	%49 = bitcast i8 4 to %Word8
	%50 = icmp eq %Word8 %1, %49
	br %Bool %50 , label %then_5, label %else_5
then_5:
	; DIV rd, rs1, rs2
	%51 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%52 = load %Nat32, %Nat32* %51
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %52, %Str8* bitcast ([19 x i8]* @str20 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%53 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%54 = zext %Nat8 %3 to %Nat32
	%55 = getelementptr [32 x %Word32], [32 x %Word32]* %53, %Int32 0, %Nat32 %54
	%56 = bitcast %Word32 %9 to %Int32
	%57 = bitcast %Word32 %13 to %Int32
	%58 = sdiv %Int32 %56, %57
	%59 = bitcast %Int32 %58 to %Word32
	store %Word32 %59, %Word32* %55
	br label %endif_5
else_5:
; if_6
	%60 = bitcast i8 5 to %Word8
	%61 = icmp eq %Word8 %1, %60
	br %Bool %61 , label %then_6, label %else_6
then_6:
	; DIVU rd, rs1, rs2
	%62 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%63 = load %Nat32, %Nat32* %62
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %63, %Str8* bitcast ([20 x i8]* @str21 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%64 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%65 = zext %Nat8 %3 to %Nat32
	%66 = getelementptr [32 x %Word32], [32 x %Word32]* %64, %Int32 0, %Nat32 %65
	%67 = bitcast %Word32 %9 to %Nat32
	%68 = bitcast %Word32 %13 to %Nat32
	%69 = udiv %Nat32 %67, %68
	%70 = bitcast %Nat32 %69 to %Word32
	store %Word32 %70, %Word32* %66
	br label %endif_6
else_6:
; if_7
	%71 = bitcast i8 6 to %Word8
	%72 = icmp eq %Word8 %1, %71
	br %Bool %72 , label %then_7, label %else_7
then_7:
	; REM rd, rs1, rs2
	%73 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%74 = load %Nat32, %Nat32* %73
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %74, %Str8* bitcast ([19 x i8]* @str22 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%75 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%76 = zext %Nat8 %3 to %Nat32
	%77 = getelementptr [32 x %Word32], [32 x %Word32]* %75, %Int32 0, %Nat32 %76
	%78 = bitcast %Word32 %9 to %Int32
	%79 = bitcast %Word32 %13 to %Int32
	%80 = srem %Int32 %78, %79
	%81 = bitcast %Int32 %80 to %Word32
	store %Word32 %81, %Word32* %77
	br label %endif_7
else_7:
; if_8
	%82 = bitcast i8 7 to %Word8
	%83 = icmp eq %Word8 %1, %82
	br %Bool %83 , label %then_8, label %endif_8
then_8:
	; REMU rd, rs1, rs2
	%84 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%85 = load %Nat32, %Nat32* %84
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %85, %Str8* bitcast ([20 x i8]* @str23 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%86 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%87 = zext %Nat8 %3 to %Nat32
	%88 = getelementptr [32 x %Word32], [32 x %Word32]* %86, %Int32 0, %Nat32 %87
	%89 = bitcast %Word32 %9 to %Nat32
	%90 = bitcast %Word32 %13 to %Nat32
	%91 = urem %Nat32 %89, %90
	%92 = bitcast %Nat32 %91 to %Word32
	store %Word32 %92, %Word32* %88
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
	ret void
	br label %endif_0
endif_0:
; if_9
	%94 = bitcast i8 0 to %Word8
	%95 = icmp eq %Word8 %1, %94
	%96 = icmp eq %Word8 %2, 0
	%97 = and %Bool %95, %96
	br %Bool %97 , label %then_9, label %else_9
then_9:
	%98 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%99 = load %Nat32, %Nat32* %98
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %99, %Str8* bitcast ([19 x i8]* @str24 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%100 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%101 = zext %Nat8 %3 to %Nat32
	%102 = getelementptr [32 x %Word32], [32 x %Word32]* %100, %Int32 0, %Nat32 %101
	%103 = bitcast %Word32 %9 to %Int32
	%104 = bitcast %Word32 %13 to %Int32
	%105 = add %Int32 %103, %104
	%106 = bitcast %Int32 %105 to %Word32
	store %Word32 %106, %Word32* %102
	br label %endif_9
else_9:
; if_10
	%107 = bitcast i8 0 to %Word8
	%108 = icmp eq %Word8 %1, %107
	%109 = icmp eq %Word8 %2, 32
	%110 = and %Bool %108, %109
	br %Bool %110 , label %then_10, label %else_10
then_10:
	%111 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%112 = load %Nat32, %Nat32* %111
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %112, %Str8* bitcast ([19 x i8]* @str25 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%113 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%114 = zext %Nat8 %3 to %Nat32
	%115 = getelementptr [32 x %Word32], [32 x %Word32]* %113, %Int32 0, %Nat32 %114
	%116 = bitcast %Word32 %9 to %Int32
	%117 = bitcast %Word32 %13 to %Int32
	%118 = sub %Int32 %116, %117
	%119 = bitcast %Int32 %118 to %Word32
	store %Word32 %119, %Word32* %115
	br label %endif_10
else_10:
; if_11
	%120 = bitcast i8 1 to %Word8
	%121 = icmp eq %Word8 %1, %120
	br %Bool %121 , label %then_11, label %else_11
then_11:
	; shift left logical
	%122 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%123 = load %Nat32, %Nat32* %122
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %123, %Str8* bitcast ([19 x i8]* @str26 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	;printf("?%x\n", v0)
	%124 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%125 = zext %Nat8 %3 to %Nat32
	%126 = getelementptr [32 x %Word32], [32 x %Word32]* %124, %Int32 0, %Nat32 %125
	%127 = trunc %Word32 %13 to %Nat8
	%128 = zext %Nat8 %127 to %Word32
	%129 = shl %Word32 %9, %128
	store %Word32 %129, %Word32* %126
	br label %endif_11
else_11:
; if_12
	%130 = bitcast i8 2 to %Word8
	%131 = icmp eq %Word8 %1, %130
	br %Bool %131 , label %then_12, label %else_12
then_12:
	; set less than
	%132 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%133 = load %Nat32, %Nat32* %132
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %133, %Str8* bitcast ([19 x i8]* @str27 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%134 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%135 = zext %Nat8 %3 to %Nat32
	%136 = getelementptr [32 x %Word32], [32 x %Word32]* %134, %Int32 0, %Nat32 %135
	%137 = bitcast %Word32 %9 to %Int32
	%138 = bitcast %Word32 %13 to %Int32
	%139 = icmp slt %Int32 %137, %138
	%140 = zext %Bool %139 to %Word32
	store %Word32 %140, %Word32* %136
	br label %endif_12
else_12:
; if_13
	%141 = bitcast i8 3 to %Word8
	%142 = icmp eq %Word8 %1, %141
	br %Bool %142 , label %then_13, label %else_13
then_13:
	; set less than unsigned
	%143 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%144 = load %Nat32, %Nat32* %143
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %144, %Str8* bitcast ([20 x i8]* @str28 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%145 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%146 = zext %Nat8 %3 to %Nat32
	%147 = getelementptr [32 x %Word32], [32 x %Word32]* %145, %Int32 0, %Nat32 %146
	%148 = bitcast %Word32 %9 to %Nat32
	%149 = bitcast %Word32 %13 to %Nat32
	%150 = icmp ult %Nat32 %148, %149
	%151 = zext %Bool %150 to %Word32
	store %Word32 %151, %Word32* %147
	br label %endif_13
else_13:
; if_14
	%152 = bitcast i8 4 to %Word8
	%153 = icmp eq %Word8 %1, %152
	br %Bool %153 , label %then_14, label %else_14
then_14:
	%154 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%155 = load %Nat32, %Nat32* %154
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %155, %Str8* bitcast ([19 x i8]* @str29 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%156 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%157 = zext %Nat8 %3 to %Nat32
	%158 = getelementptr [32 x %Word32], [32 x %Word32]* %156, %Int32 0, %Nat32 %157
	%159 = xor %Word32 %9, %13
	store %Word32 %159, %Word32* %158
	br label %endif_14
else_14:
; if_15
	%160 = bitcast i8 5 to %Word8
	%161 = icmp eq %Word8 %1, %160
	%162 = bitcast i8 0 to %Word8
	%163 = icmp eq %Word8 %2, %162
	%164 = and %Bool %161, %163
	br %Bool %164 , label %then_15, label %else_15
then_15:
	; shift right logical
	%165 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%166 = load %Nat32, %Nat32* %165
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %166, %Str8* bitcast ([19 x i8]* @str30 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%167 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%168 = zext %Nat8 %3 to %Nat32
	%169 = getelementptr [32 x %Word32], [32 x %Word32]* %167, %Int32 0, %Nat32 %168
	%170 = trunc %Word32 %13 to %Nat8
	%171 = zext %Nat8 %170 to %Word32
	%172 = lshr %Word32 %9, %171
	store %Word32 %172, %Word32* %169
	br label %endif_15
else_15:
; if_16
	%173 = bitcast i8 5 to %Word8
	%174 = icmp eq %Word8 %1, %173
	%175 = icmp eq %Word8 %2, 32
	%176 = and %Bool %174, %175
	br %Bool %176 , label %then_16, label %else_16
then_16:
	; shift right arithmetical
	%177 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%178 = load %Nat32, %Nat32* %177
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %178, %Str8* bitcast ([19 x i8]* @str31 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	; ERROR: не реализован арифм сдвиг!
	;hart.regs[rd] = v0 >> Int32 v1
	br label %endif_16
else_16:
; if_17
	%179 = bitcast i8 6 to %Word8
	%180 = icmp eq %Word8 %1, %179
	br %Bool %180 , label %then_17, label %else_17
then_17:
	%181 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%182 = load %Nat32, %Nat32* %181
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %182, %Str8* bitcast ([18 x i8]* @str32 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%183 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%184 = zext %Nat8 %3 to %Nat32
	%185 = getelementptr [32 x %Word32], [32 x %Word32]* %183, %Int32 0, %Nat32 %184
	%186 = or %Word32 %9, %13
	store %Word32 %186, %Word32* %185
	;printf("=%08x (%08x, %08x)\n", hart.regs[rd], v0, v1)
	br label %endif_17
else_17:
; if_18
	%187 = bitcast i8 7 to %Word8
	%188 = icmp eq %Word8 %1, %187
	br %Bool %188 , label %then_18, label %endif_18
then_18:
	%189 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%190 = load %Nat32, %Nat32* %189
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %190, %Str8* bitcast ([19 x i8]* @str33 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	;
	%191 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%192 = zext %Nat8 %3 to %Nat32
	%193 = getelementptr [32 x %Word32], [32 x %Word32]* %191, %Int32 0, %Nat32 %192
	%194 = and %Word32 %9, %13
	store %Word32 %194, %Word32* %193
	;printf("=%08x (%08x, %08x)\n", hart.regs[rd], v0, v1)
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
	ret void
}



; Load upper immediate
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



; Add upper immediate to PC
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



; Jump and link
define internal void @execJAL(%hart_Hart* %hart, %Word32 %instr) {
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
	%14 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%15 = load %Nat32, %Nat32* %14
	%16 = bitcast %Nat32 %15 to %Int32
	%17 = add %Int32 %16, %3
	%18 = bitcast %Int32 %17 to %Nat32
	store %Nat32 %18, %Nat32* %13
	ret void
}



; Jump and link (by register)
define internal void @execJALR(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%6 = load %Nat32, %Nat32* %5
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %6, %Str8* bitcast ([14 x i8]* @str37 to [0 x i8]*), %Int32 %4, %Nat8 %1)

	; rd <- pc + 4
	; pc <- (rs1 + imm) & ~1
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
	%18 = and %Word32 %17, 4294967294
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%20 = zext %Nat8 %2 to %Nat32
	%21 = getelementptr [32 x %Word32], [32 x %Word32]* %19, %Int32 0, %Nat32 %20
	%22 = bitcast %Int32 %10 to %Word32
	store %Word32 %22, %Word32* %21
	%23 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%24 = bitcast %Word32 %18 to %Nat32
	store %Nat32 %24, %Nat32* %23
	ret void
}



; Branch instructions
define internal void @execB(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%3 = call %Nat8 @decode_extract_rs2(%Word32 %instr)
	%4 = call %Int16 @decode_extract_b_imm(%Word32 %instr)
	%5 = alloca %Nat32, align 4
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%7 = load %Nat32, %Nat32* %6
	%8 = add %Nat32 %7, 4
	store %Nat32 %8, %Nat32* %5
; if_0
	%9 = bitcast i8 0 to %Word8
	%10 = icmp eq %Word8 %1, %9
	br %Bool %10 , label %then_0, label %else_0
then_0:
	; BEQ - Branch if equal
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%12 = load %Nat32, %Nat32* %11
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %12, %Str8* bitcast ([18 x i8]* @str38 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)

	; Branch if two registers are equal
; if_1
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%14 = zext %Nat8 %2 to %Nat32
	%15 = getelementptr [32 x %Word32], [32 x %Word32]* %13, %Int32 0, %Nat32 %14
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%17 = zext %Nat8 %3 to %Nat32
	%18 = getelementptr [32 x %Word32], [32 x %Word32]* %16, %Int32 0, %Nat32 %17
	%19 = load %Word32, %Word32* %15
	%20 = load %Word32, %Word32* %18
	%21 = icmp eq %Word32 %19, %20
	br %Bool %21 , label %then_1, label %endif_1
then_1:
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%23 = load %Nat32, %Nat32* %22
	%24 = bitcast %Nat32 %23 to %Int32
	%25 = sext %Int16 %4 to %Int32
	%26 = add %Int32 %24, %25
	%27 = bitcast %Int32 %26 to %Nat32
	store %Nat32 %27, %Nat32* %5
	br label %endif_1
endif_1:
	br label %endif_0
else_0:
; if_2
	%28 = bitcast i8 1 to %Word8
	%29 = icmp eq %Word8 %1, %28
	br %Bool %29 , label %then_2, label %else_2
then_2:
	; BNE - Branch if not equal
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%31 = load %Nat32, %Nat32* %30
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %31, %Str8* bitcast ([18 x i8]* @str39 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)

	;
; if_3
	%32 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%33 = zext %Nat8 %2 to %Nat32
	%34 = getelementptr [32 x %Word32], [32 x %Word32]* %32, %Int32 0, %Nat32 %33
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%36 = zext %Nat8 %3 to %Nat32
	%37 = getelementptr [32 x %Word32], [32 x %Word32]* %35, %Int32 0, %Nat32 %36
	%38 = load %Word32, %Word32* %34
	%39 = load %Word32, %Word32* %37
	%40 = icmp ne %Word32 %38, %39
	br %Bool %40 , label %then_3, label %endif_3
then_3:
	%41 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%42 = load %Nat32, %Nat32* %41
	%43 = bitcast %Nat32 %42 to %Int32
	%44 = sext %Int16 %4 to %Int32
	%45 = add %Int32 %43, %44
	%46 = bitcast %Int32 %45 to %Nat32
	store %Nat32 %46, %Nat32* %5
	br label %endif_3
endif_3:
	br label %endif_2
else_2:
; if_4
	%47 = bitcast i8 4 to %Word8
	%48 = icmp eq %Word8 %1, %47
	br %Bool %48 , label %then_4, label %else_4
then_4:
	; BLT - Branch if less than (signed)
	%49 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%50 = load %Nat32, %Nat32* %49
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %50, %Str8* bitcast ([18 x i8]* @str40 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)

	;
; if_5
	%51 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%52 = zext %Nat8 %2 to %Nat32
	%53 = getelementptr [32 x %Word32], [32 x %Word32]* %51, %Int32 0, %Nat32 %52
	%54 = load %Word32, %Word32* %53
	%55 = bitcast %Word32 %54 to %Int32
	%56 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%57 = zext %Nat8 %3 to %Nat32
	%58 = getelementptr [32 x %Word32], [32 x %Word32]* %56, %Int32 0, %Nat32 %57
	%59 = load %Word32, %Word32* %58
	%60 = bitcast %Word32 %59 to %Int32
	%61 = icmp slt %Int32 %55, %60
	br %Bool %61 , label %then_5, label %endif_5
then_5:
	%62 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%63 = load %Nat32, %Nat32* %62
	%64 = bitcast %Nat32 %63 to %Int32
	%65 = sext %Int16 %4 to %Int32
	%66 = add %Int32 %64, %65
	%67 = bitcast %Int32 %66 to %Nat32
	store %Nat32 %67, %Nat32* %5
	br label %endif_5
endif_5:
	br label %endif_4
else_4:
; if_6
	%68 = bitcast i8 5 to %Word8
	%69 = icmp eq %Word8 %1, %68
	br %Bool %69 , label %then_6, label %else_6
then_6:
	; BGE - Branch if greater or equal (signed)
	%70 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%71 = load %Nat32, %Nat32* %70
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %71, %Str8* bitcast ([18 x i8]* @str41 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)

	;
; if_7
	%72 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%73 = zext %Nat8 %2 to %Nat32
	%74 = getelementptr [32 x %Word32], [32 x %Word32]* %72, %Int32 0, %Nat32 %73
	%75 = load %Word32, %Word32* %74
	%76 = bitcast %Word32 %75 to %Int32
	%77 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%78 = zext %Nat8 %3 to %Nat32
	%79 = getelementptr [32 x %Word32], [32 x %Word32]* %77, %Int32 0, %Nat32 %78
	%80 = load %Word32, %Word32* %79
	%81 = bitcast %Word32 %80 to %Int32
	%82 = icmp sge %Int32 %76, %81
	br %Bool %82 , label %then_7, label %endif_7
then_7:
	%83 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%84 = load %Nat32, %Nat32* %83
	%85 = bitcast %Nat32 %84 to %Int32
	%86 = sext %Int16 %4 to %Int32
	%87 = add %Int32 %85, %86
	%88 = bitcast %Int32 %87 to %Nat32
	store %Nat32 %88, %Nat32* %5
	br label %endif_7
endif_7:
	br label %endif_6
else_6:
; if_8
	%89 = bitcast i8 6 to %Word8
	%90 = icmp eq %Word8 %1, %89
	br %Bool %90 , label %then_8, label %else_8
then_8:
	; BLTU - Branch if less than (unsigned)
	%91 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%92 = load %Nat32, %Nat32* %91
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %92, %Str8* bitcast ([19 x i8]* @str42 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)

	;
; if_9
	%93 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%94 = zext %Nat8 %2 to %Nat32
	%95 = getelementptr [32 x %Word32], [32 x %Word32]* %93, %Int32 0, %Nat32 %94
	%96 = load %Word32, %Word32* %95
	%97 = bitcast %Word32 %96 to %Nat32
	%98 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%99 = zext %Nat8 %3 to %Nat32
	%100 = getelementptr [32 x %Word32], [32 x %Word32]* %98, %Int32 0, %Nat32 %99
	%101 = load %Word32, %Word32* %100
	%102 = bitcast %Word32 %101 to %Nat32
	%103 = icmp ult %Nat32 %97, %102
	br %Bool %103 , label %then_9, label %endif_9
then_9:
	%104 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%105 = load %Nat32, %Nat32* %104
	%106 = bitcast %Nat32 %105 to %Int32
	%107 = sext %Int16 %4 to %Int32
	%108 = add %Int32 %106, %107
	%109 = bitcast %Int32 %108 to %Nat32
	store %Nat32 %109, %Nat32* %5
	br label %endif_9
endif_9:
	br label %endif_8
else_8:
; if_10
	%110 = bitcast i8 7 to %Word8
	%111 = icmp eq %Word8 %1, %110
	br %Bool %111 , label %then_10, label %endif_10
then_10:
	; BGEU - Branch if greater or equal (unsigned)
	%112 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%113 = load %Nat32, %Nat32* %112
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %113, %Str8* bitcast ([19 x i8]* @str43 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)

	;
; if_11
	%114 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%115 = zext %Nat8 %2 to %Nat32
	%116 = getelementptr [32 x %Word32], [32 x %Word32]* %114, %Int32 0, %Nat32 %115
	%117 = load %Word32, %Word32* %116
	%118 = bitcast %Word32 %117 to %Nat32
	%119 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%120 = zext %Nat8 %3 to %Nat32
	%121 = getelementptr [32 x %Word32], [32 x %Word32]* %119, %Int32 0, %Nat32 %120
	%122 = load %Word32, %Word32* %121
	%123 = bitcast %Word32 %122 to %Nat32
	%124 = icmp uge %Nat32 %118, %123
	br %Bool %124 , label %then_11, label %endif_11
then_11:
	%125 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%126 = load %Nat32, %Nat32* %125
	%127 = bitcast %Nat32 %126 to %Int32
	%128 = sext %Int16 %4 to %Int32
	%129 = add %Int32 %127, %128
	%130 = bitcast %Int32 %129 to %Nat32
	store %Nat32 %130, %Nat32* %5
	br label %endif_11
endif_11:
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
	%131 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%132 = load %Nat32, %Nat32* %5
	store %Nat32 %132, %Nat32* %131
	ret void
}



; Load instructions
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
; if_0
	%14 = bitcast i8 0 to %Word8
	%15 = icmp eq %Word8 %1, %14
	br %Bool %15 , label %then_0, label %else_0
then_0:
	; LB (Load 8-bit signed integer value)
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%17 = load %Nat32, %Nat32* %16
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %17, %Str8* bitcast ([17 x i8]* @str44 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%19 = zext %Nat8 %4 to %Nat32
	%20 = getelementptr [32 x %Word32], [32 x %Word32]* %18, %Int32 0, %Nat32 %19
	%21 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%22 = load %hart_BusInterface*, %hart_BusInterface** %21
	%23 = getelementptr %hart_BusInterface, %hart_BusInterface* %22, %Int32 0, %Int32 0
	%24 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %23
	%25 = call %Word32 %24(%Nat32 %13, %Nat8 1)
	store %Word32 %25, %Word32* %20
	br label %endif_0
else_0:
; if_1
	%26 = bitcast i8 1 to %Word8
	%27 = icmp eq %Word8 %1, %26
	br %Bool %27 , label %then_1, label %else_1
then_1:
	; LH (Load 16-bit signed integer value)
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%29 = load %Nat32, %Nat32* %28
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %29, %Str8* bitcast ([17 x i8]* @str45 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%31 = zext %Nat8 %4 to %Nat32
	%32 = getelementptr [32 x %Word32], [32 x %Word32]* %30, %Int32 0, %Nat32 %31
	%33 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%34 = load %hart_BusInterface*, %hart_BusInterface** %33
	%35 = getelementptr %hart_BusInterface, %hart_BusInterface* %34, %Int32 0, %Int32 0
	%36 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %35
	%37 = call %Word32 %36(%Nat32 %13, %Nat8 2)
	store %Word32 %37, %Word32* %32
	br label %endif_1
else_1:
; if_2
	%38 = bitcast i8 2 to %Word8
	%39 = icmp eq %Word8 %1, %38
	br %Bool %39 , label %then_2, label %else_2
then_2:
	; LW (Load 32-bit signed integer value)
	%40 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%41 = load %Nat32, %Nat32* %40
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %41, %Str8* bitcast ([17 x i8]* @str46 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%43 = zext %Nat8 %4 to %Nat32
	%44 = getelementptr [32 x %Word32], [32 x %Word32]* %42, %Int32 0, %Nat32 %43
	%45 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%46 = load %hart_BusInterface*, %hart_BusInterface** %45
	%47 = getelementptr %hart_BusInterface, %hart_BusInterface* %46, %Int32 0, %Int32 0
	%48 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %47
	%49 = call %Word32 %48(%Nat32 %13, %Nat8 4)
	store %Word32 %49, %Word32* %44
	br label %endif_2
else_2:
; if_3
	%50 = bitcast i8 4 to %Word8
	%51 = icmp eq %Word8 %1, %50
	br %Bool %51 , label %then_3, label %else_3
then_3:
	; LBU (Load 8-bit unsigned integer value)
	%52 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%53 = load %Nat32, %Nat32* %52
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %53, %Str8* bitcast ([18 x i8]* @str47 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%54 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%55 = zext %Nat8 %4 to %Nat32
	%56 = getelementptr [32 x %Word32], [32 x %Word32]* %54, %Int32 0, %Nat32 %55
	%57 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%58 = load %hart_BusInterface*, %hart_BusInterface** %57
	%59 = getelementptr %hart_BusInterface, %hart_BusInterface* %58, %Int32 0, %Int32 0
	%60 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %59
	%61 = call %Word32 %60(%Nat32 %13, %Nat8 1)
	store %Word32 %61, %Word32* %56
	br label %endif_3
else_3:
; if_4
	%62 = bitcast i8 5 to %Word8
	%63 = icmp eq %Word8 %1, %62
	br %Bool %63 , label %then_4, label %endif_4
then_4:
	; LHU (Load 16-bit unsigned integer value)
	%64 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%65 = load %Nat32, %Nat32* %64
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %65, %Str8* bitcast ([18 x i8]* @str48 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%66 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%67 = zext %Nat8 %4 to %Nat32
	%68 = getelementptr [32 x %Word32], [32 x %Word32]* %66, %Int32 0, %Nat32 %67
	%69 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%70 = load %hart_BusInterface*, %hart_BusInterface** %69
	%71 = getelementptr %hart_BusInterface, %hart_BusInterface* %70, %Int32 0, %Int32 0
	%72 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %71
	%73 = call %Word32 %72(%Nat32 %13, %Nat8 2)
	store %Word32 %73, %Word32* %68
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



; Store instructions
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
	; SB (save 8-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%29 = load %Nat32, %Nat32* %28
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %29, %Str8* bitcast ([17 x i8]* @str49 to [0 x i8]*), %Nat8 %5, %Int32 %13, %Nat8 %4)

	;
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
	; SH (save 16-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	%36 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%37 = load %Nat32, %Nat32* %36
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %37, %Str8* bitcast ([17 x i8]* @str50 to [0 x i8]*), %Nat8 %5, %Int32 %13, %Nat8 %4)

	;
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
	; SW (save 32-bit value)
	; <source:reg>, <offset:12bit_imm>(<address:reg>)
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%45 = load %Nat32, %Nat32* %44
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %45, %Str8* bitcast ([17 x i8]* @str51 to [0 x i8]*), %Nat8 %5, %Int32 %13, %Nat8 %4)

	;
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
	%6 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([34 x i8]* @str52 to [0 x i8]*), %Word32 %instr)
; if_0
	%7 = icmp eq %Word32 %instr, 115
	br %Bool %7 , label %then_0, label %else_0
then_0:
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%9 = load %Nat32, %Nat32* %8
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %9, %Str8* bitcast ([7 x i8]* @str53 to [0 x i8]*))
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%11 = bitcast %Nat32 3860 to %Nat32
	%12 = getelementptr [4096 x %Word32], [4096 x %Word32]* %10, %Int32 0, %Nat32 %11
	%13 = load %Word32, %Word32* %12
	%14 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([17 x i8]* @str54 to [0 x i8]*), %Word32 %13)
	;
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 3
	%17 = load %Word32, %Word32* %16
	%18 = or %Word32 %17, 8
	store %Word32 %18, %Word32* %15
	br label %endif_0
else_0:
; if_1
	%19 = icmp eq %Word32 %instr, 807403635
	br %Bool %19 , label %then_1, label %else_1
then_1:
	%20 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%21 = load %Nat32, %Nat32* %20
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %21, %Str8* bitcast ([6 x i8]* @str55 to [0 x i8]*))
	; Machine return from trap
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%23 = bitcast %Nat32 833 to %Nat32
	%24 = getelementptr [4096 x %Word32], [4096 x %Word32]* %22, %Int32 0, %Nat32 %23
	%25 = load %Word32, %Word32* %24
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%27 = bitcast %Nat32 834 to %Nat32
	%28 = getelementptr [4096 x %Word32], [4096 x %Word32]* %26, %Int32 0, %Nat32 %27
	%29 = load %Word32, %Word32* %28
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%31 = bitcast %Nat32 835 to %Nat32
	%32 = getelementptr [4096 x %Word32], [4096 x %Word32]* %30, %Int32 0, %Nat32 %31
	%33 = load %Word32, %Word32* %32
	%34 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%35 = bitcast %Nat32 3860 to %Nat32
	%36 = getelementptr [4096 x %Word32], [4096 x %Word32]* %34, %Int32 0, %Nat32 %35
	%37 = load %Word32, %Word32* %36
	%38 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([52 x i8]* @str56 to [0 x i8]*), %Word32 %37, %Word32 %25, %Word32 %29, %Word32 %33)
	%39 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%40 = bitcast %Word32 %25 to %Nat32
	store %Nat32 %40, %Nat32* %39
	br label %endif_1
else_1:
; if_2
	%41 = icmp eq %Word32 %instr, 1048691
	br %Bool %41 , label %then_2, label %else_2
then_2:
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%43 = load %Nat32, %Nat32* %42
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %43, %Str8* bitcast ([8 x i8]* @str57 to [0 x i8]*))
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Bool 1, %Bool* %44

	; CSR instructions
	br label %endif_2
else_2:
; if_3
	%45 = bitcast i8 1 to %Word8
	%46 = icmp eq %Word8 %1, %45
	br %Bool %46 , label %then_3, label %else_3
then_3:
	; CSR read & write
	call void @csr_rw(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_3
else_3:
; if_4
	%47 = bitcast i8 2 to %Word8
	%48 = icmp eq %Word8 %1, %47
	br %Bool %48 , label %then_4, label %else_4
then_4:
	; CSR read & set bit
	call void @csr_rs(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_4
else_4:
; if_5
	%49 = bitcast i8 3 to %Word8
	%50 = icmp eq %Word8 %1, %49
	br %Bool %50 , label %then_5, label %else_5
then_5:
	; CSR read & clear bit
	call void @csr_rc(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_5
else_5:
; if_6
	%51 = bitcast i8 4 to %Word8
	%52 = icmp eq %Word8 %1, %51
	br %Bool %52 , label %then_6, label %else_6
then_6:
	call void @csr_rwi(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_6
else_6:
; if_7
	%53 = bitcast i8 5 to %Word8
	%54 = icmp eq %Word8 %1, %53
	br %Bool %54 , label %then_7, label %else_7
then_7:
	call void @csr_rsi(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_7
else_7:
; if_8
	%55 = bitcast i8 6 to %Word8
	%56 = icmp eq %Word8 %1, %55
	br %Bool %56 , label %then_8, label %else_8
then_8:
	call void @csr_rci(%hart_Hart* %hart, %Nat16 %5, %Nat8 %2, %Nat8 %3)
	br label %endif_8
else_8:
	%57 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%58 = load %Nat32, %Nat32* %57
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %58, %Str8* bitcast ([34 x i8]* @str58 to [0 x i8]*), %Word32 %instr)
	%59 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 4
	store %Bool 1, %Bool* %59
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
	%1 = icmp eq %Word32 %instr, 16777231
	br %Bool %1 , label %then_0, label %endif_0
then_0:
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%3 = load %Nat32, %Nat32* %2
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %3, %Str8* bitcast ([7 x i8]* @str59 to [0 x i8]*))
	br label %endif_0
endif_0:
	ret void
}




;
;The CSRRW (Atomic Read/Write CSR) instruction atomically swaps values in the CSRs and integer registers. CSRRW reads the old value of the CSR, zero-extends the value to XLEN bits, then writes it to integer register rd. The initial value in rs1 is written to the CSR. If rd=x0, then the instruction shall not read the CSR and shall not cause any of the side effects that might occur on a CSR read.
;
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



;
;The CSRRS (Atomic Read and Set Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be set in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be set in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
;
define internal void @csr_rs(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	; csrrs rd, csr, rs
	;printf("CSR_RS(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
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



;
;The CSRRC (Atomic Read and Clear Bits in CSR) instruction reads the value of the CSR, zero-extends the value to XLEN bits, and writes it to integer register rd. The initial value in integer register rs1 is treated as a bit mask that specifies bit positions to be cleared in the CSR. Any bit that is high in rs1 will cause the corresponding bit to be cleared in the CSR, if that CSR bit is writable. Other bits in the CSR are not explicitly written.
;
define internal void @csr_rc(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	; csrrc rd, csr, rs
	;printf("CSR_RC(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
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



; read+write immediate(5-bit)
define internal void @csr_rwi(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	;printf("CSR_RWI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
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



; read+clear immediate(5-bit)
define internal void @csr_rsi(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	;printf("CSR_RSI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
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



; read+clear immediate(5-bit)
define internal void @csr_rci(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	;printf("CSR_RCI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
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


