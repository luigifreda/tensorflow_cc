#!/usr/bin/env bash


INSTALL_PATH=$HOME/.tensorflow 

TENSORFLOW_VERSION=$(cat ./TENSORFLOW_VERSION)
BAZEL_VERSION=$(cat ./BAZEL_VERSION)


#============================================
# CUDA config 

# 1: ON, 0: OFF
export USE_CUDA=0  # use CUDA in PLVS sparse SLAM  
export CUDA_VERSION="cuda-11.6"  # must be an installed CUDA path in "/usr/local"; 
                                 # if available, you can use the simple path "/usr/local/cuda" which should be a symbolic link to the last installed cuda version 
if [ ! -d /usr/local/$CUDA_VERSION ]; then
    CUDA_VERSION="cuda"  # use last installed CUDA path in standard path as a fallback 
fi 

export PATH=/usr/local/$CUDA_VERSION/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/$CUDA_VERSION/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export CUDADIR=/usr/local/$CUDA_VERSION

#============================================
# Install bazel 

sudo ./ubuntu-requirements.sh 

#============================================
# Build tensorflow_cc 

echo TENSORFLOW_VERSION: $TENSORFLOW_VERSION
echo BAZEL_VERSION: $BAZEL_VERSION
echo INSTALL_PATH: $INSTALL_PATH

cd tensorflow_cc
if [ ! -d build ]; then 
    mkdir build 
fi 
cd build 
cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH
make -j8


# in order to install 
sudo make install
sudo ldconfig