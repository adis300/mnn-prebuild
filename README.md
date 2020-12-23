# mnn-prebuild
Prebuild MNN library

# Build converters and trainers
```
cmake . -DMNN_BUILD_TRAIN=ON -DMNN_BUILD_CONVERTER=true -DMNN_BUILD_TRAIN_MINI=OFF -DMNN_USE_OPENCV=OFF -DMNN_BUILD_DEMO=ON -DMNN_PORTABLE_BUILD=ON

cd build && make -j4
```