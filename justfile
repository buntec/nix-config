host := `hostname`

SSH_OPTIONS := '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=600'

# list recipes
default:
    just --list

# Reformat all sources (nix & lua)
format:
  nix fmt

# rebuild NixOS config and switch
[linux]
nixos-switch:
    sudo nix run .#rebuild-{{ host }}

# rebuild Home Manager config and switch; mode='light'|'dark'
[unix]
hm-switch mode='light':
    nix run .#hm-switch-{{ host }}-{{ mode }}
    # reload tmux config
    tmux source-file ~/.config/tmux/tmux.conf
    # reload fish config
    fish -c 'reload_all_fish_instances'

# rebuild nix-darwin config and switch
[macos]
nix-darwin-switch:
    nix run .#rebuild-{{ host }}

# clean up nix store by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d


# install NixOS & HM on fresh VM (see README.md)
[private]
bootstrap-vm ip attr user:
    nix run github:nix-community/nixos-anywhere -- \
    --flake '.#{{ attr }}' \
    --ssh-option 'UserKnownHostsFile=/dev/null' \
    --ssh-option 'StrictHostKeyChecking=no' \
    --build-on-remote \
    --generate-hardware-config nixos-generate-config ./system/hardware-configuration.nix \
    --target-host nixos@{{ ip }}
    # copy ssh keys
    rsync -av -e 'ssh {{ SSH_OPTIONS }}' ~/.ssh/ {{ user }}@{{ ip }}:~/.ssh
    # copy this repo - this conveniently gives us the generated hardware config
    rsync -av -e 'ssh {{ SSH_OPTIONS }}' . {{ user }}@{{ ip }}:~/nix-config
    # build and activate Home Manager config
    ssh {{ SSH_OPTIONS }} -v {{ user }}@{{ ip }} 'cd nix-config; just hm-switch'

[macos]
bootstrap-mbp-vmw ip: (bootstrap-vm ip 'macbook-pro-m1-vmw' 'buntec')

[macos]
bootstrap-mbp-utm ip: (bootstrap-vm ip 'macbook-pro-m1-utm' 'buntec')
