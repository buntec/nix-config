{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    darwinLaunchOptions = [ "--single-instance" ];
    extraConfig = builtins.readFile ./kitty.conf;
  };
}
