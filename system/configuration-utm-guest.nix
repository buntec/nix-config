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

  # Mount shared folder using virtfs
  # https://docs.getutm.app/guest-support/linux/#virtfs
  fileSystems."/mnt/share/from-utm" = {
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
  fileSystems."/mnt/host" = {
    device = "/mnt/share/from-utm";
    depends = [ "/mnt/share/from-utm" ];
    fsType = "fuse.bindfs";
    # https://docs.getutm.app/guest-support/linux/#fixing-permission-errors
    options = [
      "map=501/1000:@20/@1000"
      "nofail"
    ];
  };

}
