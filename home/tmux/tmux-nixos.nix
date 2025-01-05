{ pkgs, ... }:
{
  programs.tmux =
    let
      conky-config = pkgs.writeText "conky.conf" ''
        ${builtins.readFile ./conky.conf}
      '';
    in
    {
      extraConfig = ''
        set -g status-right "🦉#{user} - 💻#{host_short} - #(conky -c ${conky-config}) - %a %F %R %Z"
      '';
    };
}
