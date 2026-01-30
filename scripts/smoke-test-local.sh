#!/bin/bash
# Smoke test for local build of HDF5
# Must run after: `pixi r cmake`
# Invoked by    : `pixi r -e local smoke-test`

set -o errexit
set -o nounset

cd $CONDA_PREFIX/build/

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DLL_NAME=libhdf5.so
    ldd h5ls
elif [[ "$OSTYPE" == "darwin"* ]]; then
    DLL_NAME=libhdf5.dylib
    otool -L h5ls
fi

test -f $DLL_NAME
./h5ls --help > /dev/null
echo "HDF5 smoke test passed."
