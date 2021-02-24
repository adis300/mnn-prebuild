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

echo_y "Generating project"
./schema/generate.sh
mkdir build && cd build

echo_y "Build linux x86 static library"
cmake .. -DMNN_BUILD_CONVERTER=true -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON -DMNN_OPENCL=ON -DMNN_VULKAN=ON -DMNN_USE_SYSTEM_LIB=ON
make -j4
echo_y "Copy static library"
cp $root/MNN/build/libMNN.a $root/linux/dist/$ARCH
cp $root/MNN/build/MNNConvert $root/linux/dist/$ARCH

echo_y "Build linux x86 shared library"
#cmake .. -DMNN_BUILD_SHARED_LIBS=ON -DMNN_PORTABLE_BUILD=ON -DMNN_SEP_BUILD=0 -DMNN_OPENCL=ON
#make -j4
#echo_y "Copy shared library"
#cp $root/MNN/build/libMNN.so $root/linux/dist/$ARCH

echo_y "Copy header library"
cd $root
cp -r MNN/include   linux/dist


echo_y "Build done!"
