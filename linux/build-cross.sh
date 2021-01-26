#!/bin/bash
set -e

# echo yellow
function echo_y () {
    local YELLOW="\033[1;33m"
    local RESET="\033[0m"
    echo -e "${YELLOW}$@${RESET}"
}

if [ $# -ne 2 ]
then
    echo "USAGE: ./build-with-gcc.sh [architecuture(arm/aarch64)] [PATH to gcc=linaro toolchain]"
    exit
fi

ARCH=$1

# remove
rm -rf dist/$ARCH
mkdir -p dist/$ARCH

root=$(pwd)/..
cd $root/MNN
rm -rf build

echo_y "\nBuild linux static library"
export cross_compile_toolchain=$2

if [ $ARCH = 'arm' ]; then
	GCC_PREFIX=arm-linux-gnueabihf
elif [ $ARCH = 'aarch64' ]; then
    GCC_PREFIX=aarch64-linux-gnu
else
    echo "ERROR: Unsupported arch:${ARCH}"
fi

./schema/generate.sh
mkdir build && cd build

cmake .. \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_VERSION=1 \
    -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON -DMNN_SEP_BUILD=0 \
    -DCMAKE_SYSTEM_PROCESSOR=$ARCH \
    -DCMAKE_C_COMPILER=$cross_compile_toolchain/bin/${GCC_PREFIX}-gcc \
    -DCMAKE_CXX_COMPILER=$cross_compile_toolchain/bin/${GCC_PREFIX}-g++

make -j4

echo_y "Copy header and static library"
cd $root
cp -r MNN/include   linux/dist

cp MNN/build/libMNN.a linux/dist/$ARCH

echo_y "Build done!"
