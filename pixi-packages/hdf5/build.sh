#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

if [ $HDF5_VARIANT == "asan" ]; then
  export CFLAGS="-fsanitize=address"
  export LDFLAGS="-fsanitize=address"
elif [ $HDF5_VARIANT == "tsan" ]; then
  export CFLAGS="-fsanitize=thread"
  export LDFLAGS="-fsanitize=thread"
elif [ $HDF5_VARIANT == "default" ]; then
  export CFLAGS=""
  export LDFLAGS=""
else
    echo "Unknown HDF5_VARIANT: $HDF5_VARIANT"
    exit 1
fi

export CC="clang"
export CMAKE_BUILD_PARALLEL_LEVEL="4"
export CTEST_PARALLEL_LEVEL="4"
export CMAKE_CONFIG_TYPE="Debug"
export CMAKE_BUILD_TYPE="Debug"
# export CMAKE_CONFIG_TYPE="Release"
# export CMAKE_BUILD_TYPE="Release"
export HDF5_CONFIG_ARGS="-DHDF5_ENABLE_DEBUG_APIS=ON -DHDF5_ENABLE_TRACE=ON -DHDF5_ENABLE_COVERAGE=ON -DHDF5_ENABLE_ZLIB_SUPPORT=ON -DHDF5_ENABLE_SZIP_SUPPORT=ON"
# export VERBOSE="1"

cmake -S "$RECIPE_DIR/../../../hdf5" -B "$BUILD_DIR/build" $HDF5_CONFIG_ARGS
cmake --build "$BUILD_DIR/build"
cmake --install "$BUILD_DIR/build" --prefix "$PREFIX"
