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

#############################################################
### PROTOBUF LIB
#############################################################

cd ${BUILD_ROOT}
rm protobuf -rf
git clone https://github.com/protocolbuffers/protobuf.git protobuf
cd protobuf
git checkout v3.19.0
#git clean -xdf

./autogen.sh
./configure --enable-static --disable-shared --host=arm-linux-androideabi --prefix=${PREFIX} LDFLAGS="-L${PREFIX}/lib -llog" CPPFLAGS="-fPIC -I${PREFIX}/include" LIBS="-lgcc"

make -j ${NCORES}
make install
