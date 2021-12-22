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
### LOG4CPP
#############################################################

cd ${BUILD_ROOT}

wget https://sourceforge.net/projects/log4cpp/files/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.3.tar.gz

tar -xvf log4cpp-1.1.3.tar.gz
cd log4cpp
./configure CC=${CC} CXX=${CXX} --host=arm-linux-gnueabi --prefix=${PREFIX}
make
make install

exit
