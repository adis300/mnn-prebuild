* Linaro cross compiler toolchain downloads
https://www.linaro.org/downloads/
* 32bit ArmV7
https://releases.linaro.org/components/toolchain/binaries/latest-7/arm-linux-gnueabihf/
* 32bit ArmV8
https://releases.linaro.org/components/toolchain/binaries/latest-7/armv8l-linux-gnueabihf/
* 64bit ArmV8
https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/

# Install pre-requisites
```
(Optional)
sudo apt-get install ant libprotobuf-dev libvulkan-dev libglew-dev freeglut3-dev protobuf-compiler ocl-icd-opencl-dev libglfw3-devD
```
# Sample build command
```
./build-x86_64.sh
./build-cross.sh arm $HOME/work/linaro/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf
./build-cross.sh aarch64 $HOME/work/linaro/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu

```

# Installing OpenCL
https://github.com/intel/compute-runtime/blob/master/opencl/doc/DISTRIBUTIONS.md