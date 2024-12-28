host := `hostname`
dark := 'dark'
light := 'light'

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

# rebuild nix-darwin config and switch
[macos]
nix-darwin-switch:
    nix run .#rebuild-{{ host }}

# clean up by removing old generations etc.
[unix]
collect-garbage:
    nix-collect-garbage -d

[unix]
remote-install-nixos ip:
    nix run github:nix-community/nixos-anywhere -- \
    --flake '.#macbook-pro-m1-nixos' \
    --build-on-remote \
    --generate-hardware-config nixos-generate-config ./system/hardware-configuration.nix \
    --target-host nixos@{{ ip }}
