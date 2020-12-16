#!/bin/bash

set -e

# echo yellow
function echo_y () {
    local YELLOW="\033[1;33m"
    local RESET="\033[0m"
    echo -e "${YELLOW}$@${RESET}"
}

# remove
rm -rf include shared static
mkdir include shared static 

root=$(pwd)/..
cd $root
cd MNN
rm -rf build

echo_y "\nBuild shared and static library"
./schema/generate.sh
mkdir build && cd build && cmake .. -DMNN_METAL=OFF && make -j4 #-DMNN_OPENCL=ON
cmake .. -DMNN_METAL=OFF -DMNN_BUILD_SHARED_LIBS=OFF && make -j4

echo_y "copy header and static library"
cd $root
cp -r MNN/include/MNN/*   mac/include
cp MNN/build/libMNN.a mac/static
# cp MNN/build/mnn.metallib mac/static

echo_y "copy shared library"
cp MNN/build/libMNN.dylib mac/shared
# cp MNN/build/source/backend/opencl/libMNN_CL.dylib mac/shared
cp MNN/build/express/libMNN_Express.dylib mac/shared

