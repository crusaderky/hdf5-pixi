#!/bin/bash
# Smoke test for pixi-build recipes of HDF5
# Invoked by: `pixi r -e pixi-default smoke-test`
#             `pixi r -e pixi-asan smoke-test`
#             `pixi r -e pixi-tsan smoke-test`

set -o errexit
set -o nounset

echo "Dynamic libraries:"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DLL_NAME=libhdf5.so
    ldd $(which h5ls)
elif [[ "$OSTYPE" == "darwin"* ]]; then
    DLL_NAME=libhdf5.dylib
    otool -L $(which h5ls)
fi
test -f $CONDA_PREFIX/lib/$DLL_NAME
test -f $CONDA_PREFIX/include/hdf5.h
h5ls --help > /dev/null
echo "HDF5 smoke test passed."
