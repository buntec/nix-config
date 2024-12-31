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
