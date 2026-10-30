# HM config common to all NixOS machines
{ pkgs, ... }:
{

  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    # racket
    gcc
    gdb
    heaptrack
    # docker
  ];
}
