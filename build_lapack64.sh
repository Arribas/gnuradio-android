set -xe
# Adjust the paths!
export ANDROIDSDK="/home/android/Android/Sdk"
export ANDROIDNDK="/home/android/Android/Sdk/ndk/21.3.6528147"
export ANDROIDAPI="29"  # Target API version of your application
export NDKAPI="21"  # Minimum supported API version of your application
export ANDROIDNDKVER="r21e"  # Version of the NDK you installed

export FC="/home/android/Android/Sdk/ndk/21.3.6528147/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-gfortran"

export ANDROID_ABI=arm64-v8a
export TOOLCHAIN_ROOT=${ANDROIDNDK}
export HOST_ARCH=linux-x86_64
export ANDROID_TOOLCHAIN=gcc

#############################################################
### DERIVED CONFIG
#############################################################
export SYS_ROOT=${TOOLCHAIN_ROOT}/sysroot
export TOOLCHAIN_BIN=${TOOLCHAIN_ROOT}/toolchains/aarch64-linux-android-4.9/prebuilt/${HOST_ARCH}/bin

export API_LEVEL=29
export PATH=${TOOLCHAIN_BIN}:${PATH}
export BUILD_ROOT=$(dirname $(readlink -f "$0"))
export PREFIX=${BUILD_ROOT}/toolchain/arm64-v8a
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export NCORES=$(getconf _NPROCESSORS_ONLN)

#build lapack

rm lapack64 -rf
git clone https://github.com/Reference-LAPACK/lapack-release.git lapack64
cd lapack64
cp INSTALL/second_NONE.f INSTALL/second_.f
cp INSTALL/dsecnd_NONE.f INSTALL/dsecnd_.f
mkdir build
cd build
cmake -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_FIND_ROOT_PATH=${PREFIX} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_ROOT}/build/cmake/android.toolchain_r17c.cmake -DANDROID_ABI=${ANDROID_ABI} -DANDROID_ARM_NEON=ON -DANDROID_NATIVE_API_LEVEL=${NDKAPI} -DBUILD_SHARED_LIBS=true ../
make -j${NCORES}
make install