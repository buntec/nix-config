{ lib, pkgs, config, inputs, ... }:
with lib;
let
  capitalizeFirst = s:
    lib.toUpper (builtins.substring 0 1 s)
    + builtins.substring 1 (lib.stringLength s) s;

  mkTokyoNight = style: {
    kitty-theme = "Tokyo Night ${capitalizeFirst style}";

    fish-init = builtins.readFile
      "${inputs.tokyonight}/extras/fish/tokyonight_${style}.fish";

    fish-theme-src = "${inputs.tokyonight}/extras/fish_themes";

    nvim-plugins = [ pkgs.vimPlugins.tokyonight-nvim ];

    # we put the plugin config here to ensure `colorscheme(...)` is called _after_ the config
    nvim-extra-conf = ''
      local tokyonight_style = "${style}"
      ${builtins.readFile ./nvim/tokyonight.lua}
      vim.cmd.colorscheme("tokyonight")
    '';

    tmux-extra-conf = builtins.readFile
      "${inputs.tokyonight}/extras/tmux/tokyonight_${style}.tmux";

  };

  tokyonight-themes = builtins.listToAttrs (map (style: {
    name = "tokyonight-${style}";
    value = mkTokyoNight style;
  }) [ "storm" "moon" "day" "night" ]);

  mkCatppuccin = flavor: {
    kitty-theme = "Catppuccin-${capitalizeFirst flavor}";

    fish-init = ''
      echo "y" | fish_config theme save "Catppuccin ${capitalizeFirst flavor}";
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
      local catppuccin_flavor = "${flavor}"
      ${builtins.readFile ./nvim/catppuccin.lua}
      vim.cmd.colorscheme("catppuccin")
    '';

    tmux-plugins = [ pkgs.tmuxPlugins.catppuccin ];

    tmux-extra-conf = ''
      set -g @catppuccin_flavour '${flavor}';
    '';

  };

  catppuccin-themes = builtins.listToAttrs (map (flavor: {
    name = "catppuccin-${flavor}";
    value = mkCatppuccin flavor;
  }) [ "frappe" "mocha" "macchiato" "latte" ]);

  themes = tokyonight-themes // catppuccin-themes;

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
