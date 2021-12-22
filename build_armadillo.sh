set -xe
# Adjust the paths!
export ANDROIDSDK="/home/android/Android/Sdk"
export ANDROIDNDK="/home/android/Android/Sdk/ndk/21.3.6528147"
export ANDROIDAPI="27"  # Target API version of your application
export NDKAPI="21"  # Minimum supported API version of your application
export ANDROIDNDKVER="r21e"  # Version of the NDK you installed

export FC="/home/android/Android/Sdk/ndk/21.3.6528147/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gfortran"

export ANDROID_ABI=armeabi-v7a
export TOOLCHAIN_ROOT=${ANDROIDNDK}
export HOST_ARCH=linux-x86_64
export ANDROID_TOOLCHAIN=clang

#############################################################
### DERIVED CONFIG
#############################################################
export SYS_ROOT=${TOOLCHAIN_ROOT}/sysroot
export TOOLCHAIN_BIN=${TOOLCHAIN_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/${HOST_ARCH}/bin

export API_LEVEL=27
export PATH=${TOOLCHAIN_BIN}:${PATH}
export BUILD_ROOT=$(dirname $(readlink -f "$0"))
export PREFIX=${BUILD_ROOT}/toolchain/armeabi-v7a
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export NCORES=$(getconf _NPROCESSORS_ONLN)

#build armadillo

rm armadillo -rf
git clone https://gitlab.com/conradsnicta/armadillo-code.git armadillo
cd armadillo
mkdir build
cd build
cmake -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_FIND_ROOT_PATH=${PREFIX} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_ROOT}/build/cmake/android.toolchain.cmake -DANDROID_ABI=${ANDROID_ABI} -DANDROID_ARM_NEON=ON -DANDROID_NATIVE_API_LEVEL=${NDKAPI} -DDETECT_HDF5=false  ../
make -j${NCORES}
make install
