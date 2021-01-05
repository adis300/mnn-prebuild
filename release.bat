rmdir /s /q release
mkdir release

copy /y win\dist\x64\MNN.dll  release\MNN-win_x64.dll
copy /y win\dist\x64\MNN.lib  release\MNN-win_x64.lib

copy /y win\dist\x86\MNN.dll  release\MNN-win_x86.dll
copy /y win\dist\x86\MNN.lib  release\MNN-win_x86.lib