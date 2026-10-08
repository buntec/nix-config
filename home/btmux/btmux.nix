{ config, pkgs, ... }:
{
  xdg.configFile."btmux/config.toml".text = ''
    prefix = "C-a"
    shell = "${pkgs.fish}/bin/fish"
    vi-mode = true

    colors = "${config.stylix.base16Scheme}"

    wallpaper-shader = "chroma-flow"
    wallpaper-opacity = 0.30
    wallpaper-saturate = 0.50
    wallpaper-speed = 3.00
    wallpaper-shader-follows-keyboard-input = true

    [wallpaper-shader-params."chroma-flow"]
    "intensity" = 1
    "momentum" = 25
    "radius" = 2

    [terminal]
    font-weight = 300
  '';
}
