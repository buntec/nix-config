# Bootstrapping a NixOS VM inside macOS using UTM

1. Download the latest minimal NixOS ISO for either ARM (Apple silicon) or Intel:
   - https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-aarch64-linux.iso
   - https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso

2. Create a new VM in UTM as follows:
   1. select "Virtualize";
   2. select "Linux";
   3. check "Use Apple Virtualization";
   4. set boot image to the ISO downloaded in Step 1;
   5. set VM memory to at least half the memory of the host;
   6. set VM CPU cores to at least half the cores of the host;
   7. set the VM drive to a reasonable size (e.g., 256G);
   8. select the folders you want to share from host to guest (e.g., your home directory);
   9. save the new VM;
   10. edit the new VM to enable the NVMe interface on the main drive and disable sound under "Virtualization".

3. Start the VM and boot into the NixOS installer.

4. Use `passwd` to set the password of the `nixos` user (choose something simple like `nixos`)

5. Note down the IP address of the guest by running `ip addr`.

6. On the host, execute `just bootstrap-mbp-utm <ip of guest>`. You will be prompted for the password from Step 4.
   This installs NixOS onto the VM via SSH using `nixos-anywhere`; it also builds and activates the Home Manager config.

7. Bootstrap prompts you to choose a password for `buntec` over SSH. Use that password for desktop login; it is preserved across rebuilds.
   From now on simply use `just nixos-switch` and `just hm-switch` etc. inside the VM to make configuration changes.
