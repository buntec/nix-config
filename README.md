# My personal Nix configuration flake

Configures [NixOS](https://nixos.org/)/[nix-darwin](https://github.com/LnL7/nix-darwin)
and [Home Manager](https://github.com/nix-community/home-manager) on my personal machines.

For Apple hardware I recommend running NixOS on either [UTM](https://mac.getutm.app/)
or [VMWare Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) guests inside macOS (see instructions below).
While nix-darwin and Home Manager on macOS work reasonably well most of the time,
there are still some rough edges, e.g., macOS updates [breaking your nix installation](https://github.com/NixOS/nix/issues/3616).
Moreover, not all packages in [nixpkgs](https://github.com/NixOS/nixpkgs) support macOS. (See also https://discourse.nixos.org/t/darwin-again/29331).
The best experience, in my opinion, is therefore running an honest-to-God NixOS on a VM hosted inside macOS.
With UTM and VMWare Fusion we can have the best of both worlds. Indeed, both natively support Apple Silicon and their
virtualization performance should be close to native when running ARM NixOS. Fusion even supports full 3D acceleration, if that is important to you.

## Fresh NixOS install

After installing NixOS from a USB drive, follow these steps:

1. Clone this repo and `cd` into it.

2. Copy `/etc/nixos/hardware-configuration.nix` into `./system` (OK to overwrite existing dummy file).

3. Build and activate NixOS config:

```bash
sudo nixos-rebuild switch --flake .#thinkpad-x1 # the fragment can be dropped if it matches your current host name

# alternatively, using the `apps` provided by the flake:
sudo nix run .#rebuild-thinkpad-x1
```

4. Activate home-manager:

```bash
nix run .#hm-switch-thinkpad-x1
```

### Notes:

On a ThinkPad X1 you might have to remove the line

```
hardware.video.hidpi.enable = lib.mkDefault true;
```

from `hardware-configuration.nix` if `nixos-rebuild` complains about this option having no effect.

## Fresh macOS install

(Inspired by this [gist](https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050).)

To bootstrap a fresh macOS install, follow these steps:

1. Install Homebrew (only needed for managing GUI apps via casks)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install Nix:

```bash
curl -L https://nixos.org/nix/install | sh
```

3. Enable flakes

```bash
mkdir -p ~/.config/nix
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF
```

4. (Probably no longer needed.) To work around this [issue](https://github.com/LnL7/nix-darwin/issues/149)

```bash
sudo mv /etc/nix/nix.conf /etc/nix/.nix-darwin.bkp.nix.conf
```

5. Clone this repo, `cd` into it, then build and activate:

```bash
nix run .#rebuild-macbook-pro-m1 # nix-darwin
nix run .#hm-switch-macbook-pro-m1 # home-manager
```

## Migrating an existing macOS install to Nix

1. Uninstall Homebrew:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

2. Delete everything under `~/.config` and any other "dot files" in your home directory.

3. Delete all applications that are listed as Homebrew casks in `./system/configuration-darwin.nix`

4. Follow the steps for a fresh macOS install.

## Bootstrapping a NixOS VM inside macOS using UTM

1. Download the latest minimal NixOS ISO for either ARM (recommended for modern Macs with Apple silicon) or Intel:
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

7. The VM should be ready to log into with your user and password (not the one in Step 5, of course).
   From now on simply use `just nixos-switch` and `just hm-switch` etc. inside the VM to make configuration changes.

## Bootstrapping a NixOS VM inside macOS using VMware Fusion

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

8. The VM should be ready to log into with your user and password (not the one in Step 5, of course).
   From now on simply use `just nixos-switch` and `just hm-switch` etc. inside the VM to make configuration changes.

### Notes:

- Do not regenerate `hardware-configuration.nix` using `nixos-generate-config` on the VM as the generated file
  will have conflicting settings for the file system, which is managed by `disko`. (You can make it work by commenting out
  the file system settings.) Instead, keep the file that was copied during the bootstrap (but don't commit it).
- You may have to set the display scaling in Gnome manually.
- If the `nix-config` repo copied during the bootstrap was set up to connect to the remote using http,
  you have to change it to ssh before being able to push: `git remote set-url origin git@github.com:buntec/nix-config.git`

## WSL

Download the latest release from https://github.com/nix-community/NixOS-WSL/releases.
Double-click the `nixos.wsl` file to install.
Launch the distro from a Powershell with `wsl -d NixOS`.
Follow the instructions to update channels and rebuild/switch.
Create a nix shell with the required tools: `nix-shell -p git vim just`.
Clone this repo and do `nixos-generate-config` to generate `/etc/nixos/hardware-configuration.nix`.
Overwrite `system/hardware-configuration` with the generated config but remove all file system mounts.
Run `sudo nix run .#rebuild-wsl-dark --experimental-features 'nix-command flakes'`.
In Windows Terminal change the command line for the NixOS profile to `C:\WINDOWS\system32\wsl.exe -d NixOS --user buntec`.
Open a new NixOS tab (now correctly logged in as `buntec` instead of `nixos`).
Clone once more this repo and do `just hm-switch` to build and activate HM.
