# HM config common to all NixOS machines
{
  pkgs,
  ...
}:
{

  imports = [
    ./tmux/tmux-nixos.nix
  ];

  programs.git = {
    settings = {
      credential.helper = "store";
    };
  };

  services.ssh-agent.enable = true;

  home.packages = with pkgs; [
    # racket
    conky # https://github.com/brndnmtthws/conky
    gcc
    gdb
    heaptrack
    # docker
  ];
}
