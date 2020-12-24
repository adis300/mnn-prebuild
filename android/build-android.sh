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

ARCHS="armeabi-v7a arm64-v8a x86 x86_64"

echo_y "\nCleaning up ..."
for ARCH in ${ARCHS}
do
    echo_y "\nBuilding android library for ${ARCH}"
    rm -rf $root/android/build_${ARCH}
    mkdir $root/android/build_${ARCH}
    cd $root/android/build_${ARCH}
    cmake $root/MNN \
        -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_ABI=${ARCH} \
        -DANDROID_STL=c++_static \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_NATIVE_API_LEVEL=android-21  \
        -DANDROID_TOOLCHAIN=clang \
        -DMNN_USE_LOGCAT=false \
        -DMNN_SEP_BUILD=0 -DMNN_BUILD_SHARED_LIBS=OFF \
        -DMNN_VULKAN=true \
        -DMNN_BUILD_FOR_ANDROID_COMMAND=true \
        -DNATIVE_LIBRARY_OUTPUT=. -DNATIVE_INCLUDE_OUTPUT=. $1 $2 $3

    make -j4

done
#rm -rf build_32 build_64

#echo_y "\nBuilding android shared library for 32bit archs"
#mkdir build_32 && cd build_32


echo_y "\nBuilding android shared library for 64bit archs"
#cd $root/MNN/project/android
#mkdir build_64 && cd build_64 && ../build_64.sh

echo_y "\nCopying files"


echo_y "\nAndroid build finished"


