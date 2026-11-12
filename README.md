# My personal Nix configuration flake

Provides configurations for [NixOS](https://nixos.org/), [nix-darwin](https://github.com/LnL7/nix-darwin) and [Home Manager](https://github.com/nix-community/home-manager).

I mostly use modern Apple hardware (>= M1), and this flake also supports my Lenovo laptop.
For full-blown NixOS I recommend either [UTM](https://mac.getutm.app/) or [VMWare Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion).
I currently prefer to use the Nix package manager (w/ Home Manager) directly on macOS and inside [multipass](https://canonical.com/multipass) guests.
This gives me the best of both worlds of macOS and Linux with the escape hatch of being able to install apps outside the Nix ecosystem.
I've also mostly moved away from nix-darwin. Having to set up macOS from scratch is rare for me so the benefits of a fully declarative approach are minor.
I couldn't live without Home Manager, however.

## Setup guides

- [Fresh NixOS install on bare metal](docs/nixos-bare-metal.md)
- [macOS: fresh install and migrating an existing install](docs/macos.md)
- [NixOS VM inside macOS using UTM](docs/nixos-vm-utm.md)
- [NixOS VM inside macOS using VMware Fusion](docs/nixos-vm-vmware-fusion.md)
- [WSL](docs/wsl.md)
- [Credentials and editor tools](docs/credentials-and-editor-tools.md)

## Day-to-day usage

```bash
just --list             # discover all recipes
just nixos-switch       # build and activate the current NixOS host
just nix-darwin-switch  # build and activate the current macOS system configuration
just hm-switch          # build and activate Home Manager for the current host
just check              # formatting, lint, and flake checks
```

Each host also exposes runnable apps, e.g. `nix run .#rebuild-<host>` and
`nix run .#hm-switch-<host>`; see `nix flake show` for the full list.

## Layout

- `flake.nix`: inputs, host inventories, configurations, checks, and rebuild apps.
- `system/`: NixOS and nix-darwin host modules (`configuration-<host>.nix`) and shared system modules.
- `home/`: Home Manager entry points (`home-<host>.nix`) and feature modules.
- `extras/`: bootstrap support files.
- `docs/`: setup guides and notes.
