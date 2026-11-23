{
  config,
  lib,
  pkgs,
  ...
}:
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

      # Re-source the config whenever the universal variable `fish_reload` changes,
      # which Home Manager activation does after every switch (see below).
      function __reload_fish_config --on-variable fish_reload
          source ${config.xdg.configHome}/fish/config.fish
      end
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
      e = "btmux open-editor";

      gs = "git status";
      gd = "git diff";
      gf = "git fetch";
      gp = "git pull";
      gl = "git log";

      cl = "clear";
    };
  };

  # Signal all running fish instances to reload their config.
  home.activation.reloadFish = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${lib.getExe config.programs.fish.package} -c 'set -U fish_reload (date +%s)' \
      || echo "Failed to signal running fish instances; continuing" >&2
  '';
}
