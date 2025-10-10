{ pkgs, lib, ... }:
{
  programs.git.extraConfig = {
    safe.directory = "*";
  };

}
