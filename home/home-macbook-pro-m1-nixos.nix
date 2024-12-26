{ pkgs, ... }:
{

  programs.kitty = {
    font.size = 12;
    extraConfig = ''
      hide_window_decorations yes
    '';
  };

}
