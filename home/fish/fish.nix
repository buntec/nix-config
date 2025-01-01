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
      any-nix-shell fish --info-right | source
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

      # Why doesn't this work? The function is rendered correctly into the
      # config but sending SIGHUP just kills the process.
      # Adding the same function to `shellInitLast` works...
      #
      # reload_fish_config = {
      #   onSignal = "SIGHUP";
      #   body = ''
      #     source ~/.config/fish/**/*.fish
      #   '';
      # };

      reload_all_fish_instances = {
        body = ''
          # Get the process IDs of all running fish processes except the current one
          set fish_pids (pgrep -x fish | grep -v $fish_pid)

          # Check if there are any fish processes to reload
          if test -n "$fish_pids"
              # Send SIGHUP to each process
              for pid in $fish_pids
                  kill -SIGHUP $pid
              end
              echo "Reloaded configuration for fish processes: $fish_pids"
          else
              echo "No other fish processes found to reload."
          end
        '';
      };

    };

    shellAbbrs = {

      fish-reload-config = "source ~/.config/fish/**/*.fish";
      tmux-reload-config = "tmux source-file ~/.config/tmux/tmux.conf";

    };

    shellAliases = {
      # git
      gs = "git status";
      gd = "git diff";
      gf = "git fetch";
      gp = "git pull";
      gl = "git log";

      # vim
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
      ng = "nvim +Neogit";

      # tmux
      t = "tmux";
      ta = "t a -t";
      tls = "t ls";
      tn = "t new -t";
      tkill = "t kill-session -t";

      # ls
      la = "eza -la --color=never --git --icons";
      l = "eza -l --color=never --git --icons";

      # scala
      scala = "scala-cli";
      sc = "scala-cli";
    };
  };
}
