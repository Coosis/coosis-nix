{
  description = "Nix flake for rust development, using cargo.";

  # Nixpkgs / NixOS version to use.
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      cargotoml = (builtins.fromTOML (builtins.readFile ./cargo.toml));

      # to work with older version of flakes
      lastModifiedDate =
        self.lastModifiedDate or self.lastModified or "19700101";

      pname = cargotoml.package.name;
      version = cargotoml.package.version;

      # System types to support.
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      architect = {
        "x86_64-linux" = "x86_64-unknown-linux-gnu";
        "x86_64-darwin" = "x86_64-apple-darwin";
        "aarch64-linux" = "aarch64-unknown-linux-gnu";
        "aarch64-darwin" = "aarch64-apple-darwin";
      };

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          libPath = with pkgs;
            lib.makeLibraryPath [
              # load external libraries that you need in your rust project here
            ];
        in {
          pname = pkgs.rustPlatform.buildRustPackage {
            inherit pname;
            inherit version;
            cargoLock.lockFile = ./Cargo.lock;
            src = ./.;

            # https://github.com/rust-lang/rust-bindgen#environment-variables
            LIBCLANG_PATH = pkgs.lib.makeLibraryPath
              [ pkgs.llvmPackages_latest.libclang.lib ];
            # Add precompiled library to rustc search path
            RUSTFLAGS = (builtins.map (a: "-L ${a}/lib") [
              # add libraries here (e.g. pkgs.libvmi)
            ]);
            LD_LIBRARY_PATH = libPath;
            # Add glibc, clang, glib, and other headers to bindgen search path
            BINDGEN_EXTRA_CLANG_ARGS =
              # Includes normal include path
              (builtins.map (a: ''-I"${a}/include"'') [
                # add dev libraries here (e.g. pkgs.libvmi.dev)
                # pkgs.glibc.dev
              ])
              # Includes with special directory paths
              ++ [
                ''
                  -I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
                # ''-I"${pkgs.glib.dev}/include/glib-2.0"''
                # ''-I"${pkgs.glib.out}/lib/glib-2.0/include/"''
              ];
          };
        });

      # Add dependencies that are only needed for development
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          # You can create a rust-toolchain.toml file in the project directory and reference it here
          # overrides = (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml));
          # But for now, we'll just use stable
          overrides = { toolchain = { channel = "stable"; }; };
          toolchain = architect.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              cargo
              clang
              # Replace llvmPackages with llvmPackages_X, where X is the latest LLVM version (at the time of writing, 16)
              llvmPackages.bintools
              rustup
              rust-analyzer
            ];
            RUSTC_VERSION = overrides.toolchain.channel;

            shellHook =
              "	export PATH=$PATH:\${CARGO_HOME:-~/.cargo}/bin\n	# Depending on your desired toolchain, you should probably change the path below\n	export PATH=$PATH:\${RUSTUP_HOME:-~/.rustup}/toolchains/$RUSTC_VERSION-${toolchain}/bin/\n	export SHELL=$(which zsh)\n	exec zsh\n";
          };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.pname);
    };
}
