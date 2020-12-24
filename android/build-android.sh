#!/bin/bash
set -e
# echo yellow
function echo_y () {
    local YELLOW="\033[1;33m"
    local RESET="\033[0m"
    echo -e "${YELLOW}$@${RESET}"
}

# 2. check NDK
if [ -z "$ANDROID_NDK" ]; then
    echo_r "[android] environment variable 'ANDROID_NDK' need to be setup"
    exit 1
fi

# remove
rm -rf dist
mkdir dist

root=$(pwd)/..
cd $root/MNN
./schema/generate.sh

# cmake . -MNN_VULKAN=ON -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_PORTABLE_BUILD=ON && make -j4

ARCHS="armeabi-v7a arm64-v8a x86_64 " 

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
        -DMNN_USE_LOGCAT=false  \
        -DMNN_SEP_BUILD=0  \
        -DMNN_BUILD_SHARED_LIBS=OFF  -DMNN_VULKAN=OFF \
        -DMNN_BUILD_FOR_ANDROID_COMMAND=true \
        -DNATIVE_LIBRARY_OUTPUT=. -DNATIVE_INCLUDE_OUTPUT=. $1 $2 $3

    make -j4
    mv libMNN.a $root/android/dist/libMNN-${ARCH}.a

    cmake $root/MNN \
        -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_ABI=${ARCH} \
        -DANDROID_STL=c++_static \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_NATIVE_API_LEVEL=android-21  \
        -DANDROID_TOOLCHAIN=clang \
        -DMNN_USE_LOGCAT=false  \
        -DMNN_SEP_BUILD=0  \
        -DMNN_BUILD_SHARED_LIBS=ON  -DMNN_VULKAN=OFF \
        -DMNN_BUILD_FOR_ANDROID_COMMAND=true \
        -DNATIVE_LIBRARY_OUTPUT=. -DNATIVE_INCLUDE_OUTPUT=. $1 $2 $3

    make -j4
    mv libMNN.so $root/android/dist/libMNN-${ARCH}.so

    echo_y "\nBuilding android Vulkan library for ${ARCH}"
    cmake $root/MNN \
        -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_ABI=${ARCH} \
        -DANDROID_STL=c++_static \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_NATIVE_API_LEVEL=android-21  \
        -DANDROID_TOOLCHAIN=clang \
        -DMNN_USE_LOGCAT=false  \
        -DMNN_SEP_BUILD=0  \
        -DMNN_BUILD_SHARED_LIBS=OFF -DMNN_VULKAN=ON \
        -DMNN_BUILD_FOR_ANDROID_COMMAND=true \
        -DNATIVE_LIBRARY_OUTPUT=. -DNATIVE_INCLUDE_OUTPUT=. $1 $2 $3
    make -j4
    mv libMNN.a $root/android/dist/libMNN_Vulkan-${ARCH}.a

    echo_y "\nBuilding android Vulkan shared library for ${ARCH}"
    cmake $root/MNN \
        -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_ABI=${ARCH} \
        -DANDROID_STL=c++_static \
        -DCMAKE_BUILD_TYPE=Release \
        -DANDROID_NATIVE_API_LEVEL=android-21  \
        -DANDROID_TOOLCHAIN=clang \
        -DMNN_USE_LOGCAT=false  \
        -DMNN_SEP_BUILD=0  \
        -DMNN_BUILD_SHARED_LIBS=ON -DMNN_VULKAN=ON \
        -DMNN_BUILD_FOR_ANDROID_COMMAND=true \
        -DNATIVE_LIBRARY_OUTPUT=. -DNATIVE_INCLUDE_OUTPUT=. $1 $2 $3
    make -j4
    mv libMNN.so $root/android/dist/libMNN_Vulkan-${ARCH}.so

    cd $root/android
    rm -rf build_$ARCH
done
#rm -rf build_32 build_64

echo_y "\nAndroid build finished"


