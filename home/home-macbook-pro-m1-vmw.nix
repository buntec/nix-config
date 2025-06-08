{ pkgs, lib, ... }:
{
  imports = [
    ./home-vm-guest.nix
    ./home-vmware-guest.nix
    ./gnome/gnome.nix
  ];

}
