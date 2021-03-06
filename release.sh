#!/bin/bash
set -e
cd ${0%/*}
os=$(uname)
ROOT_DIR=$(pwd)

# colorful echo functions
function echo_y() { echo -e "\033[1;33m$@\033[0m" ; }   # yellow
function echo_r() { echo -e "\033[0;31m$@\033[0m" ; }   # red

# create release folder
rm -rf release
mkdir -p release/include/MNN

# mnn version
cd ${ROOT_DIR}/MNN
MNN_VERSION=$(git rev-parse --short HEAD)

# copy header and libraries to release folder
echo_y "copy header and libraries to release folder"
cd ${ROOT_DIR}
echo $MNN_VERSION > release/MNN_VERSION
cp -rf ios/dist/include/*   release/include/MNN

cd release
zip -r -X include.zip include
rm -rf include
cd ${ROOT_DIR}

if [ "$os" == "Darwin" ]; then
    echo_y "Releasing: mac libraries"
    cp -v mac/dist/libMNN.dylib     release/libMNN-mac-x86_64.dylib
    cp -v mac/dist/libMNN.a     release/libMNN-mac-x86_64.a
    cp -v mac/dist/mnn.metallib     release/mnn-mac.metallib
    
    echo_y "Releasing: iOS libraries"
    cp -v ios/dist/libMNN-iphoneos.a  release/
    cp -v ios/dist/libMNN-iphonesimulator.a  release/
    cp -v ios/dist/mnn.metallib release/mnn-ios.metallib
    
    echo_y "Releasing: Android libraries"
    ARCHS="armeabi-v7a arm64-v8a x86_64"
    for ARCH in ${ARCHS}
    do
    cp -v android/dist/libMNN-${ARCH}.a     release/libMNN-android-${ARCH}.a
    cp -v android/dist/libMNN-${ARCH}.so    release/libMNN-android-${ARCH}.so
    cp -v android/dist/libMNN_Vulkan-${ARCH}.a     release/libMNN_Vulkan-android-${ARCH}.a
    cp -v android/dist/libMNN_Vulkan-${ARCH}.so    release/libMNN_Vulkan-android-${ARCH}.so
    done
elif [ "$os" == "Linux" ]; then
    echo "Write linux"
    #cp -v linux/dist/shared/libmxnet_predict.so  release/libmxnet_predict-linux-x86_64.so
    #cp -v linux/dist/static/libmxnet_predict.a   release/libmxnet_predict-linux-x86_64.a
fi
