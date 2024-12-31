host := `hostname`
user := 'buntec'
dark := 'dark'
light := 'light'

SSH_OPTIONS := '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# list recipes
default:
    just --list

# rebuild NixOS config and switch
[linux]
nixos-switch:
    sudo nix run .#rebuild-{{ host }}

# rebuild Home Manager config and switch
[unix]
hm-switch mode=light:
    nix run .#hm-switch-{{ host }}-{{ mode }}
    # reload tmux config
    tmux source-file ~/.config/tmux/tmux.conf

# rebuild nix-darwin config and switch
[macos]
nix-darwin-switch:
    nix run .#rebuild-{{ host }}

# clean up nix store by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d

# install NixOS on fresh VM running inside a MacBook Pro host (see README.md)
[macos]
bootstrap-vm ip:
    nix run github:nix-community/nixos-anywhere -- \
    --flake '.#macbook-pro-m1-vm' \
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
