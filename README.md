[Pixi](https://pixi.sh) script to build libhdf5

# Usage
```bash
git clone https://github.com/crusaderky/hdf5-pixi.git
cd hdf5-pixi
git clone https://github.com/HDFGroup/hdf5.git
pixi r build
```

## To switch to Debug mode
sed -i 's/Release/Debug/g' hdf5/CMakePresets.json
