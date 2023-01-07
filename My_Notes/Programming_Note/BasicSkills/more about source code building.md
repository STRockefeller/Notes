# More about source code building

#c #golang #preprocess #compile #link #build #gcc

references:

[Compiling C files with gcc, step by step](https://medium.com/@laura.derohan/compiling-c-files-with-gcc-step-by-step-8e78318052)

## Abstract

這篇筆記想探討的是基礎中的基礎，從 source code 到 executable file 中間的過程。

簡單來說就是 preprocessing, compilation, assemble and linking 四個步驟。

這些都是剛開始學寫程式一定會學到的東西，但是由於現在IDE幾乎都把他們一手包辦了，我才發覺我對他們的了解其實非常的有限。

這篇筆記的部分內容有在CS50前幾堂課中有提到，可以對照CS50的筆記服用。

主要內容我會以 C 語言為例，其他則作為補充。

![](https://miro.medium.com/max/518/1*wHKe6W4opLmk6pb7sxZz6w.png)

## Preprocessing

The preprocessor has several roles:

- it gets rid of all the *comments* in the source file(s)
- it includes the code of the *header file(s)*, which is a file with extension .h which contains C function declarations and macro definitions
- it replaces all of the *macros* (fragments of code which have been given a name) by their values

透過 gcc ，可以試著單獨執行這個步驟

假如我有 `hello.c`  如下

```c
#include <stdio.h>

int main() {
    printf("Hello, world!\n");
    return 0;
}
```

透過 `gcc --help` 可以看到

```bash
  -E                       僅作前置處理；不進行編譯、組譯和連結。
```

執行 `gcc -E -o hello.i .\hello.c` 後可以看到 `hello.c` 被擴展成上千行的code。

這個步驟會解析source code 中的 preprocess commands 就是 `#` 開頭的那些，如 `#indclude`  `#define` `#if` 等等。

![](https://i.imgur.com/d64rvFl.png)

除了gcc 以外 也可以使用 GNU C Preprocessor (cpp.exe) 來達成目的 `cpp.exe hello.c > hello.i`

使用 powershell 的話要注意這邊的 cpp 不要用錯了

```powershell
PS D:\Rockefeller\Projects_Test\compiletest20220905> Get-Alias cpp

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           cpp -> Copy-ItemProperty
```

## Compilation

老樣子，先看gcc 有沒有提供單獨執行的用法

```bash
-S                       只進行編譯；不進行組譯和連結。
```

一樣拿上面的範例來做測試

```powershell
gcc -S ./hello.c
```

得到

```assembly
    .file    "hello.c"
    .text
    .def    printf;    .scl    3;    .type    32;    .endef
    .seh_proc    printf
printf:
    pushq    %rbp
    .seh_pushreg    %rbp
    pushq    %rbx
    .seh_pushreg    %rbx
    subq    $56, %rsp
    .seh_stackalloc    56
    leaq    48(%rsp), %rbp
    .seh_setframe    %rbp, 48
    .seh_endprologue
    movq    %rcx, 32(%rbp)
    movq    %rdx, 40(%rbp)
    movq    %r8, 48(%rbp)
    movq    %r9, 56(%rbp)
    leaq    40(%rbp), %rax
    movq    %rax, -16(%rbp)
    movq    -16(%rbp), %rbx
    movl    $1, %ecx
    movq    __imp___acrt_iob_func(%rip), %rax
    call    *%rax
    movq    %rbx, %r8
    movq    32(%rbp), %rdx
    movq    %rax, %rcx
    call    __mingw_vfprintf
    movl    %eax, -4(%rbp)
    movl    -4(%rbp), %eax
    addq    $56, %rsp
    popq    %rbx
    popq    %rbp
    ret
    .seh_endproc
    .def    __main;    .scl    2;    .type    32;    .endef
    .section .rdata,"dr"
.LC0:
    .ascii "Hello, world!\12\0"
    .text
    .globl    main
    .def    main;    .scl    2;    .type    32;    .endef
    .seh_proc    main
main:
    pushq    %rbp
    .seh_pushreg    %rbp
    movq    %rsp, %rbp
    .seh_setframe    %rbp, 0
    subq    $32, %rsp
    .seh_stackalloc    32
    .seh_endprologue
    call    __main
    leaq    .LC0(%rip), %rcx
    call    printf
    movl    $0, %eax
    addq    $32, %rsp
    popq    %rbp
    ret
    .seh_endproc
    .ident    "GCC: (tdm64-1) 10.3.0"
    .def    __mingw_vfprintf;    .scl    2;    .type    32;    .endef
```

這邊我測試過，拿剛才preprocess 出來的 `hello.i` 和 source code `hello.c` 做compile 結果是一樣的。

## Assemble

把上一步輸出的組合語言近一步變成機械語言，老樣子可以使用gcc提供的 flag

```bash
-c                       編譯並組譯，但不連結。
```

或者用 `as.exe`

```powershell
as.exe -o hello.o .\hello.s
```

輸出是機械語言，貼上來也沒意義。

## Linking

The linker creates the final executable, in binary, and can play two roles:

- linking all the source files together, that is all the other object codes in the project. For example, if I want to compile main.c with another file called secondary.c and make them into one single program, this is the step where the object code of secondary.c (that is secondary.o) will be linked to the main.c object code (main.o).
- linking function calls with their definitions. The linker knows where to look for the function definitions in the *static libraries* or *dynamic libraries.* Static libraries are “the result of the linker making copy of all used library functions to the executable file”, according to geeksforgeeks.org, and dynamic libraries “don’t require the code to be copied, it is done by just placing the name of the library in the binary file”. Note that gcc uses by default dynamic libraries. In our example this is when the linker will find the definition of our “puts” function, and link it.

把 main 和其參考的 assemble 結果連結起來。主要目的就是找file外的參考。

有缺的話就會像這樣

```powershell
PS D:\Rockefeller\Projects_Test\compiletest20220905> ld.exe -o hello.exe .\hello.o
C:\TDM-GCC-64\bin\ld.exe: .\hello.o:hello.c:(.text+0x2f): undefined reference to `__imp___acrt_iob_func'
C:\TDM-GCC-64\bin\ld.exe: .\hello.o:hello.c:(.text+0x40): undefined reference to `__mingw_vfprintf'
C:\TDM-GCC-64\bin\ld.exe: .\hello.o:hello.c:(.text+0x5a): undefined reference to `__main'
```

QQ 寫了這篇筆記我還是不知道怎麼 link hello world...

### All in one

現代的IDE或編譯工具基本上都把上面的步驟包得好好的，例如 gcc ，可以透過 verbose flag 去看他詳細做了哪些事情。

```bash
$ gcc -v hello.c > gcc.out
 specsC
COLLECT_GCC=C:\TDM-GCC-64\bin\gcc.exe
COLLECT_LTO_WRAPPER=C:/TDM-GCC-64/bin/../libexec/gcc/x86_64-w64-mingw32/10.3.0/lto-wrapper.exe
Gx86_64-w64-mingw32
tmG../../../src/gcc-git-10.3.0/configure --build=x86_64-w64-mingw32 --enable-targets=all --enable-languages=ada,c,c++,fortran,jit,lto,objc,obj-c++ --enable-libgomp --enable-lto --enable-graphite --enable-cxx-flags=-DWINPTHREAD_STATIC --disable-build-with-cxx --disable-build-poststage1-with-cxx --enable-libstdcxx-debug --enable-threads=posix --enable-version-specific-runtime-libs --enable-fully-dynamic-string --enable-libstdcxx-filesystem-ts=yes --disable-libstdcxx-pch --enable-libstdcxx-threads --enable-libstdcxx-time=yes --enable-mingw-wildcard --with-gnu-ld --disable-werror --enable-nls --disable-win32-registry --enable-large-address-aware --disable-rpath --disable-symvers --prefix=/mingw64tdm --with-local-prefix=/mingw64tdm --with-pkgversion=tdm64-1 --with-bugurl=https://github.com/jmeubank/tdm-gcc/issues
Gposix
 LTO YtkGzlib zstd    
gcc  10.3.0 (tdm64-1) 
COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64'
 C:/TDM-GCC-64/bin/../libexec/gcc/x86_64-w64-mingw32/10.3.0/cc1.exe -quiet -v -iprefix C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/ -D_REENTRANT hello.c -quiet -dumpbase hello.c -mtune=generic -march=x86-64 -auxbase hello -version -o C:\Users\rockefel\AppData\Local\Temp\ccJnOAyG.s
GNU C17 (tdm64-1) version 10.3.0 (x86_64-w64-mingw32)
        compiled by GNU C version 10.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.23-GMP

GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
ignoring duplicate directory "C:/TDM-GCC-64/lib/gcc/../../lib/gcc/x86_64-w64-mingw32/10.3.0/include"
ignoring duplicate directory "C:/TDM-GCC-64/lib/gcc/../../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../include"
ignoring duplicate directory "C:/TDM-GCC-64/lib/gcc/../../lib/gcc/x86_64-w64-mingw32/10.3.0/include-fixed"
ignoring duplicate directory "C:/TDM-GCC-64/lib/gcc/../../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/include"
#include "..." search starts here:
#include <...> search starts here:
 C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/include
 C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../include
 C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/include-fixed
 C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/include
End of search list.
GNU C17 (tdm64-1) version 10.3.0 (x86_64-w64-mingw32)
        compiled by GNU C version 10.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.23-GMP

GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
Compiler executable checksum: 68074fcaab9f6b1377b55f7cea05149b
COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64'
 C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/bin/as.exe -v -o C:\Users\rockefel\AppData\Local\Temp\cc81knej.o C:\Users\rockefel\AppData\Local\Temp\ccJnOAyG.s
GNU assembler version 2.36.1 (x86_64-w64-mingw32) using BFD version (GNU Binutils) 2.36.1
COMPILER_PATH=C:/TDM-GCC-64/bin/../libexec/gcc/x86_64-w64-mingw32/10.3.0/;C:/TDM-GCC-64/bin/../libexec/gcc/;C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/bin/
LIBRARY_PATH=C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/;C:/TDM-GCC-64/bin/../lib/gcc/;C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/lib/../lib/;C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../lib/;C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/lib/;C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../
COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64'
 C:/TDM-GCC-64/bin/../libexec/gcc/x86_64-w64-mingw32/10.3.0/collect2.exe -plugin C:/TDM-GCC-64/bin/../libexec/gcc/x86_64-w64-mingw32/10.3.0/liblto_plugin-0.dll -plugin-opt=C:/TDM-GCC-64/bin/../libexec/gcc/x86_64-w64-mingw32/10.3.0/lto-wrapper.exe -plugin-opt=-fresolution=C:\Users\rockefel\AppData\Local\Temp\ccJMLmy0.res -plugin-opt=-pass-through=-lmingw32 -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lpthread -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lkernel32 -plugin-opt=-pass-through=-lmoldname -plugin-opt=-pass-through=-lmingwex -plugin-opt=-pass-through=-lmsvcrt -plugin-opt=-pass-through=-lkernel32 -plugin-opt=-pass-through=-lpthread -plugin-opt=-pass-through=-ladvapi32 -plugin-opt=-pass-through=-lshell32 -plugin-opt=-pass-through=-luser32 -plugin-opt=-pass-through=-lkernel32 -plugin-opt=-pass-through=-lmingw32 -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lpthread -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lkernel32 -plugin-opt=-pass-through=-lmoldname -plugin-opt=-pass-through=-lmingwex -plugin-opt=-pass-through=-lmsvcrt -plugin-opt=-pass-through=-lkernel32 -m i386pep --exclude-libs=libpthread.a --undefined=__xl_f -Bdynamic C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/lib/../lib/crt2.o C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/crtbegin.o -LC:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0 -LC:/TDM-GCC-64/bin/../lib/gcc -LC:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/lib/../lib -LC:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../lib -LC:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/lib -LC:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../.. C:\Users\rockefel\AppData\Local\Temp\cc81knej.o -lmingw32 -lgcc -lpthread -lgcc -lkernel32 -lmoldname -lmingwex -lmsvcrt -lkernel32 -lpthread -ladvapi32 -lshell32 -luser32 -lkernel32 -lmingw32 -lgcc -lpthread -lgcc -lkernel32 -lmoldname -lmingwex -lmsvcrt -lkernel32 C:/TDM-GCC-64/bin/../lib/gcc/x86_64-w64-mingw32/10.3.0/../../../../x86_64-w64-mingw32/lib/../lib/default-manifest.o C:/TDM-GCC-64/bin/../lib/gcc/x866 
4-w64-mingw32/10.3.0/crtend.o
COLLECT_GCC_OPTIONS='-v' '-mtune=generic' '-march=x86-64'
```

## Golang

### go preprocessor ?

[go - Golang Preprocessor like C-style compile switch - Stack Overflow](https://stackoverflow.com/questions/36703867/golang-preprocessor-like-c-style-compile-switch)

go 本身並不包含 preprocessor ，其功用大多被包含在 [build constraints](https://pkg.go.dev/cmd/go#hdr-Build_constraints)裡面。

### go compilation and Assembling

```powershell
go tool compile -S main.go > main.s
```

確切來說 go tool compile 會把這兩個步驟都做完，但是只會輸出 binary的部分，如果要看過程中的 assembly code長怎樣，就得加上 -S 的指令。

### go linking

```bash
go tool link main.o
```

比較特別的是我在main裡面引用官方套件 `fmt` 但是在link的時候並不需要連結`main.o`以外的東西。



### 疑難雜症

[compile command - cmd/compile - Go Packages](https://pkg.go.dev/cmd/compile)

[link command - cmd/link - Go Packages](https://pkg.go.dev/cmd/link)

compile 和 link 這兩個package 的敘述都和我認識的差不多。

但是實際測試起來，在compile 階段，如果source code有引用除了官方套件以外的東西，則可能會發生 `could not import xxx (file not found)` 的錯誤。

但就我所知，compile階段應該不會在意這些參考才對，這些應該是link階段才要做的事情。

這個疑問目前還沒有的到解答，先記著。
