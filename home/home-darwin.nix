# HM config common to all nix-darwin machines
{ pkgs, machine, ... }:
let
  isAppleSilicon = machine.system == "aarch64-darwin";
in
{

  imports = [
    ./tmux/tmux-darwin.nix
  ];

  programs.ssh.extraConfig = ''
    UseKeychain yes
  '';

  home.sessionPath =
    if isAppleSilicon then
      [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
      ]
    else
      [
        "/usr/local/bin"
        "/usr/local/sbin"
      ];

}
