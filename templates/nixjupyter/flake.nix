# e.g. use `jupyter notebook .` to start a Jupyter notebook server at the current directory
{
  description = "A flake for python with jupyter, using nix for python package management.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
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
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              (python.withPackages (python-pkgs: with python-pkgs;
              [
                # A Python interpreter including the 'venv' module is required to bootstrap
                # the environment.
                python
                pip
                # Used for DAP protocol debugging
                debugpy

                # Desired Python packages
                jupyter
                numpy
                matplotlib
                scipy
              ]))

              # Other packages you might need in your environment
              # ...
            ];
            shellHook = ''
              							export SHELL=$(which zsh)
              							exec zsh
              						'';
          };
        });
    };
}