{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.colorscheme;

  isTokyonight = lib.strings.hasPrefix "tokyonight" c.name;
  tokyoNightStyle = lib.strings.removePrefix "tokyonight-" c.name;
  isCatppuccin = lib.strings.hasPrefix "catppuccin" c.name;
  catppuccinFlavor = lib.strings.removePrefix "catppuccin-" c.name;

in {

  options.colorscheme = {
    enable =
      mkEnableOption "a global colorscheme for kitty, fish, tmux and nvim";
    name = mkOption {
      type = types.enum [
        "tokyonight-storm"
        "tokyonight-moon"
        "tokyonight-night"
        "tokyonight-day"
        "catppuccin-mocca"
        "catppuccin-latte"
        "catppuccin-frappe"
        "catppuccin-macchiato"
        "catppuccin-mocha"
      ];
      default = "tokyonight-storm";
    };
  };

  config = mkIf cfg.enable {

    programs.tmux.extraConfig =
      if isTokyonight then builtins.readFile ./tmux/${cfg.name}.conf else "";

    program.fish.interractiveShellInit =
      if isTokyonight then builtins.readFile ./fish/${cfg.name}.conf else "";

    programs.neovim.plugins = if isTokyonight then [{
      plugin = pkgs.vimPlugins.tokyonight-nvim;
      type = "lua";
      config = ''
        local tokyonight_style = ${tokyoNightStyle}
        ${builtins.readFile ./nvim/tokyonight.lua}
      '';
    }] else if isCatppuccin then [{
      plugin = pkgs.vimPlugins.catppuccin-nvim;
      type = "lua";
      config = ''
        local catppuccin_flavor = ${catppuccinFlavor}
        ${builtins.readFile ./nvim/catppuccin.lua}
      '';
    }] else
      [ ];

  };

}
