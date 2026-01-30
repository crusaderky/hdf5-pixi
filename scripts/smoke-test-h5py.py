"""Smoke test for h5py
Must run after: `pixi r -e <env> h5py-install`
Invoked by    : `pixi r -e <env> smoke-test`
When <env> is one of:
  - h5py-default
  - h5py-freethreading
  - h5py-asan
  - h5py-tsan-freethreading
"""
import tempfile
import sys

print("Python version:", sys.version)

import numpy

print("NumPy version :", numpy.__version__)

import h5py
import h5py.h5

print("HDF5 version  :", ".".join(map(str, h5py.h5.get_libversion())))
print("h5py version  :", h5py.__version__, "(may not be accurate for git tip)")

with tempfile.TemporaryDirectory() as tmpdir:
    with h5py.File(f"{tmpdir}/test.h5", "w") as f:
        f.create_dataset("x", data=[1, 2, 3])

print("h5py smoke test passed.")
