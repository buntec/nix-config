# NixOS config common to all VM guests
{ config, pkgs, ... }:
{
  imports = [
    ./disko/disk-config.nix
  ];

  # Make it easy to reach services running in guest from host.
  networking.firewall.enable = false;

  # cannot change passwords
  users.mutableUsers = false;

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILp/zFH8Vb2GDOt4xSgjzRTYUULvPuJdb6MUnWvX7jbX christophbunte@gmail.com"
    ];
  };

  services.openssh.settings.PasswordAuthentication = true;

  boot.loader.grub = {
    enable = true;
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Mount shared folder
  fileSystems."/mnt/host" = {
    device = "share";
    fsType = "virtiofs";
    options = [
      "rw"
      "nofail"
    ];
  };

}
