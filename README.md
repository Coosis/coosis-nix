# coosis-nix
Coosis's personal nix store. Used for packages that are not worth contributing to nixpkgs.

# BREAKING CHANGE NOTICE
For flake based setups, `vimplugins` have been moved to a `legacyPackages` instead of the main `packages`
For non-flake setups, `vimplugins` is untouched and works without problems.

# Getting Started
To get started, add the following to your `flake.nix`:
```nix
inputs = {
    # other inputs...
    coosis-nix.url = "github:Coosis/coosis-nix";
};
```
For non-flake setups:
```bash
nix-channel --add https://github.com/Coosis/coosis-nix/archive/main.tar.gz coosisnix
nix-channel --update
```

Getting the packages for your specific system:
```nix
let
    cpkgs = coosis-nix.packages.${nixpkgs.stdenv.system};
    cpkgs_legacy = coosis-nix.packages.${nixpkgs.stdenv.system};
in
{
    ...
}
```

Using packages:
```nix
cpkgs.somePackage
cpkgs_legacy.someLegacyPackage
```

# Packages
```
alacritty
codelldb
```

# Legacy Packages
```
vimplugins.flutterhelp
vimplugins.vim-go
```

# Templates
Usage: `nix flake new -t github:Coosis/coosis-nix#<template-name>`
Replace `<template-name>` with the name of the template you want to use.

Available templates:
```
nixblank
nixgo
nixjupyter
nixpy
nixpypip
nixpyuv
nixrust
nixtex
```
