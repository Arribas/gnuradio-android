#############################################################
### PROTOBUF LIB for host
#############################################################

rm protobuf_host -rf
git clone https://github.com/protocolbuffers/protobuf.git protobuf_host
cd protobuf_host
git checkout v3.19.0
#git clean -xdf

./autogen.sh
./configure

make -j ${NCORES}

sudo make install
sudo ldconfig
