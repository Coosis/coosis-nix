{ stdenv, lib, fetchurl, makeWrapper, unzip }:
# assert stdenv.isDarwin -> "Only Darwin supported";
let
  system = stdenv.system;
  binaries = {
    "x86_64-darwin" = {
      url =
        "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-darwin.vsix";
      sha256 = "1kzm0hrg6ji2wjxhnsj45g49dq5kll8vb760131k8154f1b0vcci";
    };
    "aarch64-darwin" = {
      url =
        "https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-aarch64-darwin.vsix";
      sha256 = "0hbs2rr4r8zlii3srbc9xbmn5wm3p88cdsx85xp2vibbf9d7kc2a";
    };
  };
in stdenv.mkDerivation {
  pname = "codelldb";
  version = "1.10.0";
  nativeBuildInputs = [ unzip makeWrapper ];
  src = fetchurl {
    url = binaries.${system}.url;
    sha256 = binaries.${system}.sha256;
  };

  unpackPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out
  '';

  installPhase = ''
    # ln -s $out/extension/adapter/codelldb $out/bin/codelldb
    # chmod +x $out/extension/adapter/codelldb
        makeWrapper $out/extension/adapter/codelldb $out/bin/codelldb \
        --set LD_LIBRARY_PATH $out/extension/lldb/lib \
        --set DYLD_LIBRARY_PATH $out/extension/lldb/lib
        chmod +x $out/bin/codelldb
  '';

  meta = {
    description =
      "CodeLLDB executable, solely for use with nvim-dap plugin of neovim";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;

  };
}

