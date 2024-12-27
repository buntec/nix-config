host := `hostname`

# list recipes
default:
    just --list

# rebuild NixOS config and switch
[linux]
nixos-switch:
    sudo nix run .#rebuild-{{ host }}

# rebuild Home Manager config and switch
[unix]
hm-switch:
    nix run .#hm-switch-{{ host }}

# rebuild nix-darwin config and switch
[macos]
nix-darwin-switch:
    nix run .#rebuild-{{ host }}
