# Windows rules_cc

This demos changes to the rules based cc toolchain API to enable formatting of environment variables.

This demo downloads a hermetic clang based toolchain and windows "sysroot", sets the appropriate environment variables, and builds hello world in c. This is intended to be a demo to prove the concept of formatting the environment variables, and not an example method for constructing a hermetic windows build. 

Run the example with to ensure the correct include/lib paths are being set in the toolchain:

```
.\bazelw.bat run --copt="-v" --linkopt="-v" :ma
```

Currently only supports windows and aarch64. Example output

```
PS C:\Users\mark\Desktop\windows-rules-based-toolchain-example> .\bazelw.bat run --copt="-v" --linkopt="-v" :main
INFO: Analyzed target //:main (94 packages loaded, 1454 targets configured).
INFO: From Compiling main.c:
clang version 19.1.7
Target: aarch64-pc-windows-msvc
Thread model: posix
InstalledDir: C:\users\mark\_bazel_mark\cq2pxhzm\execroot\_main\external\+_repo_rules+llvm_toolchain\toolchain\bin
 (in-process)
 "C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main\\external\\+_repo_rules+llvm_toolchain\\toolchain\\bin\\clang.exe" -cc1 -triple aarch64-pc-windows-msvc19.43.34810 -emit-obj -mincremental-linker-compatible -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name main.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -relaxed-aliasing -fmath-errno -ffp-contract=on -fno-rounding-math -mconstructor-aliases -funwind-tables=2 -target-cpu generic -target-feature +v8a -target-feature +fp-armv8 -target-feature +neon -target-abi aapcs "-fdebug-compilation-dir=C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main" -v "-fcoverage-compilation-dir=C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main" -resource-dir "C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main\\external\\+_repo_rules+llvm_toolchain\\toolchain\\lib\\clang\\19" -dependency-file bazel-out/arm64_windows-fastbuild/bin/_objs/main/main.d -MT bazel-out/arm64_windows-fastbuild/bin/_objs/main/main.o -sys-header-deps -iquote . -iquote bazel-out/arm64_windows-fastbuild/bin -iquote external/bazel_tools -iquote bazel-out/arm64_windows-fastbuild/bin/external/bazel_tools -internal-isystem "C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main\\external\\+_repo_rules+llvm_toolchain\\toolchain\\lib\\clang\\19\\include" -internal-isystem external/+_repo_rules+llvm_toolchain/sysroot/include -ferror-limit 19 -fno-use-cxa-atexit -fms-extensions -fms-compatibility -fms-compatibility-version=19.43.34810 -fskip-odr-check-in-gmf -fdelayed-template-parsing -target-feature -fmv -faddrsig -o bazel-out/arm64_windows-fastbuild/bin/_objs/main/main.o -x c main.c
clang -cc1 version 19.1.7 based upon LLVM 19.1.7 default target aarch64-pc-windows-msvc
ignoring nonexistent directory "bazel-out/arm64_windows-fastbuild/bin/external/bazel_tools"
#include "..." search starts here:
 .
 bazel-out/arm64_windows-fastbuild/bin
 external/bazel_tools
#include <...> search starts here:
 C:\users\mark\_bazel_mark\cq2pxhzm\execroot\_main\external\+_repo_rules+llvm_toolchain\toolchain\lib\clang\19\include
 external/+_repo_rules+llvm_toolchain/sysroot/include
End of search list.
INFO: From Linking main:
clang version 19.1.7
Target: aarch64-pc-windows-msvc
Thread model: posix
InstalledDir: C:\users\mark\_bazel_mark\cq2pxhzm\execroot\_main\external\+_repo_rules+llvm_toolchain\toolchain\bin
 "C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main\\external\\+_repo_rules+llvm_toolchain\\toolchain\\bin\\lld-link" -out:bazel-out/arm64_windows-fastbuild/bin/main -defaultlib:libcmt -defaultlib:oldnames "-libpath:C:\\users\\mark\\_bazel_mark\\cq2pxhzm\\execroot\\_main\\external\\+_repo_rules+llvm_toolchain\\toolchain\\lib\\clang\\19\\lib\\windows" -nologo bazel-out/arm64_windows-fastbuild/bin/_objs/main/main.o -S
lld-link: warning: ignoring unknown argument '-S'
INFO: Found 1 target...
Target //:main up-to-date:
  bazel-bin/main                                                                                                                                    
INFO: Elapsed time: 0.928s, Critical Path: 0.23s
INFO: 6 processes: 4 internal, 2 local.                                                                                                             
INFO: Build completed successfully, 6 total actions                                                                                                 
INFO: Running command line: bazel-bin/main
Hello, World!
```