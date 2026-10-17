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

    shellInitLast = ''
      function reload_fish_config --on-signal=SIGHUP
          echo 'reloading fish config...'
          source ~/.config/fish/**/*.fish
          clear -x
          commandline -f repaint
          clear -x
      end
    '';

    functions = {

      # Inside a btmux pane, open files in btmux's editor instead of plain nvim.
      vi = {
        body = ''
          if set -q BTMUX_PANE_ID
              btmux open-editor $argv
          else
              nvim $argv
          end
        '';
      };

    };

    shellAbbrs = {

      fish-reload-config = "source ~/.config/fish/**/*.fish";

    };

    shellAliases = {
      gs = "git status";
      gd = "git diff";
      gf = "git fetch";
      gp = "git pull";
      gl = "git log";

      cl = "/usr/bin/clear";
    };
  };
}
