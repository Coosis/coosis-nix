{
  description = "Root flake for coosis-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      isDarwin = system: system == "x86_64-darwin" || system == "aarch64-darwin";
      isLinux = system: system == "x86_64-linux" || system == "aarch64-linux";

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          alacritty = pkgs.callPackage ./pkgs/alacritty/default.nix { };
          codelldb = (
            if isDarwin system then
              (pkgs.callPackage ./pkgs/codelldb/darwin-default.nix { })
            else
              (pkgs.callPackage ./pkgs/codelldb/default.nix {
                llvmPackages = pkgs.llvmPackages_14;
              })
          );
          solidity-language-server =
            (pkgs.callPackage ./pkgs/npm/solidity-language-server/default.nix { }).package;
        }
      );
      legacyPackages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          vimplugins = pkgs.callPackage ./pkgs/vimplugins/default.nix { };
        }
      );
      templates = import ./templates { };
      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          build-alacritty = self.packages.${system}.alacritty;
          build-codelldb = self.packages.${system}.codelldb;
          build-solidity-language-server = self.packages.${system}.solidity-language-server;

          build-vimplugins-vim-go = self.legacyPackages.${system}.vimplugins.vim-go;
          build-vimplugins-flutterhelp = self.legacyPackages.${system}.vimplugins.vim-go;
          build-vimplugins-llm-nvim = self.legacyPackages.${system}.vimplugins.llm-nvim;
        }
      );
    };
}
