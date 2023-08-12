# How To 

Worked version 
CUDA: 11.6
BAZEL_VERSION: 5.1.1 
TENSORFLOW_VERSION: 2.9.0
CUDNN: 8.2.1.32-1+cuda11.3

## Check the tensorflow GPU compatibility table 

https://www.tensorflow.org/install/source?hl=it#gpu


## Install CUDA, CUDNN, TensorRT 

* cudnn  https://docs.nvidia.com/deeplearning/cudnn/install-guide/index.html    <-- used 8.2.1.32-1+cuda11.3
* tensorrt https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html  <--  8.5.2-1+cuda11.8 

## Configuration

Set the tensorflow and bazel version in 
* BAZEL_VERSION -> Dockerfiles/BAZEL_VERSION    <-- 5.1.1 
* TENSORFLOW_VERSION -> tensorflow_cc/PROJECT_VERSION <-- 2.9.0


# NOTES 

* tested tensorflow 2.13.0, bazel 5.3.0, cudnn 8.6.0: it compiled, had a problem with missing interface to libtensorflow_framework. Then was blocked by a strange protobuf error at run time "File already exists in database: google/protobuf/any.proto". 

