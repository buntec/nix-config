{ pkgs, mode, ... }:
{
  xdg.configFile."btmux/config.toml".text = ''
    prefix = "C-a"
    shell = "${pkgs.fish}/bin/fish"
    vi-mode = true
    colors = "https://raw.githubusercontent.com/buntec/kauz/refs/heads/main/base24/kauz-${mode}.yml"
  '';
}
