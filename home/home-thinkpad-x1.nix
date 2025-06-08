{ pkgs, ... }:
{

  imports = [
    ./gnome/gnome.nix
    # ./syncthing/syncthing.nix
  ];

  home.packages = [
    # pkgs.texlive.combined.scheme-full
  ];

}
