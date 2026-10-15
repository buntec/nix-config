# HM config common to all nix-darwin machines
{ pkgs, machine, ... }:
let
  isAppleSilicon = machine.system == "aarch64-darwin";
in
{

  imports = [
    ./homebrew/homebrew.nix
  ];

  programs.ssh.extraConfig = ''
    UseKeychain yes
  '';

  # Don't rely on the parent process (e.g. the btmux launchd agent) to put
  # the Nix profiles on PATH; there is no /etc/fish to do it either.
  programs.fish.shellInit = ''
    if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    end
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
