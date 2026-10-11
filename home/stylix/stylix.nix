{ config, inputs, ... }:

let
  inherit (config.lib.stylix) colors;
in
{

  # Stylix's fish target, minus btmux panes: btmux already uses this scheme,
  # and base16-fish's OSC color sets would pin the pane palette.
  programs.fish.interactiveShellInit = ''
    source ${colors { templateRepo = inputs.stylix.inputs.base16-fish; }}

    if test -z "$TMUX" -a -z "$ZELLIJ"; and not set -q BTMUX_PANE_ID
        base16-${colors.slug}
    end
  '';

  stylix = {
    targets = {
      fish.enable = false;
      # btmux's built-in Neovim applies its own colorscheme.
      neovim.enable = false;
    };
  };

}
