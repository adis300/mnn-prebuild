#!/bin/bash
set -e

# echo yellow
function echo_y () {
    local YELLOW="\033[1;33m"
    local RESET="\033[0m"
    echo -e "${YELLOW}$@${RESET}"
}

ARCH=x86_64

# remove
rm -rf dist/$ARCH
mkdir -p dist/$ARCH

root=$(pwd)/..
cd $root/MNN
rm -rf build

echo_y "\nBuild linux x86 static library"

./schema/generate.sh
mkdir build && cd build


cmake .. -DMNN_BUILD_SHARED_LIBS=ON -DMNN_PORTABLE_BUILD=ON -DMNN_SEP_BUILD=0 -DMNN_BUILD_TEST=1 -DMNN_OPENCL=ON
# cmake .. -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON

make -j4

echo_y "Copy header library"
cd $root
cp -r MNN/include   linux/dist

echo_y "Copy static/dynamic library"
#cp MNN/build/libMNN.a linux/dist/$ARCH
cp MNN/build/libMNN.so linux/dist/$ARCH

echo_y "Build done!"
