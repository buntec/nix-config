{ pkgs, ... }:
{

  programs.ssh.extraConfig = ''
    UseKeychain yes
  '';

}
