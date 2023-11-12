{ lib, pkgs, config, options, inputs, ... }:
with lib;
let
  cfg = config.colorscheme;

  isTokyonight = lib.strings.hasPrefix "tokyonight" cfg.name;
  tokyoNightStyle = lib.strings.removePrefix "tokyonight-" cfg.name;
  isCatppuccin = lib.strings.hasPrefix "catppuccin" cfg.name;
  catppuccinFlavor = lib.strings.removePrefix "catppuccin-" cfg.name;

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
        "catppuccin-latte"
        "catppuccin-frappe"
        "catppuccin-macchiato"
        "catppuccin-mocha"
      ];
      default = "tokyonight-storm";
    };
  };

  config = mkIf cfg.enable {

    programs.tmux.extraConfig = if isTokyonight then
      builtins.readFile
      "${inputs.tokyonight}/extras/tmux/tokyonight_${tokyoNightStyle}.tmux"
    else if isCatppuccin then ''
      set -g @catppuccin_flavour '${catppuccinFlavor}'
    '' else
      "";

    programs.tmux.plugins = with pkgs.tmuxPlugins;
      if isCatppuccin then [ catppuccin ] else [ ];

    programs.fish.interactiveShellInit = if isTokyonight then
      builtins.readFile
      "${inputs.tokyonight}/extras/fish/tokyonight_${tokyoNightStyle}.fish"
    else if isCatppuccin then ''
      fish_config theme save "Catppuccin ${catppuccinFlavor}"
    '' else
      "";

    programs.fish.plugins = if isCatppuccin then [{
      name = "catppuccin";
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
        sha256 = "";
      };
    }] else
      [ ];

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
