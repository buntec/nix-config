{ pkgs, ... }:
{

  imports = [
    ./gnome/gnome.nix
    ./syncthing/syncthing.nix
  ];

  programs.kitty = {
    font.size = 10;
  };

  home.packages = with pkgs; [ texlive.combined.scheme-full ];

}
