cmake_minimum_required(VERSION 3.3 FATAL_ERROR)
project(ExampleTF)

# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_PREFIX_PATH ${CMAKE_MODULE_PATH} /home/luigi/.tensorflow/lib/cmake/TensorflowCC/)
find_package(TensorflowCC REQUIRED)

add_executable(example example.cpp)
target_link_libraries(example TensorflowCC::TensorflowCC)

add_executable(example_label_image example_label_image.cpp)
target_link_libraries(example_label_image TensorflowCC::TensorflowCC)

# link cuda if it is available
find_package(CUDA)
if(CUDA_FOUND)
  target_link_libraries(example ${CUDA_LIBRARIES})
  target_link_libraries(example_label_image ${CUDA_LIBRARIES})  
endif()
