{ pkgs, lib, ... }:
{
  programs.git = {
    settings = {
      safe.directory = "*";
    };
  };

}
