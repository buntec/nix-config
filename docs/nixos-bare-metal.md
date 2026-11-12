# Fresh NixOS install on bare metal

After installing NixOS from a USB drive, follow these steps:

1. Clone this repo and `cd` into it.

2. Copy `/etc/nixos/hardware-configuration.nix` to `system/hardware/thinkpad-x1.nix`, replacing the placeholder. Keep this host-specific file local unless you intend to commit its hardware details.

3. Build and activate NixOS config:

```bash
sudo nix run .#rebuild-thinkpad-x1
```

4. Ensure the account has a desktop login password (`sudo passwd buntec`). Existing passwords are preserved across rebuilds. Then build and activate Home Manager:

```bash
nix run .#hm-switch-thinkpad-x1
```

# Notes:

On a 7th-gen ThinkPad X1 carbon you might have to remove the line

```
hardware.video.hidpi.enable = lib.mkDefault true;
```

from `hardware-configuration.nix` if `nixos-rebuild` complains about this option having no effect.
