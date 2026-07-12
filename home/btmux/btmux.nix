{ pkgs, ... }:
{
  xdg.configFile."btmux/config.toml".text = ''
    prefix = "C-a"
    shell = "${pkgs.fish}/bin/fish"
    vi-mode = true
    wallpaper = "~/Downloads/note-thanun-KKuX3OhsfoE-unsplash.jpg"
    wallpaper-opacity = 0.025
    session-sort = "mru"
    window-grid-count = 4

    [terminal]
    font-size = 18.0
    font-family = "Geist Mono"
    font-weight = 400
  '';
}
