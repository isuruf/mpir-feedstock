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


msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Release lib_mpir_gc\lib_mpir_gc.vcxproj
msbuild.exe /p:Platform=%PLATFORM% /p:Configuration=Release lib_mpir_cxx\lib_mpir_cxx.vcxproj

if not exist "%LIBRARY_LIB%" mkdir %LIBRARY_LIB%
if not exist "%LIBRARY_INC%" mkdir %LIBRARY_INC%

cd ..

REM move .lib and .pdb files to LIBRARY_LIB
move lib\%PLATFORM%\Release\mpir.lib %LIBRARY_LIB%\mpir.lib
move lib\%PLATFORM%\Release\mpir.pdb %LIBRARY_LIB%\mpir.pdb
move lib\%PLATFORM%\Release\mpirxx.lib %LIBRARY_LIB%\mpirxx.lib
move lib\%PLATFORM%\Release\mpirxx.pdb %LIBRARY_LIB%\mpirxx.pdb

REM create gmp libs to be compatible
copy %LIBRARY_LIB%\mpir.lib %LIBRARY_LIB%\gmp.lib
copy %LIBRARY_LIB%\mpirxx.lib %LIBRARY_LIB%\gmpxx.lib

REM move .h files to LIBRARY_INC
move lib\%PLATFORM%\Release\* %LIBRARY_INC%

dir %LIBRARY_INC%
dir %LIBRARY_LIB%

:TRIM
  SetLocal EnableDelayedExpansion
  set Params=%*
  for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
  exit /B
