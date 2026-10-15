host := `hostname`
SSH_OPTIONS := '-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=600'

# list recipes
default:
    just --list

# Reformat all sources (nix & lua)
format:
    nix fmt

# Run formatting, lint, and flake checks
check:
    nix fmt -- --fail-on-change
    statix check .
    nix flake check --impure

# rebuild NixOS config and switch
[linux]
nixos-switch:
    sudo nix run .#rebuild-{{ host }}

# rebuild nix-darwin config and switch
[macos]
nix-darwin-switch:
    nix run .#rebuild-{{ host }}

# rebuild Home Manager config and switch
[unix]
hm-switch:
    nix run -v .#hm-switch-{{ host }}
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
    # copy this repo - this conveniently gives us the generated hardware config
    rsync -av -e 'ssh -p {{ port }} {{ SSH_OPTIONS }}' . {{ user }}@{{ ip }}:~/nix-config
    # build and activate Home Manager config
    ssh {{ SSH_OPTIONS }} -v {{ user }}@{{ ip }} 'cd nix-config; just hm-switch'

[macos]
bootstrap-mbp-vmw ip: (bootstrap-vm ip '22' 'macbook-pro-vmw' 'buntec')

[macos]
bootstrap-mbp-utm ip: (bootstrap-vm ip '22' 'macbook-pro-utm' 'buntec')

bootstrap-win11-vb ip port: (bootstrap-vm ip port 'win11-vb' 'buntec')

multipass-create-instance:
    multipass launch --name nix -c 8 -m 12G -d 128G --mount ~:/home/christoph/host --cloud-init extras/cloud-config/multipass.yml
