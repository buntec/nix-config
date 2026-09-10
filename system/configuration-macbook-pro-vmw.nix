{ config, pkgs, ... }:

{
  imports = [
    ./configuration-vmware-guest.nix
    ./gnome/gnome.nix
  ];

  networking.hostName = "macbook-pro-vmw";
}
