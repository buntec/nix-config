# My personal Nix configuration flake

Provides configurations for [NixOS](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager).

I mostly use modern Apple hardware (>= M1), and this flake also supports my Lenovo laptop.
For full-blown NixOS I recommend either [UTM](https://mac.getutm.app/) or [VMWare Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion).
Both approaches are described in detail below.
I currently prefer to use the Nix package manager (w/ Home Manager) directly on macOS and inside [multipass](https://canonical.com/multipass) guests.
This gives me the best of both worlds of macOS and Linux with the escape hatch of being able to install apps outside the Nix ecosystem.
I've also mostly moved away from nix-darwin. Having to set up macOS from scratch is rare for me so the benefits of a fully declarative approach are minor.
I couldn't live without Home Manager, however.

## Fresh NixOS install on bare metal

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

### Notes:

On a 7th-gen ThinkPad X1 carbon you might have to remove the line

```
hardware.video.hidpi.enable = lib.mkDefault true;
```

from `hardware-configuration.nix` if `nixos-rebuild` complains about this option having no effect.

## Fresh macOS install

(Inspired by this [gist](https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050).)

To bootstrap a fresh macOS install, follow these steps:

1. Install Homebrew (used by Home Manager for GUI apps and selected development tools)

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
nix run .#rebuild-macbook-pro # nix-darwin
nix run .#hm-switch-macbook-pro # home-manager
```

## Migrating an existing macOS install to Nix

1. Back up existing shell and application configuration before activating Home Manager.

2. Keep the existing Homebrew installation. The bundle in `home/homebrew/homebrew.nix`
   manages the selected casks and development tools during Home Manager activation.

3. Follow the fresh-install steps, skipping software already installed. If Home Manager
   reports a conflicting file, move that specific file to a backup location and retry.
   Review any existing application that conflicts with a cask individually.

## Bootstrapping a NixOS VM inside macOS using UTM

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

8. Bootstrap prompts you to choose a password for `buntec` over SSH. Use that password for desktop login; it is preserved across rebuilds.
   From now on simply use `just nixos-switch` and `just hm-switch` etc. inside the VM to make configuration changes.

### Notes:

- Bootstrap generates and imports `system/hardware/<host>.nix` for the selected VM,
  without filesystem definitions because disko manages those. Keep the generated file
  with that VM's checkout; bootstrap restores the placeholder in the host's checkout. To regenerate it, run
  `sudo nixos-generate-config --show-hardware-config --no-filesystems > system/hardware/<host>.nix`.
  Bootstrapping another VM no longer overwrites the ThinkPad hardware configuration.
- You may have to set the display scaling in Gnome manually.

## WSL

Download the latest release from https://github.com/nix-community/NixOS-WSL/releases.
Double-click the `nixos.wsl` file to install.
Launch the distro from a Powershell with `wsl -d NixOS`.
Follow the instructions to update channels and rebuild/switch.
Create a nix shell with the required tools: `nix-shell -p git vim just`.
Clone this repo. If host hardware overrides are needed, generate them with
`sudo nixos-generate-config --show-hardware-config --no-filesystems > system/hardware/wsl.nix`.
Run `sudo nix run .#rebuild-wsl --experimental-features 'nix-command flakes'`.
In Windows Terminal change the command line for the NixOS profile to `C:\WINDOWS\system32\wsl.exe -d NixOS --user buntec`.
Open a new NixOS tab (now correctly logged in as `buntec` instead of `nixos`).
Clone once more this repo and do `just hm-switch` to build and activate HM.

## Credentials and editor tools

Pushes to GitHub over `https://` remotes are rewritten to SSH (`url.pushInsteadOf`), so no Git
credential helper is configured and the SSH key is used. If an earlier configuration used the
`store` helper, review and remove `~/.git-credentials`; changing the config does not remove that file.
Multipass trusts Git repositories only under `/home/christoph/host/`.

Neovim uses Pyrefly. Pyrefly, ty and Ruff come from nixpkgs on every host; on macOS the
Homebrew bundle also installs them with uv to follow upstream releases, and those builds
in `~/.local/bin` precede the Nix profile on `PATH`.
Clangd, the Java server, and the C# server are provided by Nix. Rust Analyzer uses
Rustup; install it for the selected toolchain with `rustup component add rust-analyzer`.
Treesitter includes all grammars packaged in nixpkgs. Multipass omits desktop
launchers and GNOME-only tools while retaining the shared development environment.
