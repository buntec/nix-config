{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    customPaneNavigationAndResize =
      false; # this is nice for pane switching, but unfortunately would also remap prefix + L, which otherwise toggles last session
    sensibleOnTop = true;
    clock24 = true;
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    escapeTime = 0;
    plugins = with pkgs; [ tmuxPlugins.resurrect ];
    extraConfig = ''
      set -g default-command "exec ${pkgs.fish}/bin/fish"

      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # pane switching using vim keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };
}
