#!/bin/bash
set -ex

export CMAKE_BUILD_PARALLEL_LEVEL="4"
export CTEST_PARALLEL_LEVEL="4"
export CMAKE_CONFIG_TYPE="Debug"
export CMAKE_BUILD_TYPE="Debug"
# export CMAKE_CONFIG_TYPE="Release"
# export CMAKE_BUILD_TYPE="Release"
export HDF5_CONFIG_ARGS="-DHDF5_ENABLE_DEBUG_APIS=ON -DHDF5_ENABLE_TRACE=ON -DHDF5_ENABLE_COVERAGE=ON"
# export VERBOSE="1"

pushd "$RECIPE_DIR"/..
cmake -S hdf5 -B $BUILD_DIR $HDF5_CONFIG_ARGS
cd $BUILD_DIR
cmake --build .
cpack -V
popd

# Find the tarball in the build directory
TARBALL=$(ls "$RECIPE_DIR"/../$BUILD_DIR/HDF5-*.tar.gz 2>/dev/null | head -1)

if [ -z "$TARBALL" ]; then
    echo "Error: No HDF5 tarball found in $BUILD_DIR directory"
    exit 1
fi

echo "Using tarball: $TARBALL"

# Extract the tarball
tar -xzvf "$TARBALL"

# Find the extracted directory
# It will be something like HDF5-2.0.1-Linux/HDF_Group/HDF5/2.0.1
EXTRACTED_DIR=$(tar -tzf "$TARBALL" | tail -1 | cut -f1,2,3,4 -d"/")
echo "Extracted directory: $EXTRACTED_DIR"
cd "$EXTRACTED_DIR"

# Copy all files to the prefix.
# Exclude cmake/ directory (it breaks cmake on conda).
cp -r bin include lib "$PREFIX/"

# Ensure executables are executable
chmod +x "$PREFIX"/bin/* || true
