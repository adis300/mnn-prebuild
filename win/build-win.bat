
set SCRIPT_DIR=%cd%
set ROOT_DIR=%cd%\..

cd %ROOT_DIR%\MNN
powershell ./schema/generate.ps1
mkdir build
cd build
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release 
 -DMNN_PORTABLE_BUILD=ON -DMNN_SEP_BUILD=0
 -DMNN_BUILD_SHARED_LIBS=OFF

::xcopy /y build\shared\out\*                     dist\shared
 