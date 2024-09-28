{ pkgs }:
{
  flutterhelp = pkgs.callPackage ./flutterhelp { };
  vim-go = pkgs.callPackage ./vim-go { };
}
