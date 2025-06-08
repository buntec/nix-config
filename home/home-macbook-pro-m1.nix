{ pkgs, ... }:
{

  imports = [ ./syncthing/syncthing.nix ];

  home.packages = [
    # pkgs.texlive.combined.scheme-full
  ];

}
