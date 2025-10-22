{
  pkgs ? import <nixpkgs> { },
}:
let
  vimplugins = pkgs.callPackage ./pkgs/vimplugins { inherit pkgs; };
  templates = pkgs.callPackage ./templates { };

  alacritty = pkgs.callPackage ./pkgs/alacritty/default.nix { };

  codelldb =
    if pkgs.stdenv.isDarwin then
      pkgs.callPackage ./pkgs/codelldb/darwin-default.nix { }
    else
      pkgs.callPackage ./pkgs/codelldb/default.nix {
        llvmPackages = pkgs.llvmPackages_14;
      };

  solidity-language-server =
    (pkgs.callPackage ./pkgs/npm/solidity-language-server/default.nix { }).package;
in
rec {
  inherit
    alacritty
    codelldb
    solidity-language-server
    vimplugins
    templates
    ;

  # expose "checks" to do `nix-build -A checks` or target individual jobs
  checks = pkgs.lib.recurseIntoAttrs {
    build-alacritty = alacritty;
    build-codelldb = codelldb;
    build-solidity-language-server = solidity-language-server;

    build-vimplugins-vim-go = vimplugins.vim-go;
    build-vimplugins-flutterhelp = vimplugins.flutterhelp;
    build-vimplugins-llm-nvim = vimplugins.llm-nvim;
  };
}
