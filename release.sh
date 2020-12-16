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
mkdir -p release/include

# mnn version
cd ${ROOT_DIR}/MNN
MNN_VERSION=$(git rev-parse --short HEAD)

# copy header and libraries to release folder
echo_y "copy header and libraries to release folder"
cd ${ROOT_DIR}
echo $MNN_VERSION > release/MNN_VERSION
cp -r MNN/include/*   release/include

if [ "$os" == "Darwin" ]; then
    cp -v mac/shared/libMNN.dylib     release/libMNN-osx-x86_64.dylib
    cp -v mac/static/libMNN.a     release/libMNN-osx-x86_64.a
    #cp -v ios/dist/*                            release/
    #cp -v android/dist/*                        release/

elif [ "$os" == "Linux" ]; then
    echo "Write linux"
    #cp -v linux/dist/shared/libmxnet_predict.so  release/libmxnet_predict-linux-x86_64.so
    #cp -v linux/dist/static/libmxnet_predict.a   release/libmxnet_predict-linux-x86_64.a
fi
