#!/bin/bash
set -ex

CC="clang"
export CMAKE_BUILD_PARALLEL_LEVEL="4"
export CTEST_PARALLEL_LEVEL="4"
export CMAKE_CONFIG_TYPE="Debug"
export CMAKE_BUILD_TYPE="Debug"
# export CMAKE_CONFIG_TYPE="Release"
# export CMAKE_BUILD_TYPE="Release"
export HDF5_CONFIG_ARGS="-DHDF5_ENABLE_DEBUG_APIS=ON -DHDF5_ENABLE_TRACE=ON -DHDF5_ENABLE_COVERAGE=ON"
# export VERBOSE="1"

cmake -S "$RECIPE_DIR"/../hdf5 -B "$BUILD_DIR" $HDF5_CONFIG_ARGS
cmake --build "$BUILD_DIR"
cmake --install "$BUILD_DIR" --prefix "$PREFIX"
