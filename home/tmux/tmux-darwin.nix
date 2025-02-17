{ pkgs, ... }:
{
  programs.tmux = {
    extraConfig = ''
      set -g status-right "🦉#{user} - 💻#{host_short}(🍏) - %a %F %R %Z"
    '';
  };
}
