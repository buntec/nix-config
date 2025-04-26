{ pkgs, lib, ... }:
{
  imports = [
    ./home-vm-guest.nix
    ./home-virtualbox-guest.nix
    ./gnome/gnome.nix
  ];

  programs.kitty = {
    font.size = 12;
  };

}
