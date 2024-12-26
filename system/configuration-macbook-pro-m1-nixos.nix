{ config, pkgs, ... }:

{
  networking.hostName = "macbook-pro-m1-nixos"; # Define your hostname.

  virtualisation.vmware.guest.enable = true;
}
