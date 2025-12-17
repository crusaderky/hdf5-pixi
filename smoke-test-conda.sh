#!/bin/bash
set -xe

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
