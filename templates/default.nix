{ }:
{
  nixblank = {
    path = ./nixblank;
    description = (import ./nixblank/flake.nix).description;
  };
  nixgo = {
    path = ./nixgo;
    description = (import ./nixgo/flake.nix).description;
  };
  nixjupyter = {
    path = ./nixjupyter;
    description = (import ./nixjupyter/flake.nix).description;
  };
  nixpy = {
    path = ./nixpy;
    description = (import ./nixpy/flake.nix).description;
  };
  nixpypip = {
    path = ./nixpypip;
    description = (import ./nixpypip/flake.nix).description;
  };
  nixpyuv = {
    path = ./nixpyuv;
    description = (import ./nixpyuv/flake.nix).description;
  };
  nixrust = {
    path = ./nixrust;
    description = (import ./nixrust/flake.nix).description;
  };
  nixtex = {
    path = ./nixtex;
    description = (import ./nixtex/flake.nix).description;
  };
}
