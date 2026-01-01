
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
declare %Int @snprintf(%CharStr* %buf, %SizeT %size, %ConstCharStr* %format, ...)
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
%hart_RegType = type %Word32;
%hart_Hart = type {
	[32 x %hart_RegType],
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
	%12 = bitcast [32 x %hart_RegType]* %9 to i8*
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
	store %Word32 %24, %Word32* %23	; interrupt cause
	%25 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%26 = bitcast %Nat32 835 to %Nat32
	%27 = getelementptr [4096 x %Word32], [4096 x %Word32]* %25, %Int32 0, %Nat32 %26
	%28 = zext i8 0 to %Word32
	store %Word32 %28, %Word32* %27	; interrupt value (address, etc.)
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

	; R0 must be always zero
	%3 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%4 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %3, %Int32 0, %Int32 0
	%5 = zext i8 0 to %hart_RegType
	store %hart_RegType %5, %hart_RegType* %4
	%6 = alloca %Nat32, align 4
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%8 = load %Nat32, %Nat32* %7
	%9 = add %Nat32 %8, 4
	store %Nat32 %9, %Nat32* %6
; if_0
	%10 = icmp eq %Word8 %1, 19
	br %Bool %10 , label %then_0, label %else_0
then_0:
	call void @execI(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_0
else_0:
; if_1
	%11 = icmp eq %Word8 %1, 51
	br %Bool %11 , label %then_1, label %else_1
then_1:
	call void @execR(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_1
else_1:
; if_2
	%12 = icmp eq %Word8 %1, 55
	br %Bool %12 , label %then_2, label %else_2
then_2:
	call void @execLUI(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_2
else_2:
; if_3
	%13 = icmp eq %Word8 %1, 23
	br %Bool %13 , label %then_3, label %else_3
then_3:
	call void @execAUIPC(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_3
else_3:
; if_4
	%14 = icmp eq %Word8 %1, 111
	br %Bool %14 , label %then_4, label %else_4
then_4:
	%15 = call %Nat32 @execJAL(%hart_Hart* %hart, %Word32 %instr)
	store %Nat32 %15, %Nat32* %6
	br label %endif_4
else_4:
; if_5
	%16 = icmp eq %Word8 %1, 103
	%17 = bitcast i8 0 to %Word8
	%18 = icmp eq %Word8 %2, %17
	%19 = and %Bool %16, %18
	br %Bool %19 , label %then_5, label %else_5
then_5:
	%20 = call %Nat32 @execJALR(%hart_Hart* %hart, %Word32 %instr)
	store %Nat32 %20, %Nat32* %6
	br label %endif_5
else_5:
; if_6
	%21 = icmp eq %Word8 %1, 99
	br %Bool %21 , label %then_6, label %else_6
then_6:
	%22 = call %Nat32 @execB(%hart_Hart* %hart, %Word32 %instr)
	store %Nat32 %22, %Nat32* %6
	br label %endif_6
else_6:
; if_7
	%23 = icmp eq %Word8 %1, 3
	br %Bool %23 , label %then_7, label %else_7
then_7:
	call void @execL(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_7
else_7:
; if_8
	%24 = icmp eq %Word8 %1, 35
	br %Bool %24 , label %then_8, label %else_8
then_8:
	call void @execS(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_8
else_8:
; if_9
	%25 = icmp eq %Word8 %1, 115
	br %Bool %25 , label %then_9, label %else_9
then_9:
	call void @execSystem(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_9
else_9:
; if_10
	%26 = icmp eq %Word8 %1, 15
	br %Bool %26 , label %then_10, label %else_10
then_10:
	call void @execFence(%hart_Hart* %hart, %Word32 %instr)
	br label %endif_10
else_10:
	%27 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%28 = load %Nat32, %Nat32* %27
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %28, %Str8* bitcast ([22 x i8]* @str4 to [0 x i8]*), %Word8 %1)
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
	%29 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%30 = load %Nat32, %Nat32* %6
	store %Nat32 %30, %Nat32* %29
	ret void
}

define internal void @execI(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Word8 @decode_extract_funct7(%Word32 %instr)
	%3 = call %Word32 @decode_extract_imm12(%Word32 %instr)
	%4 = call %Int32 @decode_expand12(%Word32 %3)
	%5 = call %Nat8 @decode_extract_rd(%Word32 %instr)
	%6 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%7 = alloca %hart_RegType, align 4
; if_0
	%8 = bitcast i8 0 to %Word8
	%9 = icmp eq %Word8 %1, %8
	br %Bool %9 , label %then_0, label %else_0
then_0:
	; ADDI (Add immediate)
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%11 = load %Nat32, %Nat32* %10
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %11, %Str8* bitcast ([19 x i8]* @str5 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%13 = zext %Nat8 %6 to %Nat32
	%14 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %12, %Int32 0, %Nat32 %13
	%15 = load %hart_RegType, %hart_RegType* %14
	%16 = bitcast %hart_RegType %15 to %Int32
	%17 = add %Int32 %16, %4
	%18 = bitcast %Int32 %17 to %Word32
	store %Word32 %18, %hart_RegType* %7
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
	; SLLI is a logical left shift (zeros are shifted into the lower bits)
	%24 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%25 = load %Nat32, %Nat32* %24
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %25, %Str8* bitcast ([19 x i8]* @str6 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%27 = zext %Nat8 %6 to %Nat32
	%28 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %26, %Int32 0, %Nat32 %27
	%29 = load %hart_RegType, %hart_RegType* %28
	%30 = trunc %Int32 %4 to %Nat8
	%31 = zext %Nat8 %30 to %hart_RegType
	%32 = shl %hart_RegType %29, %31
	store %hart_RegType %32, %hart_RegType* %7
	br label %endif_1
else_1:
; if_2
	%33 = bitcast i8 2 to %Word8
	%34 = icmp eq %Word8 %1, %33
	br %Bool %34 , label %then_2, label %else_2
then_2:
	; SLTI - set [1 to rd if rs1] less than immediate
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%36 = load %Nat32, %Nat32* %35
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %36, %Str8* bitcast ([19 x i8]* @str7 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%37 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%38 = zext %Nat8 %6 to %Nat32
	%39 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %37, %Int32 0, %Nat32 %38
	%40 = load %hart_RegType, %hart_RegType* %39
	%41 = bitcast %hart_RegType %40 to %Int32
	%42 = icmp slt %Int32 %41, %4
	%43 = zext %Bool %42 to %Word32
	store %Word32 %43, %hart_RegType* %7
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
	%50 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %48, %Int32 0, %Nat32 %49
	%51 = load %hart_RegType, %hart_RegType* %50
	%52 = bitcast %hart_RegType %51 to %Nat32
	%53 = bitcast %Int32 %4 to %Nat32
	%54 = icmp ult %Nat32 %52, %53
	%55 = zext %Bool %54 to %Word32
	store %Word32 %55, %hart_RegType* %7
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
	%62 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %60, %Int32 0, %Nat32 %61
	%63 = bitcast %Int32 %4 to %Word32
	%64 = load %hart_RegType, %hart_RegType* %62
	%65 = xor %hart_RegType %64, %63
	store %hart_RegType %65, %hart_RegType* %7
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
	; SRLI is a logical right shift (zeros are shifted into the upper bits)
	%71 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%72 = load %Nat32, %Nat32* %71
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %72, %Str8* bitcast ([19 x i8]* @str10 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%73 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%74 = zext %Nat8 %6 to %Nat32
	%75 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %73, %Int32 0, %Nat32 %74
	%76 = load %hart_RegType, %hart_RegType* %75
	%77 = trunc %Int32 %4 to %Nat8
	%78 = zext %Nat8 %77 to %hart_RegType
	%79 = lshr %hart_RegType %76, %78
	store %hart_RegType %79, %hart_RegType* %7
	br label %endif_5
else_5:
; if_6
	%80 = bitcast i8 5 to %Word8
	%81 = icmp eq %Word8 %1, %80
	%82 = icmp eq %Word8 %2, 32
	%83 = and %Bool %81, %82
	br %Bool %83 , label %then_6, label %else_6
then_6:
	; SRAI is an arithmetic right shift (the original sign bit is copied into the vacated upper bits)
	%84 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%85 = load %Nat32, %Nat32* %84
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %85, %Str8* bitcast ([19 x i8]* @str11 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%86 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%87 = zext %Nat8 %6 to %Nat32
	%88 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %86, %Int32 0, %Nat32 %87
	%89 = load %hart_RegType, %hart_RegType* %88
	%90 = trunc %Int32 %4 to %Nat8
	%91 = zext %Nat8 %90 to %hart_RegType
	%92 = lshr %hart_RegType %89, %91
	store %hart_RegType %92, %hart_RegType* %7
	br label %endif_6
else_6:
; if_7
	%93 = bitcast i8 6 to %Word8
	%94 = icmp eq %Word8 %1, %93
	br %Bool %94 , label %then_7, label %else_7
then_7:
	%95 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%96 = load %Nat32, %Nat32* %95
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %96, %Str8* bitcast ([18 x i8]* @str12 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%97 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%98 = zext %Nat8 %6 to %Nat32
	%99 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %97, %Int32 0, %Nat32 %98
	%100 = bitcast %Int32 %4 to %Word32
	%101 = load %hart_RegType, %hart_RegType* %99
	%102 = or %hart_RegType %101, %100
	store %hart_RegType %102, %hart_RegType* %7
	br label %endif_7
else_7:
; if_8
	%103 = bitcast i8 7 to %Word8
	%104 = icmp eq %Word8 %1, %103
	br %Bool %104 , label %then_8, label %else_8
then_8:
	%105 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%106 = load %Nat32, %Nat32* %105
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %106, %Str8* bitcast ([19 x i8]* @str13 to [0 x i8]*), %Nat8 %5, %Nat8 %6, %Int32 %4)
	%107 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%108 = zext %Nat8 %6 to %Nat32
	%109 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %107, %Int32 0, %Nat32 %108
	%110 = bitcast %Int32 %4 to %Word32
	%111 = load %hart_RegType, %hart_RegType* %109
	%112 = and %hart_RegType %111, %110
	store %hart_RegType %112, %hart_RegType* %7
	br label %endif_8
else_8:
	; ERROR: unknown instruction
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
	%113 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%114 = zext %Nat8 %5 to %Nat32
	%115 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %113, %Int32 0, %Nat32 %114
	%116 = load %hart_RegType, %hart_RegType* %7
	store %hart_RegType %116, %hart_RegType* %115
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
	%8 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %6, %Int32 0, %Nat32 %7
	%9 = load %hart_RegType, %hart_RegType* %8
	%10 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%11 = zext %Nat8 %5 to %Nat32
	%12 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %10, %Int32 0, %Nat32 %11
	%13 = load %hart_RegType, %hart_RegType* %12
	%14 = alloca %hart_RegType, align 4
; if_0
	%15 = bitcast i8 1 to %Word8
	%16 = icmp eq %Word8 %2, %15
	br %Bool %16 , label %then_0, label %else_0
then_0:

	;
	; "M" extension
	;
; if_1
	%17 = bitcast i8 0 to %Word8
	%18 = icmp eq %Word8 %1, %17
	br %Bool %18 , label %then_1, label %else_1
then_1:
	; MUL rd, rs1, rs2
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%20 = load %Nat32, %Nat32* %19
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %20, %Str8* bitcast ([19 x i8]* @str14 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%21 = bitcast %hart_RegType %9 to %Int32
	%22 = bitcast %hart_RegType %13 to %Int32
	%23 = mul %Int32 %21, %22
	%24 = bitcast %Int32 %23 to %Word32
	store %Word32 %24, %hart_RegType* %14
	br label %endif_1
else_1:
; if_2
	%25 = bitcast i8 1 to %Word8
	%26 = icmp eq %Word8 %1, %25
	br %Bool %26 , label %then_2, label %else_2
then_2:
	; MULH rd, rs1, rs2
	; Записывает в целевой регистр старшие биты
	; которые бы не поместились в него при обычном умножении
	%27 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%28 = load %Nat32, %Nat32* %27
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %28, %Str8* bitcast ([20 x i8]* @str15 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%29 = sext %hart_RegType %9 to %Int64
	%30 = sext %hart_RegType %13 to %Int64
	%31 = mul %Int64 %29, %30
	%32 = bitcast %Int64 %31 to %Word64
	%33 = zext i8 32 to %Word64
	%34 = lshr %Word64 %32, %33
	%35 = trunc %Word64 %34 to %Word32
	store %Word32 %35, %hart_RegType* %14
	br label %endif_2
else_2:
; if_3
	%36 = bitcast i8 2 to %Word8
	%37 = icmp eq %Word8 %1, %36
	br %Bool %37 , label %then_3, label %else_3
then_3:
	; MULHSU rd, rs1, rs2
	; mul high signed unsigned
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%39 = load %Nat32, %Nat32* %38
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %39, %Str8* bitcast ([22 x i8]* @str16 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str17 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	;result = unsafe Word32 (Word64 (Int64 v0 * Int64 v1) >> 32)
	br label %endif_3
else_3:
; if_4
	%40 = bitcast i8 3 to %Word8
	%41 = icmp eq %Word8 %1, %40
	br %Bool %41 , label %then_4, label %else_4
then_4:
	; MULHU rd, rs1, rs2 multiply unsigned high
	%42 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%43 = load %Nat32, %Nat32* %42
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %43, %Str8* bitcast ([21 x i8]* @str18 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	call void (%Str8*, ...) @notImplemented(%Str8* bitcast ([21 x i8]* @str19 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	;result = unsafe Word32 (Word64 (Nat64 v0 * Nat64 v1) >> 32)
	br label %endif_4
else_4:
; if_5
	%44 = bitcast i8 4 to %Word8
	%45 = icmp eq %Word8 %1, %44
	br %Bool %45 , label %then_5, label %else_5
then_5:
	; DIV rd, rs1, rs2
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%47 = load %Nat32, %Nat32* %46
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %47, %Str8* bitcast ([19 x i8]* @str20 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%48 = bitcast %hart_RegType %9 to %Int32
	%49 = bitcast %hart_RegType %13 to %Int32
	%50 = sdiv %Int32 %48, %49
	%51 = bitcast %Int32 %50 to %Word32
	store %Word32 %51, %hart_RegType* %14
	br label %endif_5
else_5:
; if_6
	%52 = bitcast i8 5 to %Word8
	%53 = icmp eq %Word8 %1, %52
	br %Bool %53 , label %then_6, label %else_6
then_6:
	; DIVU rd, rs1, rs2
	%54 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%55 = load %Nat32, %Nat32* %54
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %55, %Str8* bitcast ([20 x i8]* @str21 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%56 = bitcast %hart_RegType %9 to %Nat32
	%57 = bitcast %hart_RegType %13 to %Nat32
	%58 = udiv %Nat32 %56, %57
	%59 = bitcast %Nat32 %58 to %Word32
	store %Word32 %59, %hart_RegType* %14
	br label %endif_6
else_6:
; if_7
	%60 = bitcast i8 6 to %Word8
	%61 = icmp eq %Word8 %1, %60
	br %Bool %61 , label %then_7, label %else_7
then_7:
	; REM rd, rs1, rs2
	%62 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%63 = load %Nat32, %Nat32* %62
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %63, %Str8* bitcast ([19 x i8]* @str22 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%64 = bitcast %hart_RegType %9 to %Int32
	%65 = bitcast %hart_RegType %13 to %Int32
	%66 = srem %Int32 %64, %65
	%67 = bitcast %Int32 %66 to %Word32
	store %Word32 %67, %hart_RegType* %14
	br label %endif_7
else_7:
; if_8
	%68 = bitcast i8 7 to %Word8
	%69 = icmp eq %Word8 %1, %68
	br %Bool %69 , label %then_8, label %endif_8
then_8:
	; REMU rd, rs1, rs2
	%70 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%71 = load %Nat32, %Nat32* %70
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %71, %Str8* bitcast ([20 x i8]* @str23 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%72 = bitcast %hart_RegType %9 to %Nat32
	%73 = bitcast %hart_RegType %13 to %Nat32
	%74 = urem %Nat32 %72, %73
	%75 = bitcast %Nat32 %74 to %Word32
	store %Word32 %75, %hart_RegType* %14
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
	%78 = icmp eq %Word8 %2, 0
	%79 = and %Bool %77, %78
	br %Bool %79 , label %then_9, label %else_9
then_9:
	%80 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%81 = load %Nat32, %Nat32* %80
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %81, %Str8* bitcast ([19 x i8]* @str24 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%82 = bitcast %hart_RegType %9 to %Int32
	%83 = bitcast %hart_RegType %13 to %Int32
	%84 = add %Int32 %82, %83
	%85 = bitcast %Int32 %84 to %Word32
	store %Word32 %85, %hart_RegType* %14
	br label %endif_9
else_9:
; if_10
	%86 = bitcast i8 0 to %Word8
	%87 = icmp eq %Word8 %1, %86
	%88 = icmp eq %Word8 %2, 32
	%89 = and %Bool %87, %88
	br %Bool %89 , label %then_10, label %else_10
then_10:
	%90 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%91 = load %Nat32, %Nat32* %90
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %91, %Str8* bitcast ([19 x i8]* @str25 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%92 = bitcast %hart_RegType %9 to %Int32
	%93 = bitcast %hart_RegType %13 to %Int32
	%94 = sub %Int32 %92, %93
	%95 = bitcast %Int32 %94 to %Word32
	store %Word32 %95, %hart_RegType* %14
	br label %endif_10
else_10:
; if_11
	%96 = bitcast i8 1 to %Word8
	%97 = icmp eq %Word8 %1, %96
	br %Bool %97 , label %then_11, label %else_11
then_11:
	; shift left logical
	%98 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%99 = load %Nat32, %Nat32* %98
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %99, %Str8* bitcast ([19 x i8]* @str26 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%100 = trunc %hart_RegType %13 to %Nat8
	%101 = zext %Nat8 %100 to %hart_RegType
	%102 = shl %hart_RegType %9, %101
	store %hart_RegType %102, %hart_RegType* %14
	br label %endif_11
else_11:
; if_12
	%103 = bitcast i8 2 to %Word8
	%104 = icmp eq %Word8 %1, %103
	br %Bool %104 , label %then_12, label %else_12
then_12:
	; set less than
	%105 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%106 = load %Nat32, %Nat32* %105
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %106, %Str8* bitcast ([19 x i8]* @str27 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%107 = bitcast %hart_RegType %9 to %Int32
	%108 = bitcast %hart_RegType %13 to %Int32
	%109 = icmp slt %Int32 %107, %108
	%110 = zext %Bool %109 to %Word32
	store %Word32 %110, %hart_RegType* %14
	br label %endif_12
else_12:
; if_13
	%111 = bitcast i8 3 to %Word8
	%112 = icmp eq %Word8 %1, %111
	br %Bool %112 , label %then_13, label %else_13
then_13:
	; set less than unsigned
	%113 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%114 = load %Nat32, %Nat32* %113
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %114, %Str8* bitcast ([20 x i8]* @str28 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%115 = bitcast %hart_RegType %9 to %Nat32
	%116 = bitcast %hart_RegType %13 to %Nat32
	%117 = icmp ult %Nat32 %115, %116
	%118 = zext %Bool %117 to %Word32
	store %Word32 %118, %hart_RegType* %14
	br label %endif_13
else_13:
; if_14
	%119 = bitcast i8 4 to %Word8
	%120 = icmp eq %Word8 %1, %119
	br %Bool %120 , label %then_14, label %else_14
then_14:
	; XOR
	%121 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%122 = load %Nat32, %Nat32* %121
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %122, %Str8* bitcast ([19 x i8]* @str29 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%123 = xor %hart_RegType %9, %13
	store %hart_RegType %123, %hart_RegType* %14
	br label %endif_14
else_14:
; if_15
	%124 = bitcast i8 5 to %Word8
	%125 = icmp eq %Word8 %1, %124
	%126 = bitcast i8 0 to %Word8
	%127 = icmp eq %Word8 %2, %126
	%128 = and %Bool %125, %127
	br %Bool %128 , label %then_15, label %else_15
then_15:
	; SRL - shift right logical
	%129 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%130 = load %Nat32, %Nat32* %129
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %130, %Str8* bitcast ([19 x i8]* @str30 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%131 = trunc %hart_RegType %13 to %Nat8
	%132 = zext %Nat8 %131 to %hart_RegType
	%133 = lshr %hart_RegType %9, %132
	store %hart_RegType %133, %hart_RegType* %14
	br label %endif_15
else_15:
; if_16
	%134 = bitcast i8 5 to %Word8
	%135 = icmp eq %Word8 %1, %134
	%136 = icmp eq %Word8 %2, 32
	%137 = and %Bool %135, %136
	br %Bool %137 , label %then_16, label %else_16
then_16:
	; SRA - shift right arithmetical
	%138 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%139 = load %Nat32, %Nat32* %138
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %139, %Str8* bitcast ([19 x i8]* @str31 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)

	; ERROR: не реализован арифм сдвиг!
	;result = v0 >> Int32 v1
	br label %endif_16
else_16:
; if_17
	%140 = bitcast i8 6 to %Word8
	%141 = icmp eq %Word8 %1, %140
	br %Bool %141 , label %then_17, label %else_17
then_17:
	%142 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%143 = load %Nat32, %Nat32* %142
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %143, %Str8* bitcast ([18 x i8]* @str32 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%144 = or %hart_RegType %9, %13
	store %hart_RegType %144, %hart_RegType* %14
	br label %endif_17
else_17:
; if_18
	%145 = bitcast i8 7 to %Word8
	%146 = icmp eq %Word8 %1, %145
	br %Bool %146 , label %then_18, label %endif_18
then_18:
	%147 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%148 = load %Nat32, %Nat32* %147
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %148, %Str8* bitcast ([19 x i8]* @str33 to [0 x i8]*), %Nat8 %3, %Nat8 %4, %Nat8 %5)
	%149 = and %hart_RegType %9, %13
	store %hart_RegType %149, %hart_RegType* %14
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
	%150 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%151 = zext %Nat8 %3 to %Nat32
	%152 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %150, %Int32 0, %Nat32 %151
	%153 = load %hart_RegType, %hart_RegType* %14
	store %hart_RegType %153, %hart_RegType* %152
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
	%7 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %5, %Int32 0, %Nat32 %6
	%8 = zext i8 12 to %Word32
	%9 = shl %Word32 %1, %8
	store %Word32 %9, %hart_RegType* %7
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
	%15 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %13, %Int32 0, %Nat32 %14
	%16 = bitcast %Nat32 %9 to %Word32
	store %Word32 %16, %hart_RegType* %15
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
	%8 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %6, %Int32 0, %Nat32 %7
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%10 = load %Nat32, %Nat32* %9
	%11 = add %Nat32 %10, 4
	%12 = bitcast %Nat32 %11 to %Word32
	store %Word32 %12, %hart_RegType* %8
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

	; rd <- pc + 4
	; pc <- (rs1 + imm) & ~1
	%7 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%8 = load %Nat32, %Nat32* %7
	%9 = add %Nat32 %8, 4
	%10 = bitcast %Nat32 %9 to %Int32
	%11 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%12 = zext %Nat8 %1 to %Nat32
	%13 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %11, %Int32 0, %Nat32 %12
	%14 = load %hart_RegType, %hart_RegType* %13
	%15 = bitcast %hart_RegType %14 to %Int32
	%16 = add %Int32 %15, %4
	%17 = bitcast %Int32 %16 to %Word32
	%18 = and %Word32 %17, 4294967294
	%19 = bitcast %Word32 %18 to %Nat32
	%20 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%21 = zext %Nat8 %2 to %Nat32
	%22 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %20, %Int32 0, %Nat32 %21
	%23 = bitcast %Int32 %10 to %Word32
	store %Word32 %23, %hart_RegType* %22
	ret %Nat32 %19
}

define internal %Nat32 @execB(%hart_Hart* %hart, %Word32 %instr) {
	%1 = call %Word8 @decode_extract_funct3(%Word32 %instr)
	%2 = call %Nat8 @decode_extract_rs1(%Word32 %instr)
	%3 = call %Nat8 @decode_extract_rs2(%Word32 %instr)
	%4 = call %Int16 @decode_extract_b_imm(%Word32 %instr)
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %2 to %Nat32
	%7 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %5, %Int32 0, %Nat32 %6
	%8 = load %hart_RegType, %hart_RegType* %7
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%10 = zext %Nat8 %3 to %Nat32
	%11 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %9, %Int32 0, %Nat32 %10
	%12 = load %hart_RegType, %hart_RegType* %11
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
	; BEQ - Branch if equal
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%20 = load %Nat32, %Nat32* %19
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %20, %Str8* bitcast ([18 x i8]* @str38 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_1
	%21 = icmp eq %hart_RegType %8, %12
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
	; BNE - Branch if not equal
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%31 = load %Nat32, %Nat32* %30
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %31, %Str8* bitcast ([18 x i8]* @str39 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_3
	%32 = icmp ne %hart_RegType %8, %12
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
	; BLT - Branch if less than (signed)
	%41 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%42 = load %Nat32, %Nat32* %41
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %42, %Str8* bitcast ([18 x i8]* @str40 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_5
	%43 = bitcast %hart_RegType %8 to %Int32
	%44 = bitcast %hart_RegType %12 to %Int32
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
	; BGE - Branch if greater or equal (signed)
	%54 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%55 = load %Nat32, %Nat32* %54
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %55, %Str8* bitcast ([18 x i8]* @str41 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_7
	%56 = bitcast %hart_RegType %8 to %Int32
	%57 = bitcast %hart_RegType %12 to %Int32
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
	; BLTU - Branch if less than (unsigned)
	%67 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%68 = load %Nat32, %Nat32* %67
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %68, %Str8* bitcast ([19 x i8]* @str42 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_9
	%69 = bitcast %hart_RegType %8 to %Nat32
	%70 = bitcast %hart_RegType %12 to %Nat32
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
	; BGEU - Branch if greater or equal (unsigned)
	%80 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%81 = load %Nat32, %Nat32* %80
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %81, %Str8* bitcast ([19 x i8]* @str43 to [0 x i8]*), %Nat8 %2, %Nat8 %3, %Int16 %4)
; if_11
	%82 = bitcast %hart_RegType %8 to %Nat32
	%83 = bitcast %hart_RegType %12 to %Nat32
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
	; ERROR: unknown instruction
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
	%9 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %7, %Int32 0, %Nat32 %8
	%10 = load %hart_RegType, %hart_RegType* %9
	%11 = bitcast %hart_RegType %10 to %Int32
	%12 = add %Int32 %11, %3
	%13 = bitcast %Int32 %12 to %Nat32
	%14 = alloca %hart_RegType, align 4
; if_0
	%15 = bitcast i8 0 to %Word8
	%16 = icmp eq %Word8 %1, %15
	br %Bool %16 , label %then_0, label %else_0
then_0:
	; LB (Load 8-bit signed integer value)
	%17 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%18 = load %Nat32, %Nat32* %17
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %18, %Str8* bitcast ([17 x i8]* @str44 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%19 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%20 = load %hart_BusInterface*, %hart_BusInterface** %19
	%21 = getelementptr %hart_BusInterface, %hart_BusInterface* %20, %Int32 0, %Int32 0
	%22 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %21
	%23 = call %Word32 %22(%Nat32 %13, %Nat8 1)
	store %Word32 %23, %hart_RegType* %14
	br label %endif_0
else_0:
; if_1
	%24 = bitcast i8 1 to %Word8
	%25 = icmp eq %Word8 %1, %24
	br %Bool %25 , label %then_1, label %else_1
then_1:
	; LH (Load 16-bit signed integer value)
	%26 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%27 = load %Nat32, %Nat32* %26
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %27, %Str8* bitcast ([17 x i8]* @str45 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%28 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%29 = load %hart_BusInterface*, %hart_BusInterface** %28
	%30 = getelementptr %hart_BusInterface, %hart_BusInterface* %29, %Int32 0, %Int32 0
	%31 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %30
	%32 = call %Word32 %31(%Nat32 %13, %Nat8 2)
	store %Word32 %32, %hart_RegType* %14
	br label %endif_1
else_1:
; if_2
	%33 = bitcast i8 2 to %Word8
	%34 = icmp eq %Word8 %1, %33
	br %Bool %34 , label %then_2, label %else_2
then_2:
	; LW (Load 32-bit signed integer value)
	%35 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%36 = load %Nat32, %Nat32* %35
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %36, %Str8* bitcast ([17 x i8]* @str46 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%37 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%38 = load %hart_BusInterface*, %hart_BusInterface** %37
	%39 = getelementptr %hart_BusInterface, %hart_BusInterface* %38, %Int32 0, %Int32 0
	%40 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %39
	%41 = call %Word32 %40(%Nat32 %13, %Nat8 4)
	store %Word32 %41, %hart_RegType* %14
	br label %endif_2
else_2:
; if_3
	%42 = bitcast i8 4 to %Word8
	%43 = icmp eq %Word8 %1, %42
	br %Bool %43 , label %then_3, label %else_3
then_3:
	; LBU (Load 8-bit unsigned integer value)
	%44 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%45 = load %Nat32, %Nat32* %44
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %45, %Str8* bitcast ([18 x i8]* @str47 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%47 = load %hart_BusInterface*, %hart_BusInterface** %46
	%48 = getelementptr %hart_BusInterface, %hart_BusInterface* %47, %Int32 0, %Int32 0
	%49 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %48
	%50 = call %Word32 %49(%Nat32 %13, %Nat8 1)
	store %Word32 %50, %hart_RegType* %14
	br label %endif_3
else_3:
; if_4
	%51 = bitcast i8 5 to %Word8
	%52 = icmp eq %Word8 %1, %51
	br %Bool %52 , label %then_4, label %endif_4
then_4:
	; LHU (Load 16-bit unsigned integer value)
	%53 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 1
	%54 = load %Nat32, %Nat32* %53
	call void (%Nat32, %Str8*, ...) @trace(%Nat32 %54, %Str8* bitcast ([18 x i8]* @str48 to [0 x i8]*), %Nat8 %4, %Int32 %3, %Nat8 %5)
	%55 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%56 = load %hart_BusInterface*, %hart_BusInterface** %55
	%57 = getelementptr %hart_BusInterface, %hart_BusInterface* %56, %Int32 0, %Int32 0
	%58 = load %Word32 (%Nat32, %Nat8)*, %Word32 (%Nat32, %Nat8)** %57
	%59 = call %Word32 %58(%Nat32 %13, %Nat8 2)
	store %Word32 %59, %hart_RegType* %14
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
	%62 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %60, %Int32 0, %Nat32 %61
	%63 = load %hart_RegType, %hart_RegType* %14
	store %hart_RegType %63, %hart_RegType* %62
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
	%16 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %14, %Int32 0, %Nat32 %15
	%17 = load %hart_RegType, %hart_RegType* %16
	%18 = bitcast %hart_RegType %17 to %Int32
	%19 = add %Int32 %18, %13
	%20 = bitcast %Int32 %19 to %Word32
	%21 = bitcast %Word32 %20 to %Nat32
	%22 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%23 = zext %Nat8 %5 to %Nat32
	%24 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %22, %Int32 0, %Nat32 %23
	%25 = load %hart_RegType, %hart_RegType* %24
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
	%30 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%31 = load %hart_BusInterface*, %hart_BusInterface** %30
	%32 = getelementptr %hart_BusInterface, %hart_BusInterface* %31, %Int32 0, %Int32 1
	%33 = load void (%Nat32, %Word32, %Nat8)*, void (%Nat32, %Word32, %Nat8)** %32
	call void %33(%Nat32 %21, %hart_RegType %25, %Nat8 1)
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
	%38 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%39 = load %hart_BusInterface*, %hart_BusInterface** %38
	%40 = getelementptr %hart_BusInterface, %hart_BusInterface* %39, %Int32 0, %Int32 1
	%41 = load void (%Nat32, %Word32, %Nat8)*, void (%Nat32, %Word32, %Nat8)** %40
	call void %41(%Nat32 %21, %hart_RegType %25, %Nat8 2)
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
	%46 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 2
	%47 = load %hart_BusInterface*, %hart_BusInterface** %46
	%48 = getelementptr %hart_BusInterface, %hart_BusInterface* %47, %Int32 0, %Int32 1
	%49 = load void (%Nat32, %Word32, %Nat8)*, void (%Nat32, %Word32, %Nat8)** %48
	call void %49(%Nat32 %21, %hart_RegType %25, %Nat8 4)
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
	; TODO: it will not works (!)
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

define internal void @csr_rw(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	%1 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([35 x i8]* @str60 to [0 x i8]*), %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1)
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rs1 to %Nat32
	%4 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %2, %Int32 0, %Nat32 %3
	%5 = load %hart_RegType, %hart_RegType* %4
	%6 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%7 = zext %Nat8 %rd to %Nat32
	%8 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %6, %Int32 0, %Nat32 %7
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = zext %Nat16 %csr to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	%12 = load %Word32, %Word32* %11
	store %Word32 %12, %hart_RegType* %8
	%13 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%14 = zext %Nat16 %csr to %Nat32
	%15 = getelementptr [4096 x %Word32], [4096 x %Word32]* %13, %Int32 0, %Nat32 %14
	store %hart_RegType %5, %Word32* %15
	ret void
}

define internal void @csr_rs(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	; csrrs rd, csr, rs
	;printf("CSR_RS(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%2 = zext %Nat8 %rs1 to %Nat32
	%3 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %1, %Int32 0, %Nat32 %2
	%4 = load %hart_RegType, %hart_RegType* %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %rd to %Nat32
	%7 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %5, %Int32 0, %Nat32 %6
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%9 = zext %Nat16 %csr to %Nat32
	%10 = getelementptr [4096 x %Word32], [4096 x %Word32]* %8, %Int32 0, %Nat32 %9
	%11 = load %Word32, %Word32* %10
	store %Word32 %11, %hart_RegType* %7
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%13 = zext %Nat16 %csr to %Nat32
	%14 = getelementptr [4096 x %Word32], [4096 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%16 = zext %Nat16 %csr to %Nat32
	%17 = getelementptr [4096 x %Word32], [4096 x %Word32]* %15, %Int32 0, %Nat32 %16
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%19 = zext %Nat8 %rs1 to %Nat32
	%20 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %18, %Int32 0, %Nat32 %19
	%21 = load %Word32, %Word32* %17
	%22 = load %hart_RegType, %hart_RegType* %20
	%23 = or %Word32 %21, %22
	store %Word32 %23, %Word32* %14
	ret void
}

define internal void @csr_rc(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %rs1) {
	; csrrc rd, csr, rs
	;printf("CSR_RC(csr=0x%X, rd=r%d, rs1=r%d)\n", csr, rd, rs1)
	%1 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%2 = zext %Nat8 %rs1 to %Nat32
	%3 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %1, %Int32 0, %Nat32 %2
	%4 = load %hart_RegType, %hart_RegType* %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%6 = zext %Nat8 %rd to %Nat32
	%7 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %5, %Int32 0, %Nat32 %6
	%8 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%9 = zext %Nat16 %csr to %Nat32
	%10 = getelementptr [4096 x %Word32], [4096 x %Word32]* %8, %Int32 0, %Nat32 %9
	%11 = load %Word32, %Word32* %10
	store %Word32 %11, %hart_RegType* %7
	%12 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%13 = zext %Nat16 %csr to %Nat32
	%14 = getelementptr [4096 x %Word32], [4096 x %Word32]* %12, %Int32 0, %Nat32 %13
	%15 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%16 = zext %Nat16 %csr to %Nat32
	%17 = getelementptr [4096 x %Word32], [4096 x %Word32]* %15, %Int32 0, %Nat32 %16
	%18 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%19 = zext %Nat8 %rs1 to %Nat32
	%20 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %18, %Int32 0, %Nat32 %19
	%21 = load %hart_RegType, %hart_RegType* %20
	%22 = xor %hart_RegType %21, -1
	%23 = load %Word32, %Word32* %17
	%24 = and %Word32 %23, %22
	store %Word32 %24, %Word32* %14
	ret void
}

define internal void @csr_rwi(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	;printf("CSR_RWI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rd to %Nat32
	%4 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %2, %Int32 0, %Nat32 %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%6 = zext %Nat16 %csr to %Nat32
	%7 = getelementptr [4096 x %Word32], [4096 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	store %Word32 %8, %hart_RegType* %4
	%9 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%10 = zext %Nat16 %csr to %Nat32
	%11 = getelementptr [4096 x %Word32], [4096 x %Word32]* %9, %Int32 0, %Nat32 %10
	store %Word32 %1, %Word32* %11
	ret void
}

define internal void @csr_rsi(%hart_Hart* %hart, %Nat16 %csr, %Nat8 %rd, %Nat8 %imm) {
	%1 = zext %Nat8 %imm to %Word32
	;printf("CSR_RSI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rd to %Nat32
	%4 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %2, %Int32 0, %Nat32 %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%6 = zext %Nat16 %csr to %Nat32
	%7 = getelementptr [4096 x %Word32], [4096 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	store %Word32 %8, %hart_RegType* %4
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
	;printf("CSR_RCI(csr=0x%X, rd=r%d, imm=%0x%X)\n", csr, rd, imm32)
	%2 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%3 = zext %Nat8 %rd to %Nat32
	%4 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %2, %Int32 0, %Nat32 %3
	%5 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 5
	%6 = zext %Nat16 %csr to %Nat32
	%7 = getelementptr [4096 x %Word32], [4096 x %Word32]* %5, %Int32 0, %Nat32 %6
	%8 = load %Word32, %Word32* %7
	store %Word32 %8, %hart_RegType* %4
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
	%8 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %6, %Int32 0, %Nat32 %7
	%9 = load %hart_RegType, %hart_RegType* %8
	%10 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([15 x i8]* @str66 to [0 x i8]*), %Nat16 %4, %hart_RegType %9)
	%11 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([5 x i8]* @str67 to [0 x i8]*))
	%12 = load %Nat16, %Nat16* %1
	%13 = add %Nat16 %12, 16
	%14 = load %Nat16, %Nat16* %1
	%15 = add %Nat16 %14, 16
	%16 = getelementptr %hart_Hart, %hart_Hart* %hart, %Int32 0, %Int32 0
	%17 = zext %Nat16 %15 to %Nat32
	%18 = getelementptr [32 x %hart_RegType], [32 x %hart_RegType]* %16, %Int32 0, %Nat32 %17
	%19 = load %hart_RegType, %hart_RegType* %18
	%20 = call %Int (%ConstCharStr*, ...) @printf(%ConstCharStr* bitcast ([16 x i8]* @str68 to [0 x i8]*), %Nat16 %13, %hart_RegType %19)
	%21 = load %Nat16, %Nat16* %1
	%22 = add %Nat16 %21, 1
	store %Nat16 %22, %Nat16* %1
	br label %again_1
break_1:
	ret void
}


