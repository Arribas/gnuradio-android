set -xe
# Adjust the paths!
export ANDROIDSDK="/home/android/Android/Sdk"
export ANDROIDNDK="/home/android/Android/Sdk/ndk/21.3.6528147"
export ANDROIDAPI="29"  # Target API version of your application
export NDKAPI="21"  # Minimum supported API version of your application
export ANDROIDNDKVER="r21e"  # Version of the NDK you installed

export ANDROID_ABI=arm64-v8a
export TOOLCHAIN_ROOT=${ANDROIDNDK}
export HOST_ARCH=linux-x86_64
export ANDROID_TOOLCHAIN=clang

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

#build gnss-sdr
#if [ ! -f "${PREFIX}/include/boost" ]; then
#	ln -s ${PREFIX}/include/boost-1_69/boost/ ${PREFIX}/include/boost
#fi

rm gnss-sdr-android -rf
git clone https://github.com/gnss-sdr/gnss-sdr.git gnss-sdr-android

cd gnss-sdr-android
git checkout android


#build gnss-sdr VOLK

#rm -rf ${BUILD_ROOT}/gnss-sdr/src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/build64/
#mkdir ${BUILD_ROOT}/gnss-sdr/src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/build64/
#cd ${BUILD_ROOT}/gnss-sdr/src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/build64/

rm -rf src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/build64/
mkdir src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/build64/
cd src/algorithms/libs/volk_gnsssdr_module/volk_gnsssdr/build64/

cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_ROOT}/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a -DANDROID_ARM_NEON=ON \
  -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
  -DANDROID_STL=c++_shared \
  -DBOOST_ROOT=${PREFIX} \
  -DBoost_COMPILER=-clang \
  -DBoost_USE_STATIC_LIBS=ON \
  -DBoost_ARCHITECTURE=-a64 \
  -DCMAKE_FIND_ROOT_PATH=${PREFIX} \
  -DENABLE_OWN_CPUFEATURES=ON \
  ../


make -j${NCORES}
make install


#build gnss-sdr

cd ${BUILD_ROOT}/gnss-sdr-android

rm build64 -rf
mkdir build64
cd build64

#cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
#  -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_ROOT}/build/cmake/android.toolchain.cmake \
#  -DANDROID_ABI=arm64-v8a -DANDROID_ARM_NEON=ON \
#  -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
#  -DANDROID_STL=c++_shared \
#  -DBOOST_ROOT=${PREFIX} \
#  -DBoost_DEBUG=OFF \
#  -DBoost_COMPILER=-clang \
#  -DBoost_USE_STATIC_LIBS=ON \
#  -DBoost_USE_DEBUG_LIBS=OFF \
#  -DBoost_ARCHITECTURE=-a64 \
#  -DGnuradio_DIR=${BUILD_ROOT}/toolchain/arm64-v8a/lib/cmake/gnuradio \
#  -DCMAKE_FIND_ROOT_PATH=${PREFIX} \
#  -DGFLAGS_ROOT=${PREFIX} \
#  -DGLOG_ROOT=${PREFIX} \
#  -DENABLE_UNIT_TESTING=OFF \
#  ../

export GTEST_DIR=${BUILD_ROOT}/gtest64

cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_ROOT}/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a -DANDROID_ARM_NEON=ON \
  -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
  -DANDROID_STL=c++_shared \
  -DBOOST_ROOT=${PREFIX} \
  -DBoost_DEBUG=OFF \
  -DBoost_COMPILER=-clang \
  -DBoost_USE_STATIC_LIBS=ON \
  -DBoost_USE_DEBUG_LIBS=OFF \
  -DBoost_ARCHITECTURE=-a64 \
  -DCMAKE_FIND_ROOT_PATH=${PREFIX} \
  -DGFLAGS_ROOT=${PREFIX} \
  -DGLOG_ROOT=${PREFIX} \
  -DENABLE_UNIT_TESTING=OFF \
  -DENABLE_OSMOSDR=ON \
  ../

make -j${NCORES}
make install