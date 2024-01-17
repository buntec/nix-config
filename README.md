# My personal Nix configuration flake

Configures my personal machines (NixOS and macOS).

If you spot any errors or mistakes, feel free to open a pull request!

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
sudo nix run .#hm-switch-thinkpad-x1
```

### Notes: 

On a Thinkpad X1 you might have to remove the line 

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
