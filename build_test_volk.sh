set -xe

#############################################################
### CONFIG
#############################################################
export TOOLCHAIN_ROOT=${HOME}/Android/Sdk/ndk/21.3.6528147
export HOST_ARCH=linux-x86_64

#############################################################
### DERIVED CONFIG
#############################################################
export SYS_ROOT=${TOOLCHAIN_ROOT}/sysroot
export TOOLCHAIN_BIN=${TOOLCHAIN_ROOT}/toolchains/llvm/prebuilt/${HOST_ARCH}/bin
export API_LEVEL=29
export CC="${TOOLCHAIN_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang"
export CXX="${TOOLCHAIN_BIN}/armv7a-linux-androideabi${API_LEVEL}-clang++"
export LD=${TOOLCHAIN_BIN}/arm-linux-androideabi-ld
export AR=${TOOLCHAIN_BIN}/arm-linux-androideabi-ar
export RANLIB=${TOOLCHAIN_BIN}/arm-linux-androideabi-ranlib
export STRIP=${TOOLCHAIN_BIN}/arm-linux-androideabi-strip
export BUILD_ROOT=$(dirname $(readlink -f "$0"))
export PATH=${TOOLCHAIN_BIN}:${PATH}
export PREFIX=${BUILD_ROOT}/toolchain/armeabi-v7a
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export NCORES=$(getconf _NPROCESSORS_ONLN)

mkdir -p ${PREFIX}

# #############################################################
# ### TEST VOLK
#############################################################

cd ${BUILD_ROOT}/volk/apps
rm build -rf
#git clean -xdf

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_ROOT}/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=armeabi-v7a -DANDROID_ARM_NEON=ON \
  -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
  -DPYTHON_EXECUTABLE=/usr/bin/python3 \
  -DBOOST_ROOT=${PREFIX} \
  -DBoost_COMPILER=-clang \
  -DBoost_USE_STATIC_LIBS=ON \
  -DBoost_ARCHITECTURE=-a32 \
  -DENABLE_STATIC_LIBS=True \
  -DCMAKE_FIND_ROOT_PATH=${PREFIX} \
  ../
make -j ${NCORES}
make install
