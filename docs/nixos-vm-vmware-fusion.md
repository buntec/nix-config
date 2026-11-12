# Bootstrapping a NixOS VM inside macOS using VMware Fusion

(Inspired by https://github.com/mitchellh/nixos-config)

1. Download the latest minimal NixOS ISO for either ARM (recommended for modern Macs with Apple silicon) or Intel:
   - https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-aarch64-linux.iso
   - https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso

2. Create a new VM in VMware Fusion using the image above. Select "Other Linux 6.x Kernel ..." (current at time of writing).

3. Customize the VM settings as follows:
   1. Enable shared folders and add folders as desired (e.g., I like to share `~/Downloads` from host to guest).
   2. Disable default applications.
   3. Create a keyboard & mouse profile where (almost) all key mappings and shortcuts are disabled.
      This creates the most immersive experience and avoids conflicts when working in the VM.
   4. Give at least half of the available CPU cores and RAM.
   5. Enable 3D hardware acceleration with max shared memory; enable full retina resolution.
   6. Set a reasonable disk size, e.g., 250GB.
   7. Remove the sound card and camera.

4. Start the VM, select the NixOS installer from the boot menu and wait to be dropped into a shell as user `nixos`.

5. Set a simple password for the `nixos` user using `passwd` (I set it to `nixos`). It will only be used during installation.

6. Note down the IP address of the guest using `ip addr`.

7. On the host, execute `just bootstrap-mbp-vmw <ip of guest>`. You will be prompted for the password from Step 5.
   This installs NixOS onto the VM via SSH using `nixos-anywhere`; it also builds and activates the Home Manager config.

8. Bootstrap prompts you to choose a password for `buntec` over SSH. Use that password for desktop login; it is preserved across rebuilds.
   From now on simply use `just nixos-switch` and `just hm-switch` etc. inside the VM to make configuration changes.

# Notes:

- Bootstrap generates and imports `system/hardware/<host>.nix` for the selected VM,
  without filesystem definitions because disko manages those. Keep the generated file
  with that VM's checkout; bootstrap restores the placeholder in the host's checkout. To regenerate it, run
  `sudo nixos-generate-config --show-hardware-config --no-filesystems > system/hardware/<host>.nix`.
  Bootstrapping another VM no longer overwrites the ThinkPad hardware configuration.
- You may have to set the display scaling in Gnome manually.
