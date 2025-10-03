{
  config,
  pkgs,
  machine,
  ...
}:
{
  wsl.enable = true;
  wsl.defaultUser = machine.user;
  networking.hostName = "wsl";
}
