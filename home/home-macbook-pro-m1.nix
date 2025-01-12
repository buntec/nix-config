{ pkgs, ... }:
{

  imports = [ ./syncthing/syncthing.nix ];

  home.packages = with pkgs; [ texlive.combined.scheme-full ];

  programs.kitty = {
    font.size = 12;
  };

}
