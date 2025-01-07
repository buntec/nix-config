{ config, pkgs, ... }:

{
  imports = [
    ./configuration-utm-guest.nix
    ./gnome/gnome.nix
  ];

  networking.hostName = "macbook-pro-utm";
}
