# HM config common to all VirtualBox guests
{ pkgs, lib, ... }:
{

  imports = [
    ./home-vm-guest.nix
  ];

}
