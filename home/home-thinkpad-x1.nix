{ pkgs, ... }:
{
  programs.kitty = {
    font.size = 10;
    extraConfig = ''
      hide_window_decorations yes
    '';
  };

  home.packages = with pkgs; [ texlive.combined.scheme-full ];

}
