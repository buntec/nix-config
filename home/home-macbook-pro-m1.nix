{ pkgs, ... }:
{

  imports = [ ./syncthing/syncthing.nix ];

  home.packages = with pkgs; [ texlive.combined.scheme-full ];

}
