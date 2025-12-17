[Pixi](https://pixi.sh) script to build libhdf5 git tip with debug
symbols and deploy it with conda in your pixi projects.
Supports variant builds with (e.g. ASAN, TSAN).

# Usage

## Build, test, and package HDF5
```bash
git clone https://github.com/crusaderky/hdf5-pixi.git
cd hdf5-pixi
git submodule init
pixi r cmake
pixi r ctest
pixi r cpack
```

## Change HDF5 version
After `git submodule init`, you may update the `hdf5` git submodule to repoint
to a newer/older version of hdf5. Release 1.14 and older are not supported.
You should update the version number in `{default,asan,tsan}/recipe.yaml` accordingly.
After the change, you should run `pixi r clean`.

## Use in downstream pixi projects
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
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "default" }
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "asan" }
hdf5 = { git = "https://github.com/crusaderky/hdf5-pixi", subdirectory = "tsan" }
# Or a local git checkout, e.g if you are actively tampering with files in the
# hdf5/ submodule
hdf5 = { path = "/my/projects/hdf5-pixi/default" }
hdf5 = { path = "/my/projects/hdf5-pixi/asan" }
hdf5 = { path = "/my/projects/hdf5-pixi/tsan" }
```

You will need to recompile downstream packages, such as
`h5py` or `versioned-hdf5`, from sources.

## Troubleshooting

### Dirty local cache
The local build and test commands `pixi r {cmake,ctest,cpack}` use the
build cache directory `build-local`. After a change in `hdf5/`, you should
be able to quickly rebuild just what changed.

When in doubt, though, you should run `pixi r clean` to start from a clean slate.
You should always do it after changing any compilation flags.

### Dirty rattler cache
If you're using this in a downstream pixi project, and anything changes in `hdf5/`,
pixi won't realize that the hdf5 binary that's in the rattler cache is
obsolete. *In your project*, run

```bash
pixi clean
pixi clean cache -y
```

to force a rebuild. If you're pointing a local deployment of `hdf5-pixi`, it will
use the local `hdf5-pixi/build-{default,asan,tsan}` directory.

To clean them, run `pixi r clean`.

The three variants `default`, `asan`, and `tsan` are separate and you don't need
to clean the cache if you're just switching between them.

### TSAN crashes on Linux
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
