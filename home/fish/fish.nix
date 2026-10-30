{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        inherit (pkgs.fishPlugins.pure) src;
      }
    ];

    interactiveShellInit = ''
      fish_vi_key_bindings
    '';

    functions = {

      # Inside a btmux pane, open files in btmux's editor instead of plain nvim.
      vi = {
        body = ''
          if set -q BTMUX_PANE_ID
              btmux open-editor --kind nvim $argv
          else
              nvim $argv
          end
        '';
      };

      # Inside a btmux pane, open files in btmux's VS Code editor instead of plain code.
      code = {
        body = ''
          if set -q BTMUX_PANE_ID
              btmux open-editor --kind vscode $argv
          else
              command code $argv
          end
        '';
      };

    };

    shellAliases = {
      gs = "git status";
      gd = "git diff";
      gf = "git fetch";
      gp = "git pull";
      gl = "git log";

      cl = "clear";
    };
  };
}
