host := `hostname`

light := 'light'
dark := 'dark'

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
