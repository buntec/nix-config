{ config, pkgs, ... }:
{
  imports = [ ./disko/disk-config.nix ];

  disko.devices.disk.disk1.device = "/dev/nvme0n1";

  virtualisation.vmware.guest.enable = true;

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
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Mount shared folder - see https://github.com/NixOS/nixpkgs/issues/46529
  fileSystems."/mnt/host" = {
    device = ".host:/";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = [
      "umask=22"
      "uid=1000"
      "gid=100"
      "allow_other"
      "defaults"
      "auto_unmount"
    ];
  };

}
