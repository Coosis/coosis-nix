{ vimUtils, fetchFromGitHub, lib }:
vimUtils.buildVimPlugin {
  pname = "llm.nvim";
  version = "2025-01-28";
  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm.nvim";
    rev = "main";
    sha256 = "0yr7i6nslkzz1gzhya5gkc7g26v5dw27403hminr799q976l3ad7";
  };

  meta = {
    description = "Neovim plugin llm.nvim from huggingface.";
    homepage = "https://github.com/huggingface/llm.nvim";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
