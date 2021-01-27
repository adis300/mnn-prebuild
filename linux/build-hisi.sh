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
    echo "USAGE: ./build-hisi.sh [PATH to gcc=hisi toolchain]"
    exit
fi

ARCH=hisi

# remove
rm -rf dist/$ARCH
mkdir -p dist/$ARCH

root=$(pwd)/..
cd $root/MNN
rm -rf build

echo_y "\nBuild linux static library"
export cross_compile_toolchain=$2

GCC_PREFIX=arm-hisiv500-linux


./schema/generate.sh
mkdir build && cd build

cmake .. \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_SYSTEM_VERSION=1 \
    -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON -DMNN_SEP_BUILD=0 \
    -DCMAKE_SYSTEM_PROCESSOR=armv7-a \
    -DCMAKE_C_COMPILER=$cross_compile_toolchain/bin/${GCC_PREFIX}-gcc \
    -DCMAKE_CXX_COMPILER=$cross_compile_toolchain/bin/${GCC_PREFIX}-g++ \
    -mcpu=cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4

make -j4

echo_y "Copy header and static library"
cd $root
cp -r MNN/include   linux/dist

cp MNN/build/libMNN.a linux/dist/$ARCH

echo_y "Build done!"
