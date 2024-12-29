{ config, pkgs, ... }:
{
  imports = [ ./disko/disk-config.nix ];

  disko.devices.disk.disk1.device = "/dev/nvme0n1";

  virtualisation.vmware.guest.enable = true;

  # cannot change passwords
  users.mutableUsers = false;

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Mount host file system under /host; see https://github.com/NixOS/nixpkgs/issues/46529
  fileSystems."/host" = {
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
