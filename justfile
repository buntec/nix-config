host := `hostname`
SSH_OPTIONS := '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=600'

# list recipes
default:
    just --list

# Reformat all sources (nix & lua)
format:
    nix fmt

# rebuild NixOS config and switch; mode='light'|'dark'
[linux]
nixos-switch mode='dark':
    sudo nix run .#rebuild-{{ host }}-{{ mode }}

# rebuild nix-darwin config and switch; mode='light'|'dark'
[macos]
nix-darwin-switch mode='dark':
    nix run .#rebuild-{{ host }}-{{ mode }}

# rebuild Home Manager config and switch; mode='light'|'dark'
[unix]
hm-switch mode='dark':
    nix run .#hm-switch-{{ host }}-{{ mode }}
    # reload tmux config
    tmux source-file ~/.config/tmux/tmux.conf
    # reload fish config
    fish -c 'reload_all_fish_instances'

# clean up nix store by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d

# install NixOS & HM on fresh VM (see README.md)
[private]
bootstrap-vm ip port attr user:
    nix run github:nix-community/nixos-anywhere -- \
    --flake '.#{{ attr }}' \
    --ssh-option 'UserKnownHostsFile=/dev/null' \
    --ssh-option 'StrictHostKeyChecking=no' \
    --ssh-port {{ port }} \
    --build-on remote \
    --disko-mode disko \
    --generate-hardware-config nixos-generate-config ./system/hardware-configuration.nix \
    --target-host nixos@{{ ip }}
    # wait for VM to reboot
    sleep 30
    # copy ssh keys
    rsync -av -e 'ssh -p {{ port }} {{ SSH_OPTIONS }}' ~/.ssh/ {{ user }}@{{ ip }}:~/.ssh
    # copy this repo - this conveniently gives us the generated hardware config
    rsync -av -e 'ssh -p {{ port }} {{ SSH_OPTIONS }}' . {{ user }}@{{ ip }}:~/nix-config
    # build and activate Home Manager config
    ssh {{ SSH_OPTIONS }} -v {{ user }}@{{ ip }} 'cd nix-config; just hm-switch'

[macos]
bootstrap-mbp-vmw ip: (bootstrap-vm ip '22' 'macbook-pro-m1-vmw-dark' 'buntec')

[macos]
bootstrap-mbp-utm ip: (bootstrap-vm ip '22' 'macbook-pro-m1-utm-dark' 'buntec')

bootstrap-win11-vb ip port: (bootstrap-vm ip port 'win11-vb-dark' 'buntec')
