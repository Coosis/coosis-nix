{
  description = "Root flake for coosis-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      isDarwin = system: system == "x86_64-darwin" || system == "aarch64-darwin";
      isLinux = system: system == "x86_64-linux" || system == "aarch64-linux";

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          darwinExtra =
            if isDarwin system then {
              AppKit = pkgs.darwin.apple_sdk.frameworks.AppKit;
              CoreGraphics = pkgs.darwin.apple_sdk.frameworks.CoreGraphics;
              CoreServices = pkgs.darwin.apple_sdk.frameworks.CoreServices;
              CoreText = pkgs.darwin.apple_sdk.frameworks.CoreText;
              Foundation = pkgs.darwin.apple_sdk.frameworks.Foundation;
              OpenGL = pkgs.darwin.apple_sdk.frameworks.OpenGL;
            } else { };
        in
        {
          alacritty = pkgs.callPackage
            (if isDarwin system then
              ./pkgs/alacritty/darwin-default.nix else
              ./pkgs/alacritty/default.nix)
            darwinExtra;
          vimplugins = pkgs.callPackage ./pkgs/vimplugins/default.nix { };
          codelldb = pkgs.callPackage ./pkgs/codelldb/default.nix { };
          v = pkgs.callPackage ./pkgs/v/default.nix { };
					solidity-language-server = (pkgs.callPackage ./pkgs/npm/solidity-language-server/default.nix { }).package;
        });
      templates = import ./templates { };
    };
}
