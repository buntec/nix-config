{ config, pkgs, ... }:

{
  networking.hostName = "macbook-pro-m1-nixos";

  networking.interfaces.ens160.useDHCP = true;

  # We're running inside a VM!
  networking.firewall.enable = false;

  virtualisation.vmware.guest.enable = true;

  boot.loader.systemd-boot.consoleMode = "0";

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
}
