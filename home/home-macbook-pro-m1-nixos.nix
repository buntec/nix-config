{ pkgs, ... }:
{

  programs.kitty = {
    font.size = 12;
    extraConfig = ''
      hide_window_decorations yes
    '';
  };

  # Set display scaling to 200%; everything is just too small otherwise on a retina display
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      scaling-factor = 2;
    };
  };

}
