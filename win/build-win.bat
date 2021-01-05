
@echo off
setlocal
cd %~dp0

set SCRIPT_DIR=%cd%

rmdir /s /q dist
mkdir dist\x64 dist\x86
set ROOT_DIR=%cd%\..

goto :main


:: echo_y function
:echo_y
    echo.
    echo [93m%*[0m
goto :eof

:: set Microsoft Visual C++ environment
:msvc_env
    :: 1. add Microsoft Visual Studio\Installer to PATH
    set "PATH=%PATH%;%ProgramFiles(x86)%\Microsoft Visual Studio\Installer"
    set "PATH=%PATH%;%ProgramFiles%\Microsoft Visual Studio\Installer"

    :: 2. check vswhere
    where vswhere >nul 2>&1 || (
        call :echo_r [win] command 'vswhere' is not found
        exit /b 1
    )

    :: 3. execute Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat
    for /f "usebackq tokens=*" %%i in (`vswhere -property installationPath`) do (
        call :echo_y [win] Run '%%i\VC\Auxiliary\Build\vcvarsall.bat %*'
        %%i\VC\Auxiliary\Build\vcvarsall.bat %*
        call :echo_y [win] Environment initialized for:'%*'
    )
goto :eof

:build
    :: enable MSVC
    call :msvc_env %*
    
    cd %ROOT_DIR%\MNN

    :: clean
    rmdir /s /q build
    powershell ./schema/generate.ps1
    mkdir build
    
    :: 1. build static library
    call :echo_y [win][static] build static library
    cd build
    cmake -S %ROOT_DIR%\MNN -B . -G "Ninja" -D CMAKE_BUILD_TYPE=Release -D MNN_PORTABLE_BUILD=ON -D MNN_SEP_BUILD=0 -D MNN_BUILD_SHARED_LIBS=OFF
    Ninja

    move MNN.lib %SCRIPT_DIR%\dist\%*

    cmake -S %ROOT_DIR%\MNN -B . -G "Ninja" -D CMAKE_BUILD_TYPE=Release -D MNN_PORTABLE_BUILD=ON -D MNN_SEP_BUILD=0 -D MNN_BUILD_SHARED_LIBS=ON
    Ninja
    move MNN.dll %SCRIPT_DIR%\dist\%*
goto :eof

:: main
:main
    call :build x86
    call :build x64    
goto :eof