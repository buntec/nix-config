{ pkgs, lib, ... }:
{

  imports = [
    ./home-utm-guest.nix
    ./gnome/gnome.nix
  ];

  programs.kitty = {
    font.size = 12;
  };

}
