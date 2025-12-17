#!/bin/bash
set -xe

cd build-local/bin/

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DLL_NAME=libhdf5.so
    ldd h5ls
elif [[ "$OSTYPE" == "darwin"* ]]; then
    DLL_NAME=libhdf5.dylib
    otool -L h5ls
fi

test -f $DLL_NAME
./h5ls --help > /dev/null
