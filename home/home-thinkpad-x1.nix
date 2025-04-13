{ pkgs, ... }:
{

  imports = [
    ./gnome/gnome.nix
    # ./syncthing/syncthing.nix
  ];

  programs.kitty = {
    # font.size = 10;
  };

  home.packages = [
    # pkgs.texlive.combined.scheme-full
  ];

}
