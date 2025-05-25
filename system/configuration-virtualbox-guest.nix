{ config, pkgs, ... }:
{
  imports = [
    ./configuration-vm-guest.nix
  ];

  disko.devices.disk.disk1.device = "/dev/sda";

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.clipboard = true;
  virtualisation.virtualbox.guest.dragAndDrop = false;

}
