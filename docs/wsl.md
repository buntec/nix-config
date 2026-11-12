# WSL

Download the latest release from https://github.com/nix-community/NixOS-WSL/releases.
Double-click the `nixos.wsl` file to install.
Launch the distro from a Powershell with `wsl -d NixOS`.
Follow the instructions to update channels and rebuild/switch.
Create a nix shell with the required tools: `nix-shell -p git vim just`.
Clone this repo. If host hardware overrides are needed, generate them with
`sudo nixos-generate-config --show-hardware-config --no-filesystems > system/hardware/wsl.nix`.
Run `sudo nix run .#rebuild-wsl --experimental-features 'nix-command flakes'`.
In Windows Terminal change the command line for the NixOS profile to `C:\WINDOWS\system32\wsl.exe -d NixOS --user buntec`.
Open a new NixOS tab (now correctly logged in as `buntec` instead of `nixos`).
Clone once more this repo and do `just hm-switch` to build and activate HM.
