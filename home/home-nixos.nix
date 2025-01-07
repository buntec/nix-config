{
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./tmux/tmux-nixos.nix
  ];

  programs.git = {
    extraConfig = {
      credential.helper = "store";
    };
  };

  programs.kitty = {
    extraConfig = ''
      hide_window_decorations yes
    '';
  };

  home.packages = with pkgs; [
    conky # https://github.com/brndnmtthws/conky
    docker
  ];
}
