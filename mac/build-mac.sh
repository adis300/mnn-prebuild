#!/bin/bash

set -e

# echo yellow
function echo_y () {
    local YELLOW="\033[1;33m"
    local RESET="\033[0m"
    echo -e "${YELLOW}$@${RESET}"
}

# remove
rm -rf dist
mkdir dist

root=$(pwd)/..
cd $root
cd MNN
rm -rf build

echo_y "\nBuild shared and static library"
./schema/generate.sh
mkdir build && cd build && cmake .. -DMNN_METAL=ON -DMNN_PORTABLE_BUILD=ON -DMNN_SEP_BUILD=0 && make -j4 #-DMNN_OPENCL=ON
cmake .. -DMNN_METAL=ON -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON && make -j4

# option(MNN_ARM82 "Enable ARM82" ON)

echo_y "copy header and static library"
cd $root
cp -r MNN/include   mac/dist/
cp MNN/build/mnn.metallib mac/dist

cp MNN/build/libMNN.a mac/dist

echo_y "copy shared library"
cp MNN/build/libMNN.dylib mac/dist

# cp MNN/build/source/backend/opencl/libMNN_CL.dylib mac/shared
# cp MNN/build/express/libMNN_Express.dylib mac/shared

