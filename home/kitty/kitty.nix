{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font.size = pkgs.lib.mkDefault 14; # might want to override in machine-specific module
    darwinLaunchOptions = [ "--single-instance" ];
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
