{
  config,
  pkgs,
  machine,
  ...
}:
{
  wsl.enable = true;
  # changing the default username is too cumbersome:
  # https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
  # wsl.defaultUser = machine.user;
  networking.hostName = "wsl";
}
