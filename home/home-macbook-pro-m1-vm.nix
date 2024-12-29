{ pkgs, lib, ... }:
{
  imports = [ ./home-vm-guest.nix ];

  programs.kitty = {
    font.size = 12;
  };

}
