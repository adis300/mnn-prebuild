# mnn-prebuild
Prebuild MNN library

# Build converters and trainers
```
cmake . -DMNN_BUILD_TRAIN=ON -DMNN_BUILD_CONVERTER=true -DMNN_BUILD_TRAIN_MINI=OFF -DMNN_USE_OPENCV=OFF -DMNN_BUILD_DEMO=ON -DMNN_PORTABLE_BUILD=ON

cd build && make -j4
```

# Build for windows
```
install choco at `https://chocolatey.org/install`
choco install cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install ninja -y

In powershell with admin access
Set-ExecutionPolicy unrestricted
```
