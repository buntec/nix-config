{ config, pkgs, ... }:
{
  imports = [
    ./configuration-vm-guest.nix
  ];

  disko.devices.disk.disk1.device = "/dev/nvme0n1";

  virtualisation.vmware.guest.enable = true;

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
