{ vimUtils, fetchFromGitHub, lib }:
vimUtils.buildVimPlugin {
  pname = "flutterhelp";
  version = "2024-09-19";
  src = fetchFromGitHub {
    owner = "Coosis";
    repo = "flutterhelp.nvim";
    rev = "main";
    sha256 = "1673ajgn4bpwc2sz623prvj7qfcl8gxy3a2zad0d7j3ygfifp8zn";
  };

  meta = {
    description = "A neovim plugin for simple interaction with flutter.";
    homepage = "https://github.com/Coosis/flutterhelp.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
