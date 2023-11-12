{ lib, pkgs, config, options, inputs, ... }:
with lib;
let
  cfg = config.colorscheme;

  isTokyonight = lib.strings.hasPrefix "tokyonight" cfg.name;
  tokyoNightStyle = lib.strings.removePrefix "tokyonight-" cfg.name;
  tokyoNightKittyTheme = {
    tokyonight-moon = "Tokyo Night Moon";
    tokyonight-storm = "Tokyo Night Storm";
    tokyonight-night = "Tokyo Night Night";
    tokyonight-day = "Tokyo Night Day";
  };
  isCatppuccin = lib.strings.hasPrefix "catppuccin" cfg.name;
  catppuccinFlavor = lib.strings.removePrefix "catppuccin-" cfg.name;
  catppuccinKittyTheme = {
    catppuccin-latte = "Catppuccin-Latte";
    catppuccin-frappe = "Catppuccin-Frappe";
    catppuccin-macchiato = "Catppuccin-Macchiato";
    catppuccin-mocha = "Catppuccin-Mocha";
  };
  catppuccinFishThemes = {
    catppuccin-latte = "Catppuccin Latte";
    catppuccin-frappe = "Catppuccin Frappe";
    catppuccin-macchiato = "Catppuccin Macchiato";
    catppuccin-mocha = "Catppuccin Mocha";
  };

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

    programs.kitty.theme = if isTokyonight then
      tokyoNightKittyTheme."${cfg.name}"
    else if isCatppuccin then
      catppuccinKittyTheme."${cfg.name}"
    else
      "";

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
      echo "y" | fish_config theme save "${catppuccinFishThemes."${cfg.name}"}"
    '' else
      "";

    programs.fish.plugins = if isCatppuccin then [{
      name = "catppuccin";
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "fish";
        rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
        sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
      };
    }] else
      [ ];

    xdg.configFile."fish/themes".source = if isCatppuccin then
      "${inputs.catppuccin-fish}/themes"
    else
      "${inputs.tokyonight}/extras/fish_themes";

    programs.neovim.plugins = if isTokyonight then [{
      plugin = pkgs.vimPlugins.tokyonight-nvim;
      type = "lua";
      config = ''
        local tokyonight_style = "${tokyoNightStyle}"
        ${builtins.readFile ./nvim/tokyonight.lua}
      '';
    }] else if isCatppuccin then [{
      plugin = pkgs.vimPlugins.catppuccin-nvim;
      type = "lua";
      config = ''
        local catppuccin_flavor = "${catppuccinFlavor}"
        ${builtins.readFile ./nvim/catppuccin.lua}
      '';
    }] else
      [ ];

    programs.neovim.extraLuaConfig = if isTokyonight then ''
      vim.cmd.colorscheme("tokyonight")
    '' else if isCatppuccin then ''
      vim.cmd.colorscheme("catppuccin")
    '' else
      "";

  };

}
