{ config, pkgs, ... }:
{
  xdg.configFile."btmux/config.toml".text = ''
    prefix = "C-a"
    shell = "${pkgs.fish}/bin/fish"
    vi-mode = true
    colors = "${config.stylix.base16Scheme}"
  '';
}
