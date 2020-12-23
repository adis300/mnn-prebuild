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
cd $root/MNN
./schema/generate.sh

# cmake . -MNN_VULKAN=ON -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON && make -j4

echo_y "\nCleaning up ..."
cd project/android
rm -rf build_32 build_64

echo_y "\nBuilding android shared library for 32bit archs"
mkdir build_32 && cd build_32 && ../build_32.sh

echo_y "\nBuilding android shared library for 64bit archs"
cd $root/MNN/project/android
mkdir build_64 && cd build_64 && ../build_64.sh

echo_y "\nCopying files"


echo_y "\nAndroid build finished"


