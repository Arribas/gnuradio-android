set -xe

./build_protobuf_host.sh
./build_protobuf64.sh
./build_log4cpp64.sh
./build_lapack64.sh
./build_armadillo64.sh
./build_matio64.sh
./build_gflags64.sh
./build_glog64.sh
./build_pugixml64.sh
./build_gnss-sdr64.sh
