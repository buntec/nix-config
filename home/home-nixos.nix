{
  pkgs,
  lib,
  mode,
  ...
}:
{

  imports = [
    ./gnome/gnome.nix
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

  home.packages = with pkgs; [ docker ];
}
