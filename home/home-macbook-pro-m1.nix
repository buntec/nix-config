{ pkgs, ... }:
{

  imports = [ ./syncthing/syncthing.nix ];

  home.packages = [
    # pkgs.texlive.combined.scheme-full
  ];

  programs.kitty = {
    font.size = 12;
  };

}
