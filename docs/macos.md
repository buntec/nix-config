# macOS

## Fresh macOS install

(Inspired by this [gist](https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050).)

To bootstrap a fresh macOS install, follow these steps:

1. Install Homebrew (used by Home Manager for GUI apps via casks)

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
   manages the selected casks during Home Manager activation.

3. Follow the fresh-install steps, skipping software already installed. If Home Manager
   reports a conflicting file, move that specific file to a backup location and retry.
   Review any existing application that conflicts with a cask individually.
