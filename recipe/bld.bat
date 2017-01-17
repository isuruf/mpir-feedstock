cd build.vc%VS_MAJOR%

if "%ARCH%"=="32" (
    set PLATFORM=Win32
) else (
    set PLATFORM=x64
)

REM build static library
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=%BUILD_TYPE% lib_mpir_gc\lib_mpir_gc.vcxproj
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=%BUILD_TYPE% lib_mpir_cxx\lib_mpir_cxx.vcxproj
REM build dll library, cxx is also included.
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=%BUILD_TYPE% dll_mpir_gc\dll_mpir_gc.vcxproj

if not exist "%LIBRARY_LIB%" mkdir %LIBRARY_LIB%
if not exist "%LIBRARY_INC%" mkdir %LIBRARY_INC%
if not exist "%LIBRARY_BIN%" mkdir %LIBRARY_BIN%

REM move .lib, .dll and .pdb files to LIBRARY_LIB
move lib_mpir_gc\%PLATFORM%\%BUILD_TYPE%\mpir.lib %LIBRARY_LIB%\mpir_static.lib
move lib_mpir_gc\%PLATFORM%\%BUILD_TYPE%\mpir.pdb %LIBRARY_BIN%\mpir_static.pdb
move lib_mpir_cxx\%PLATFORM%\%BUILD_TYPE%\mpirxx.lib %LIBRARY_LIB%\mpirxx_static.lib
move lib_mpir_cxx\%PLATFORM%\%BUILD_TYPE%\mpirxx.pdb %LIBRARY_BIN%\mpirxx_static.pdb

move dll_mpir_gc\%PLATFORM%\%BUILD_TYPE%\mpir.lib %LIBRARY_LIB%\mpir.lib
move dll_mpir_gc\%PLATFORM%\%BUILD_TYPE%\mpir.dll %LIBRARY_BIN%\mpir.dll
move dll_mpir_gc\%PLATFORM%\%BUILD_TYPE%\mpir.pdb %LIBRARY_BIN%\mpir.pdb

REM create gmp libs to be compatible
copy %LIBRARY_LIB%\mpir_static.lib %LIBRARY_LIB%\gmp_static.lib
copy %LIBRARY_LIB%\mpirxx_static.lib %LIBRARY_LIB%\gmpxx_static.lib
copy %LIBRARY_LIB%\mpir.lib %LIBRARY_LIB%\gmp.lib
copy %LIBRARY_BIN%\mpir.dll %LIBRARY_BIN%\gmp.dll

cd ..
REM move .h files to LIBRARY_INC
move lib\%PLATFORM%\%BUILD_TYPE%\mpir.h %LIBRARY_INC%
move lib\%PLATFORM%\%BUILD_TYPE%\mpirxx.h %LIBRARY_INC%
move lib\%PLATFORM%\%BUILD_TYPE%\gmp.h %LIBRARY_INC%
move lib\%PLATFORM%\%BUILD_TYPE%\gmpxx.h %LIBRARY_INC%

move lib\%PLATFORM%\%BUILD_TYPE%\config.h %LIBRARY_INC%\gmp-config.h
move lib\%PLATFORM%\%BUILD_TYPE%\gmp-impl.h %LIBRARY_INC%
move lib\%PLATFORM%\%BUILD_TYPE%\gmp-mparam.h %LIBRARY_INC%
move lib\%PLATFORM%\%BUILD_TYPE%\longlong.h %LIBRARY_INC%\gmp-longlong.h

dir %LIBRARY_INC%
dir %LIBRARY_LIB%
