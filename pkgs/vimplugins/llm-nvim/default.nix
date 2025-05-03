{ vimUtils, fetchFromGitHub, lib }:
vimUtils.buildVimPlugin {
  pname = "llm.nvim";
  version = "2025-01-28";
  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm.nvim";
    rev = "ce69731ba3f8d3ea8bc4c8f58c74c2f9ea0b33de";
    sha256 = "sha256-8bJwksIEE5/K4g1akzYRWpkkTLb5bEBWwiCFC8VGfSU=";
  };

  meta = {
    description = "Neovim plugin llm.nvim from huggingface.";
    homepage = "https://github.com/huggingface/llm.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
