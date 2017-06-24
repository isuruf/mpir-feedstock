REM write a temporary batch file to map cl.exe version to visual studio version
echo @echo 16=10>> msvc_versions.bat
echo @echo 19=14>> msvc_versions.bat

REM Run cl.exe to find which version our compiler is
for /f "delims=" %%A in ('cl /? 2^>^&1 ^| findstr /C:"Version"') do set "CL_TEXT=%%A"
FOR /F "tokens=1,2 delims==" %%i IN ('msvc_versions.bat') DO echo %CL_TEXT% | findstr /C:"Version %%i" > nul && set VSTRING=%%j && goto FOUND
EXIT 1
:FOUND

REM Trim trailing whitespace that may prevent CMake from finding which generator to use
call :TRIM VSTRING %VSTRING%

cd build.vc%VSTRING%

if "%ARCH%"=="32" (
    set PLATFORM=Win32
) else (
    set PLATFORM=x64
)

REM build static library
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Debug lib_mpir_gc\lib_mpir_gc.vcxproj
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Debug lib_mpir_cxx\lib_mpir_cxx.vcxproj
REM build dll library, cxx is also included.
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Debug dll_mpir_gc\dll_mpir_gc.vcxproj

if not exist "%LIBRARY_LIB%" mkdir %LIBRARY_LIB%
if not exist "%LIBRARY_INC%" mkdir %LIBRARY_INC%
if not exist "%LIBRARY_BIN%" mkdir %LIBRARY_BIN%

REM move .lib, .dll and .pdb files to LIBRARY_LIB
move lib_mpir_gc\%PLATFORM%\Debug\mpir.lib %LIBRARY_LIB%\mpir_static.lib
move lib_mpir_gc\%PLATFORM%\Debug\mpir.pdb %LIBRARY_BIN%\mpir_static.pdb
move lib_mpir_cxx\%PLATFORM%\Debug\mpirxx.lib %LIBRARY_LIB%\mpirxx_static.lib
move lib_mpir_cxx\%PLATFORM%\Debug\mpirxx.pdb %LIBRARY_BIN%\mpirxx_static.pdb

move dll_mpir_gc\%PLATFORM%\Debug\mpir.lib %LIBRARY_LIB%\mpir.lib
move dll_mpir_gc\%PLATFORM%\Debug\mpir.dll %LIBRARY_BIN%\mpir.dll
move dll_mpir_gc\%PLATFORM%\Debug\mpir.pdb %LIBRARY_BIN%\mpir.pdb

REM create gmp libs to be compatible
copy %LIBRARY_LIB%\mpir_static.lib %LIBRARY_LIB%\gmp_static.lib
copy %LIBRARY_LIB%\mpirxx_static.lib %LIBRARY_LIB%\gmpxx_static.lib
copy %LIBRARY_LIB%\mpir.lib %LIBRARY_LIB%\gmp.lib
copy %LIBRARY_BIN%\mpir.dll %LIBRARY_BIN%\gmp.dll

cd ..
REM move .h files to LIBRARY_INC
move lib\%PLATFORM%\Debug\mpir.h %LIBRARY_INC%
move lib\%PLATFORM%\Debug\mpirxx.h %LIBRARY_INC%
move lib\%PLATFORM%\Debug\gmp.h %LIBRARY_INC%
move lib\%PLATFORM%\Debug\gmpxx.h %LIBRARY_INC%

move lib\%PLATFORM%\Debug\config.h %LIBRARY_INC%\gmp-config.h
move lib\%PLATFORM%\Debug\gmp-impl.h %LIBRARY_INC%
move lib\%PLATFORM%\Debug\gmp-mparam.h %LIBRARY_INC%
move lib\%PLATFORM%\Debug\longlong.h %LIBRARY_INC%\gmp-longlong.h

dir %LIBRARY_INC%
dir %LIBRARY_LIB%

:TRIM
  SetLocal EnableDelayedExpansion
  set Params=%*
  for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
  exit /B

