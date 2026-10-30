{ config, ... }:
{
  # Trust repositories shared from the host, while retaining ownership checks elsewhere.
  programs.git.settings.safe.directory = [ "${config.home.homeDirectory}/host/*" ];

  # Headless guest: no desktop launchers.
  programs.btmux.desktop.enable = false;
}
