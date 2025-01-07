{ pkgs, lib, ... }:
{

  imports = [
    ./gnome/gnome.nix
  ];

  programs.kitty = {
    font.size = 12;
  };

}
