[Pixi](https://pixi.sh) script to build libhdf5

# Usage

## Build, test, and package HDF5

```bash
git clone https://github.com/crusaderky/hdf5-pixi.git
cd hdf5-pixi
git clone https://github.com/HDFGroup/hdf5.git
pixi r build
pixi r test
pixi r pack
```

## Build conda package (Linux/MacOSX only)

```bash
pixi r build
pixi r pack
pixi r conda-build
```

A local conda repository will be created in the `conda-bld/` directory.

## Use in conda environments
```bash
mamba install -c file://absolute/path/to/hdf5-pixi/conda-bld hdf5
```

## Use in pixi projects
Change
```toml
[workspace]
channels = ["conda-forge"]
...

[dependencies]
hdf5 = "*"
```

to
```toml
[workspace]
channels = ["file:////absolute//path//to//hdf5-pixi//conda-bld", "conda-forge"]
...

[dependencies]
hdf5 = "*"
```
