{ pkgs, ... }:
{

  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };
}
