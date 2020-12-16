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
mkdir dist/include

root=$(pwd)/..
cd $root
cd MNN
#rm -rf build

echo_y "\nBuild shared and static library"
./schema/generate.sh
mkdir build && cd build && cmake .. -DMNN_METAL=ON && make -j4
cmake .. -DMNN_METAL=ON -DMNN_BUILD_SHARED_LIBS=OFF && make -j4

echo_y "copy header and shared library"
cd $root
cp -r MNN/include/MNN/*   mac/dist/include
cp MNN/build/libMNN.a mac/dist
cp MNN/build/libMNN.dylib mac/dist
cp MNN/build/mnn.metallib mac/dist
cp MNN/build/express/libMNN_Express.dylib mac/dist

echo_y "copy static library"
