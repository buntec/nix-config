{ config, pkgs, ... }:
{
  imports = [ ./disk-config.nix ];

  disko.devices.disk.disk1.device = "/dev/nvme0n1";

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # We're using VMware Fusion
  virtualisation.vmware.guest.enable = true;

  networking.hostName = "macbook-pro-m1-nixos";
  networking.firewall.enable = false; # We're running inside a VM!
  networking.interfaces.ens160.useDHCP = true;

  # Quoting from https://github.com/mitchellh/nixos-config:
  #
  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  #
  boot.loader.systemd-boot.consoleMode = "0";

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
