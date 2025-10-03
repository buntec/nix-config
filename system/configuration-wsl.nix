{
  config,
  pkgs,
  ...
}:
{
  wsl.enable = true;
  networking.hostName = "wsl";
}
