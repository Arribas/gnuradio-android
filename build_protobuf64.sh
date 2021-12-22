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
export CC="${TOOLCHAIN_BIN}/aarch64-linux-android${API_LEVEL}-clang"
export CXX="${TOOLCHAIN_BIN}/aarch64-linux-android${API_LEVEL}-clang++"
export LD=${TOOLCHAIN_BIN}/aarch64-linux-android-ld
export AR=${TOOLCHAIN_BIN}/aarch64-linux-android-ar
export RANLIB=${TOOLCHAIN_BIN}/aarch64-linux-android-ranlib
export STRIP=${TOOLCHAIN_BIN}/aarch64-linux-android-strip
export BUILD_ROOT=$(dirname $(readlink -f "$0"))
export PATH=${TOOLCHAIN_BIN}:${PATH}
export PREFIX=${BUILD_ROOT}/toolchain/arm64-v8a
export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
export NCORES=$(getconf _NPROCESSORS_ONLN)

mkdir -p ${PREFIX}

#############################################################
### PROTOBUF LIB
#############################################################

cd ${BUILD_ROOT}
rm protobuf64 -rf
git clone https://github.com/protocolbuffers/protobuf.git protobuf64
cd protobuf64
git checkout v3.19.0
#git clean -xdf

./autogen.sh
./configure --enable-static --disable-shared --host=aarch64-linux-android --prefix=${PREFIX} LDFLAGS="-L${PREFIX}/lib -llog" CPPFLAGS="-fPIC -I${PREFIX}/include" LIBS="-lgcc"

make -j ${NCORES}
make install
