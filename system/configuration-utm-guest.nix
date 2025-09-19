{ config, pkgs, ... }:
{
  imports = [
    ./configuration-vm-guest.nix
  ];

  disko.devices.disk.disk1.device = "/dev/nvme0n1";

  # Qemu
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # TODO: is this really needed?
  environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

  fileSystems = {
    # VirtioFS shared folder (Apple Virtualization)
    "/mnt/host/apple" = {
      fsType = "virtiofs";
      device = "share";
      options = [
        "rw"
        "nofail"
      ];
    };

    # Mount shared folder using virtfs (QEMU)
    # https://docs.getutm.app/guest-support/linux/#virtfs
    "/mnt/share/from-utm" = {
      device = "share";
      fsType = "9p";
      options = [
        "trans=virtio"
        "version=9p2000.L"
        "rw"
        "_netdev"
        "nofail"
      ];
    };

    # this fixes permission issues
    "/mnt/host/qemu" = {
      device = "/mnt/share/from-utm";
      depends = [ "/mnt/share/from-utm" ];
      fsType = "fuse.bindfs";
      # https://docs.getutm.app/guest-support/linux/#fixing-permission-errors
      options = [
        "map=501/1000:@20/@1000"
        "nofail"
      ];
    };

  };

}
