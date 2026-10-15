# HM config common to all nix-darwin machines
{ pkgs, machine, ... }:
let
  isAppleSilicon = machine.system == "aarch64-darwin";
in
{

  imports = [
    ./homebrew/homebrew.nix
  ];

  # Spotlight doesn't index symlinked app bundles; copy them instead.
  # (Default since stateVersion 25.11.)
  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = true;
  };

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
