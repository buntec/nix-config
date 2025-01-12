# HM config common to all nix-darwin machines
{ pkgs, ... }:
{

  imports = [
    ./tmux/tmux-darwin.nix
  ];

  programs.ssh.extraConfig = ''
    UseKeychain yes
  '';

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

}
