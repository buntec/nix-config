{ pkgs, ... }:
{

  programs.ssh.extraConfig = ''
    UseKeychain yes
  '';

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

}
