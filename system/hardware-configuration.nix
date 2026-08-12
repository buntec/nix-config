# Placeholder for clean-clone evaluation and CI.
# Replace this file with the host's generated hardware configuration before
# activating a bare-metal NixOS installation.
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
