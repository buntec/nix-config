{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    # this is nice for pane switching, but unfortunately would also remap prefix + L, which otherwise toggles last session
    # customPaneNavigationAndResize = true;
    sensibleOnTop = true;
    clock24 = true;
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    escapeTime = 0;
    plugins = with pkgs.tmuxPlugins; [
      prefix-highlight
      resurrect
      tmux-fzf
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g default-command "exec ${pkgs.fish}/bin/fish"

      # status bar
      set -g status on
      set -g status-position top
      set -g status-interval 5
      set -g status-justify left
      set -g status-left-length 80
      set -g status-right-length 160
      set -g status-left "[#S]"

      ${builtins.readFile ./extra.conf}
    '';
  };

}
