{ pkgs ? import <nixpkgs> { } }:

let
  vimplugins = import ./pkgs/vimplugins { inherit pkgs; };
  templates = import ./templates { };
in
{
  alacritty = import ./pkgs/alacritty/default.nix { };
  alacritty_darwin = import ./pkgs/alacritty/darwin-default.nix { };
  codelldb = import ./pkgs/codelldb/default.nix { };
	solidity-language-server = (import ./pkgs/solidity-language-server/default.nix { }).package;
  vimplugins = vimplugins;
  templates = templates;
}
