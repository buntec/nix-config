{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  programs.stylua.enable = true;
  settings.formatter.nixfmt.excludes = [ "hardware-configuration.nix" ];
}
