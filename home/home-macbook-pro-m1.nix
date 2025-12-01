{ pkgs, ... }:
{

  imports = [ ./syncthing/syncthing.nix ];

  home.packages = [
    # pkgs.texlive.combined.scheme-full
  ];

  # Neovim GUI - https://neovide.dev/
  programs.neovide = {
    enable = true;
    settings = { };
  };

  programs.yt-dlp = {
    enable = true;
  };
}
