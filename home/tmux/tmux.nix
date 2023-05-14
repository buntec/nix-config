{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    sensibleOnTop = true;
    clock24 = true;
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "screen-256color";
    escapeTime = 0;
    extraConfig = ''
      set -g default-command "exec ${pkgs.fish}/bin/fish"
    '';
  };
}
