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
