# tensorflow_cc v2.0

Maintainer: [Luigi Freda](https://www.luigifreda.com)

<!-- TOC -->

- [tensorflow\_cc v2.0](#tensorflow_cc-v20)
  - [Install](#install)
    - [System configuration](#system-configuration)
      - [CUDA, CUDNN, TensorRT](#cuda-cudnn-tensorrt)
    - [Clone this repository](#clone-this-repository)
    - [Configuration](#configuration)
    - [Build and install](#build-and-install)
    - [Free disk space (Optional)](#free-disk-space-optional)
  - [Usage](#usage)
  - [Docker](#docker)
  - [Some final notes and some tested working configurations](#some-final-notes-and-some-tested-working-configurations)
  - [Credits](#credits)

<!-- /TOC -->

This project allows to build and easily access (via cmake) the [TensorFlow C++](https://www.tensorflow.org/api_docs/cc/) API. In particular, after having built and deployed your new `tensor_cc` library, you won't need [Bazel](https://bazel.build/) build system anymore (if you wish).

This project started as a fork of the repository https://github.com/FloopCZ/tensorflow_cc. After having hit and solved some build and deployment issues (especially with newer tensorflow configurations), I am sharing the updated and improved version of the scripts I obtained.  

This repository contains two CMake projects. 
- The [tensorflow_cc](./tensorflow_cc/README.md) project that downloads, builds and installs the TensorFlow C++ API into the operating system. 
- The [example](./example/README.md) project that demonstrates its simple usage.

## Install 

The following procedure has been tested under **Ubuntu 20.04**. 

### System configuration 

**IMPORTANT**: before starting the install process, you need to check the [tensorflow GPU compatibility table](https://www.tensorflow.org/install/source#gpu). Select your preferred configuration from the tested ones reported in the table.
- With CPU: https://www.tensorflow.org/install/source#cpu
- With GPU: https://www.tensorflow.org/install/source#gpu

My **current preferred working configuration** under Ubuntu 20.04:
- **C++**: 17
- **TENSORFLOW_VERSION**: 2.9.0 
- **BAZEL_VERSION**: 5.1.1
- **CUDA**: 11.6 
- **CUDNN**: 8.6.0.163-1+cuda11.8   
     - `sudo apt install -y libcudnn8=8.6.0.163-1+cuda11.8`
    - `sudo apt install -y libcudnn8-dev=8.6.0.163-1+cuda11.8`
  
I successfully built/deployed/tested other **newer tensorflow configurations** by using the new updated scripts/configurations (see the list below).

#### CUDA, CUDNN, TensorRT 

If you want to allow `tensorflow_cc` to use your GPU, start by checking you have properly installed `CUDA`, `CUDNN`, `TensorRT` 

* `CUDA`: https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
* `cudnn`: https://docs.nvidia.com/deeplearning/cudnn/latest/installation/linux.html    
* `TensorRT`: https://docs.nvidia.com/deeplearning/tensorrt/install-guide/index.html  
  

### Clone this repository

```bash
git clone https://github.com/FloopCZ/tensorflow_cc.git
cd tensorflow_cc
```

### Configuration

Check the [tensorflow GPU compatibility table](https://www.tensorflow.org/install/source#gpu) and
1. Set your preferred `CUDA` version in the script `build.sh`
2. Set your target `tensorflow` and `bazel` versions in the following files (in the root folder):
   * `BAZEL_VERSION ` 
   * `TENSORFLOW_VERSION` 


### Build and install 

Once you have properly set the configuration files, run
```
$ ./build.sh 
```

**Warning:** The build will take a long while (more than 2 hours). 

**Warning:** Optimizations for Intel CPU are obtained by running `export CC_OPT_FLAGS="-march=native"`
before the build. This command provides the best possible optimizations for your current CPU generation, but
it may cause the built library to be incompatible with other machines (if you want to deploy it elsewhere).

**Warning:** In low-memory or many-cpu environments, the bazel scheduler can miss the resource consumption
estimates and the build may be terminated by the out-of-memory killer.
If that is your case, consider adding resource limit parameters to CMake, e.g.,
`cmake -DLOCAL_RAM_RESOURCES=2048 -DLOCAL_CPU_RESOURCES=4 ..`

### Free disk space (Optional) 

After you have build and deployed your Tensorflow C++ library, you may want to clean up the build artifacts. 
```bash
# cleanup bazel build directory
rm -rf ~/.cache
# remove the build folder
cd .. && rm -rf build
```

## Usage

The [example](./example/README.md) project demonstrates the simple usage of `tensorflow_cc`.

In order to build and run the example program:
```
cd example
mkdir build && cd build
cmake .. && make
./example 
```

## Docker

At present, I didn't test the new scripts under docker yet. If you wish, you may want to take a look at this [repo](https://github.com/FloopCZ/tensorflow_cc) and its docker image shared under Docker hub.

## Some final notes and some tested working configurations

With respect to the original repo, I had to remove the bazel option `--config=monolithic` since it brings some [troubles](https://github.com/tensorflow/tensorflow/issues/59081). In particular, I removed this option from the file `tensorflow_cc/cmake/build_tensorflow.sh.in`, which is used by cmake to generate the final configure and build script `tensorflow_cc/build/build_tensorflow.sh`. 

I successfully built and deployed other **newer tensorflow configurations** (see the list below). However, note that tensorflow does download and use its own custom versions of `Eigen` (and of other base libraries, according to the selected tensorflow version) and these library versions may not be the same installed in your system. This fact may cause severe problems (undefined behaviors and uncontrolled crashes) in your final target projects (where you want to import the built and deployed Tensorflow C++): In fact, you may be mixing libraries built with different versions of `Eigen` (so with different data alignments)!  
Some tested **working tensorflow configurations**: 
  * tensorflow 2.9.0, bazel 5.1.1, cudnn 8.6.0, cuda 11.6
  * tensorflow 2.13.0, bazel 5.3.0, cudnn 8.6.0, cuda 11.8
  * tensorflow 2.14.0, bazel 6.1.0, cuda 8.9.7, cuda 11.8


## Credits 

Thanks to FlooCZ for his initial version of the tensorflow_cc [repo](https://github.com/FloopCZ/tensorflow_cc).
