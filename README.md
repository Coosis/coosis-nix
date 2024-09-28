# coosis-nix
Coosis's personal nix store. Used for packages that are not worth contributing to nixpkgs.

To get started, add the following to your `flake.nix`:
```nix
inputs = {
    # other inputs...
    coosis-nix.url = "github:Coosis/coosis-nix";
};
```

Getting the packages for your specific system:
```nix
let
    cpkgs = coosis-nix.packages.${nixpkgs.stdenv.system};
in
{
    ...
}
```

Using packages:
```nix
cpkgs.somePackage
```

# Packages
```
alacritty
codelldb
vimplugins.flutterhelp
vimplugins.vim-go
```

# Templates
Usage: `nix flake new -t github:Coosis/coosis-nix#<template-name>`
Replace `<template-name>` with the name of the template you want to use.

Available templates:
```
nixgo
nixjupyter
nixpy
nixpypip
```
