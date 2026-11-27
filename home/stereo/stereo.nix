{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  stereoPkgs = inputs.stereo.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.stereo.homeManagerModules.default ];

  programs.stereo = {
    enable = true;
    package = stereoPkgs.default;

    service.tailscale = true;

    desktop.enable = lib.mkDefault true;
    desktop.package = stereoPkgs.desktop;
  };
}
