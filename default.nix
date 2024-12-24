{ pkgs ? import <nixpkgs> { } }:

let
  vimplugins = pkgs.callPackage ./pkgs/vimplugins { inherit pkgs; };
  templates = pkgs.callPackage ./templates { };
in
{
  alacritty = pkgs.callPackage ./pkgs/alacritty/default.nix { };
  alacritty_darwin = pkgs.callPackage ./pkgs/alacritty/darwin-default.nix { };
  codelldb = pkgs.callPackage ./pkgs/codelldb/default.nix { };
	solidity-language-server = (pkgs.callPackage ./pkgs/npm/solidity-language-server/default.nix { }).package;
  vimplugins = vimplugins;
  templates = templates;
}
