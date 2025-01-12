# HM config common to all UTM guests
{ pkgs, lib, ... }:
{

  imports = [
    ./home-vm-guest.nix
  ];

}
