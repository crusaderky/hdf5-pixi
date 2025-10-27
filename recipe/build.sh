#!/bin/bash
set -ex

# Find the tarball in the build directory
TARBALL=$(ls "$RECIPE_DIR"/../build/HDF5-*.tar.gz 2>/dev/null | head -1)

if [ -z "$TARBALL" ]; then
    echo "Error: No HDF5 tarball found in build/ directory"
    echo "Please run 'pixi run pack' first to create the tarball"
    exit 1
fi

echo "Using tarball: $TARBALL"

# Extract the tarball
tar -xzvf "$TARBALL"

# Find the extracted directory
# It will be something like HDF5-2.0.0.4-Linux/HDF_Group/HDF5/2.0.0.4
EXTRACTED_DIR=$(tar -tzf "$TARBALL" | tail -1 | cut -f1,2,3,4 -d"/")
echo "Extracted directory: $EXTRACTED_DIR"
cd "$EXTRACTED_DIR"

# Copy all files to the prefix.
# Exclude cmake/ directory (it breaks cmake on conda).
cp -r bin include lib "$PREFIX/"

# Ensure executables are executable
chmod +x "$PREFIX"/bin/* || true
