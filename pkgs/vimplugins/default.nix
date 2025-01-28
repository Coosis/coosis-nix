{ pkgs }:
{
  flutterhelp = pkgs.callPackage ./flutterhelp { };
  vim-go = pkgs.callPackage ./vim-go { };
	llm-nvim = pkgs.callPackage ./llm-nvim { };
}
