{ pkgs, ... }:
{

  imports = [
    ./gnome/gnome.nix
  ];

  home.packages = [
    # pkgs.texlive.combined.scheme-full
  ];

}
