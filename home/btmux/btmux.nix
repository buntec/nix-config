{ base16Scheme, pkgs, ... }:
{
  xdg.configFile."btmux/config.toml".text = ''
    prefix = "C-a"
    shell = "${pkgs.fish}/bin/fish"
    vi-mode = true

    colors = "${base16Scheme}"

    wallpaper-shader = "ink-flow"
    wallpaper-saturate = 1.00
    wallpaper-speed = 1.00
    wallpaper-fps = 60
    wallpaper-shader-follows-keyboard-input = true

    [wallpaper-shader-params."chroma-flow"]
    "intensity" = 1
    "momentum" = 25
    "radius" = 2

    [wallpaper-shader-params."ink-flow"]
    "curl" = 0
    "decay" = 2
    "momentum" = 0.5
    "radius" = 0.25

    [terminal]
    font-weight = 300
  '';
}
