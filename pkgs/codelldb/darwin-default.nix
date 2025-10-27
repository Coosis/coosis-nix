{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  unzip,
}:
# assert stdenv.isDarwin -> "Only Darwin supported";
let
  system = stdenv.system;
  binaries = {
    "x86_64-darwin" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.11.8/codelldb-darwin-x64.vsix";
      sha256 = "wY98ZL5LE264WJVJ/TrxLF6Xwt09dJQ9lggD90s5vFE=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/vadimcn/codelldb/releases/download/v1.11.8/codelldb-darwin-arm64.vsix";
      sha256 = "oQZeNL4/cpVLKWZXghoGxWaodH1JMMLZ67dJFGp1btc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "codelldb";
  version = "1.11.8";
  nativeBuildInputs = [
    unzip
    makeWrapper
  ];
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
    description = "CodeLLDB executable, solely for use with nvim-dap plugin of neovim";
    homepage = "https://github.com/vadimcn/vscode-lldb";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;

  };
}
