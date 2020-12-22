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
mkdir -p dist/include

root=$(pwd)/..
cd $root
cd MNN
rm -rf build

echo_y "\nBuild shared and static library"
./schema/generate.sh
mkdir build
cd build

#ARCHS="arm64 arm64e "
#for ARCH in ${ARCHS}
#do
#done

mkdir ios_arm64
cd ios_arm64
cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../../cmake/ios.toolchain.cmake -DMNN_METAL=ON -DARCHS="arm64;arm64e" -DENABLE_BITCODE=0 -DMNN_AAPL_FMWK=0 -DMNN_SEP_BUILD=0 -DMNN_BUILD_SHARED_LIBS=OFF -G Xcode
echo "Building arm64"
xcodebuild ONLY_ACTIVE_ARCH=NO -configuration Release -scheme MNN -target MNN -sdk iphoneos -quiet DEVELOPMENT_TEAM=TG5E95RU8K
echo "End Building arm64"

cd $root
cp -rf MNN/build/ios_arm64/Release-iphoneos/Headers/* ios/dist/include
cp MNN/build/ios_arm64/Release-iphoneos/libMNN.a ios/dist/libMNN-iphoneos.a
cp MNN/build/ios_arm64/Release-iphoneos/mnn.metallib ios/dist/mnn.metallib

cd MNN/build
mkdir ios_x86_64
cd ios_x86_64
cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../../cmake/ios.toolchain.cmake -DMNN_METAL=ON -DARCHS="x86_64" -DENABLE_BITCODE=0 -DMNN_AAPL_FMWK=0 -DMNN_SEP_BUILD=0 -DMNN_BUILD_SHARED_LIBS=OFF -G Xcode
echo "Building x86_64"
xcodebuild ONLY_ACTIVE_ARCH=NO -configuration Release -scheme MNN -target MNN -sdk iphonesimulator -quiet DEVELOPMENT_TEAM=TG5E95RU8K
echo "End Building x86_64"

cd $root
cp MNN/build/ios_x86_64/Release-iphonesimulator/libMNN.a ios/dist/libMNN-iphonesimulator.a
cp MNN/build/ios_x86_64/Release-iphonesimulator/mnn.metallib ios/dist/mnn.metallib



# MNN/project/ios/MNN.xcodeproj

#mkdir build && cd build && cmake .. -DMNN_METAL=OFF && make -j4 #-DMNN_OPENCL=ON
#cmake .. -DMNN_METAL=OFF -DMNN_BUILD_SHARED_LIBS=OFF && make -j4

#echo_y "copy header and static library"
#cd $root
#cp -r MNN/include/MNN/*   mac/include
#cp MNN/build/libMNN.a mac/static
# cp MNN/build/mnn.metallib mac/static

#echo_y "copy shared library"
#cp MNN/build/libMNN.dylib mac/shared
# cp MNN/build/source/backend/opencl/libMNN_CL.dylib mac/shared
#cp MNN/build/express/libMNN_Express.dylib mac/shared

