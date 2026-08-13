{ pkgs, ... }:
{
  xdg.configFile."btmux/config.toml".text = ''
    prefix = "C-a"
    shell = "${pkgs.fish}/bin/fish"
    vi-mode = true
    animations = true
    wallpaper = "https://images.unsplash.com/photo-1774998861301-5acc6fdfcf63"
    wallpaper-opacity = 0.025
    session-sort = "mru"
    wallpaper-saturate = 0.5
    window-grid-count = 4
    window-sort = "alphabetical"
    show-pane-titles = false
    pane-switch-intensity = 0.25
    pane-switch-duration = 0.5

    [terminal]
    cursor-blink = true
    cursor-style = "bar"
    font-size = 18.0
    font-family = "Geist Mono"
    font-weight = 400
    renderer = "webgl"
    scrollback = 100000
    scroll-sensitivity = 5.0

    [log]
    console-level = "warn"
    file-level = "info"
  '';
}
