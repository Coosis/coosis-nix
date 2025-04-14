{
  description =
    "A flake for python development environment, using nix for python package management.";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs, ... }:
    let
      # to work with older version of flakes
      lastModifiedDate =
        self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      # Add dependencies that are only needed for development
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          # Choose desired Python version
          python39 = pkgs.python39;
          python310 = pkgs.python310;
          python311 = pkgs.python311;
          python = pkgs.python3;
          python313 = pkgs.python313;
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs;
              [
                (python.withPackages (python-pkgs:
                  with python-pkgs; [
                    # A Python interpreter including the 'venv' module is required to bootstrap
                    # the environment.
                    python
                    pip
                    # Used for DAP protocol debugging
                    debugpy

                    # Desired Python packages
                    numpy
                    # If nixpkgs don't have it or you want to use a different version,
                    # you can fetch it from PyPI
                    # For wheels, check out fetchPypi src: 
                    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/fetchpypi/default.nix
                    (buildPythonPackage rec {
                      pname = "numpy";
                      version = "2.1.1";
                      # src = fetchFromGitHub {
                      # 	owner = "";
                      # 	repo = "";
                      # 	rev = "";
                      # 	sha256 = "";
                      # };
                      src = pkgs.fetchPypi {
                        inherit pname version;
                        sha256 = "";
                      };

                      meta = with pkgs.lib; {
                        description = "A description of your package";
                        license = licenses.mit;
                        homepage = "https://your-package-homepage.com";
                      };
                    })
                  ]))

                # Other packages you might need in your environment
                # ...
              ];
            shellHook = "	export SHELL=$(which zsh)\n	exec zsh\n";
          };
        });
    };
}
