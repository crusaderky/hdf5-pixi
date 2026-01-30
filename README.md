[Pixi](https://pixi.sh) script to build libhdf5 git tip with debug
symbols and deploy it with conda in your pixi projects.
Supports variant builds with (e.g. ASAN, TSAN).

Additionally, this project can build the whole h5py stack
(python, numpy, hdf5, h5py) with ASAN.

# Build and test HDF5 locally

## Build, test, and package
```bash
git clone https://github.com/crusaderky/hdf5-pixi.git
cd hdf5-pixi
git submodule init
pixi r cmake
pixi r -e local smoke-test
pixi r ctest
pixi r cpack  # Creates artefacts in dist/
```

## Run clang-format
```bash
pixi r lint
```

## Change HDF5 version
After `git submodule init`, you may update the `hdf5` git submodule to repoint
to a newer/older version of hdf5. Release 1.14 and older are not supported.
You should update the version number in `{default,asan,tsan}/recipe.yaml` accordingly.
After the change, you should run `pixi r clean`.

# Use hdf5 in downstream pixi projects
In the `pixi.toml` of your project, change
```toml
[workspace]
channels = ["https://prefix.dev/conda-forge"]
platforms = ["linux-64", "linux-aarch64", "osx-64", "osx-arm64"]

[dependencies]
hdf5 = "*"  # Latest from conda-forge
```

to

```toml
[workspace]
channels = ["https://prefix.dev/conda-forge"]
platforms = ["linux-64", "linux-aarch64", "osx-64", "osx-arm64"]
preview = ["pixi-build"]

[dependencies]
############
# Choose one
############
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "pixi-packages/hdf5/default" }
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "pixi-packages/hdf5/minimal" }
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "pixi-packages/hdf5/asan" }
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "pixi-packages/hdf5/tsan" }
# Or a local git checkout, e.g if you are actively tampering with files in the
# hdf5/ submodule, or if you're using hdf5-pixi as a git submodule.
hdf5 = { path = "/my/projects/hdf5-pixi/pixi-packages/hdf5/default" }
hdf5 = { path = "/my/projects/hdf5-pixi/pixi-packages/hdf5/minimal" }
hdf5 = { path = "/my/projects/hdf5-pixi/pixi-packages/hdf5/asan" }
hdf5 = { path = "/my/projects/hdf5-pixi/pixi-packages/hdf5/tsan" }
```

You will need to recompile downstream packages, such as
`h5py` or `versioned-hdf5`, from sources.

The four variants are:
- **default:** with zlib/deflate/gzip and szip compression
- **minimal:** no compression, no extra dependencies
- **asan:** Address Sanitizer enabled, with compression
- **tsan:** Thread Sanitizer enabled, with compression

# h5py

Installs python, numpy, hdf5, and h5py all on git tip:
```bash
pixi r -e h5py-default h5py-install
pixi r -e h5py-default smoke-test   # Print versions and exit
pixi r -e h5py-default h5py-pytest  # Run the full pytest suite
```
You may use the following environments:
- `h5py-default`: GIL enabled
- `h5py-freethreading`: GIL disabled
- `h5py-asan`: GIL enabled, ASan enabled
- `h5py-tsan-freethreading`: GIL disabled, TSan enabled

In all cases, the full stack is built from sources.
CPython and NumPy are built as of the current git tip.
HDF5 and h5py are built from their respective git subprojects 
`hdf5/` and `h5py/`.

# Troubleshooting

## Dirty cache
The local build and test commands `pixi r {cmake,ctest,cpack}` use the build cache
directory `.pixi/envs/local/build`. After a change in `hdf5/`, you should be able to
quickly rebuild just what changed. When in doubt, though, you should run `pixi clean` to
start from a clean slate. You should always do it after changing any compilation flags.

If you're using this in a downstream pixi project, and anything changes in `hdf5/`, pixi
won't realize that the hdf5 binary that's in the rattler cache is obsolete. *In your
project*, run `pixi clean && pixi clean cache -y` to force a rebuild. The three variants
`default`, `asan`, and `tsan` are separate and you don't need to clean the cache if
you're just switching between them.

## TSAN crashes on Linux
TSAN builds may crash on Linux with
```
FATAL: ThreadSanitizer: unexpected memory mapping 0x7977bd072000-0x7977bd500000
```
Your `mmap_rnd_bits` may be too high:

```bash
$ sudo sysctl vm.mmap_rnd_bits
vm.mmap_rnd_bits = 32  # too high
$ sudo sysctl vm.mmap_rnd_bits=28  # reduce it
vm.mmap_rnd_bits = 28
```
