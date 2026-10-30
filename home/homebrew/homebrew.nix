{
  config,
  lib,
  pkgs,
  ...
}:
let
  brew =
    if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew/bin/brew" else "/usr/local/bin/brew";
  brewfile = "${config.xdg.configHome}/homebrew/Brewfile";
in
{
  xdg.configFile."homebrew/Brewfile".text = ''
    cask "keepassxc"
    cask "localsend"
    cask "multipass"
    cask "syncthing-app"
    cask "tailscale-app"
    cask "utm"
    cask "visual-studio-code"
  '';

  home.activation.homebrewBundle =
    lib.hm.dag.entryAfter
      [
        "installPackages"
        "linkGeneration"
      ]
      ''
        if [ -x "${brew}" ]; then
          verboseEcho "Applying Homebrew bundle from ${brewfile}"
          run "${brew}" bundle --file="${brewfile}"
        else
          echo "Homebrew not found at ${brew}; skipping Brewfile activation" >&2
        fi
      '';
}
