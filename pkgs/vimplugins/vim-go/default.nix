{ vimUtils, fetchFromGitHub, lib }:
vimUtils.buildVimPlugin {
  pname = "vim-gofmt";
  version = "2024-09-16";
  src = fetchFromGitHub {
    owner = "darrikonn";
    repo = "vim-gofmt";
    rev = "cea5b06b2c2646ced49a64f006be2edb42645dd1";
    sha256 = "BBL65NRDDxJNdOQ/vwknqXyZ5Er4T5hAQXh2FolGPws=";
  };

  meta = {
    description = "Neovim plugin vim-go.";
    homepage = "https://github.com/darrikonn/vim-gofmt";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
