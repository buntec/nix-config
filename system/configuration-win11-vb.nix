{ config, pkgs, ... }:

{
  imports = [
    ./configuration-virtualbox-guest.nix
    ./gnome/gnome.nix
  ];

  networking.hostName = "win11-vb";
}
