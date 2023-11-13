{ lib, pkgs, config, inputs, ... }:
with lib;
let
  # add your themes here...
  themes = {

    tokyonight-storm = {
      kitty-theme = "Tokyo Night Storm";

      fish-init = builtins.readFile
        "${inputs.tokyonight}/extras/fish/tokyonight_storm.fish";

      fish-theme-src = "${inputs.tokyonight}/extras/fish_themes";

      nvim-plugins = [ pkgs.vimPlugins.tokyonight-nvim ];

      # we put the plugin config here to ensure `colorscheme(...)` is called _after_ the config
      nvim-extra-conf = ''
        local tokyonight_style = "storm"
        ${builtins.readFile ./nvim/tokyonight.lua}
        vim.cmd.colorscheme("tokyonight")
      '';

      tmux-extra-conf = builtins.readFile
        "${inputs.tokyonight}/extras/tmux/tokyonight_storm.tmux";

    };

    catppuccin-frappe = {
      kitty-theme = "Catppuccin-Frappe";

      fish-init = ''
        echo "y" | fish_config theme save "Catppuccin Frappe";
      '';

      fish-theme-src = "${inputs.catppuccin-fish}/themes";

      fish-plugins = [{
        name = "catppuccin";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
          sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
        };
      }];

      nvim-plugins = [ pkgs.vimPlugins.catppuccin-nvim ];

      # we put the plugin config here to ensure `colorscheme(...)` is called _after_ the config
      nvim-extra-conf = ''
        local catppuccin_flavor = "frappe"
        ${builtins.readFile ./nvim/catppuccin.lua}
        vim.cmd.colorscheme("catppuccin")
      '';

      tmux-plugins = [ pkgs.tmuxPlugins.catppuccin ];

      tmux-extra-conf = ''
        set -g @catppuccin_flavour 'frappe';
      '';

    };

  };

  cfg = config.colorscheme;
  theme = themes.${cfg.name};

in {

  options.colorscheme = {
    enable =
      mkEnableOption "a global colorscheme for kitty, fish, tmux and nvim";
    name = mkOption {
      type = types.enum (builtins.attrNames themes);
      default = "tokyonight-storm";
    };
  };

  config = mkIf cfg.enable {

    programs.kitty.theme = theme.kitty-theme;

    programs.tmux.extraConfig = theme.tmux-extra-conf or "";

    programs.tmux.plugins = theme.tmux-plugins or [ ];

    programs.fish.interactiveShellInit = theme.fish-init or "";

    programs.fish.plugins = theme.fish-plugins or [ ];

    programs.neovim.plugins = theme.nvim-plugins or [ ];

    programs.neovim.extraLuaConfig = theme.nvim-extra-conf or [ ];

    xdg.configFile."fish/themes".source =
      mkIf (hasAttr "fish-theme-src" theme) theme.fish-theme-src;

  };

}
