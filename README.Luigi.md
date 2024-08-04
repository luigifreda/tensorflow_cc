# How To 


## Check the tensorflow GPU compatibility table 

https://www.tensorflow.org/install/source#gpu

Worked version 
* CUDA: 11.6    <-- It does not seem to work with 11.8
* BAZEL_VERSION: 5.1.1 
* TENSORFLOW_VERSION: 2.9.0
* CUDNN: 8.6.0.163-1+cuda11.8     <-- This is super important! Without this the GPU runtime will complain about the missing runtime compatibility 
    - `sudo apt install -y libcudnn8=8.6.0.163-1+cuda11.8`
    - `sudo apt install -y libcudnn8-dev=8.6.0.163-1+cuda11.8`

NOTE: Other configurations with newer tensorflow version were successfully built

## Install CUDA, CUDNN, TensorRT 

* cudnn  https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html    <-- used 8.2.1.32-1+cuda11.3
* tensorrt https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html  <--  8.5.2-1+cuda11.8 

## Configuration

Set CUDA version in 
* build.sh

Set the tensorflow and bazel version in 
* BAZEL_VERSION -> Dockerfiles/BAZEL_VERSION    <-- 5.1.1 
* TENSORFLOW_VERSION -> tensorflow_cc/PROJECT_VERSION <-- 2.9.0

## Build and install 

Use the script build.sh 
```
$ ./build.sh 
```

## Verify the installed libs and GPU is working

Use the example folder 
```
cd example 
mkdir build
cd build 
cmake ..
make 
```
Run the two compiled examples. 

# NOTES 

I had to remove the bazel option `--config=monolithic` since it bring troubles https://github.com/tensorflow/tensorflow/issues/59081. 
The file I modified is `tensorflow_cc/cmake/build_tensorflow.sh.in` which is used to configure and build the downloaded tensorflow version. 

Working configurations: 
* Tested tensorflow 2.13.0, bazel 5.3.0, cudnn 8.6.0: it compiled, had a problem with missing interface to libtensorflow_framework. Then was blocked by a strange protobuf error at run time "File already exists in database: google/protobuf/any.proto"   <== This can be solved by removing `--config=monolithic` from bazel options (since it bring troubles https://github.com/tensorflow/tensorflow/issues/59081). File to modify: tensorflow_cc/cmake/build_tensorflow.sh.in
* Tested tensorflow 2.14.0, bazel 6.1.0, cuda 8.9.7 and it compiled and worked without after having removed  `--config=monolithic` from bazel options. 

