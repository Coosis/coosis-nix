{ vimUtils, fetchFromGitHub, lib }:
vimUtils.buildVimPlugin {
  pname = "vim-gofmt";
  version = "2024-09-16";
  src = fetchFromGitHub {
    owner = "darrikonn";
    repo = "vim-gofmt";
    rev = "master";
    sha256 = "BBL65NRDDxJNdOQ/vwknqXyZ5Er4T5hAQXh2FolGPws=";
  };

  meta = {
    description = "Neovim plugin vim-go.";
    homepage = "https://github.com/darrikonn/vim-gofmt";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
