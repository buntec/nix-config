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
  bundlePath = lib.makeBinPath [
    pkgs.nodejs
    pkgs.rustup
    pkgs.uv
  ];
in
{
  xdg.configFile."homebrew/Brewfile".text = ''
    cask "firefox"
    cask "google-chrome"
    cask "keepassxc"
    cask "localsend"
    cask "multipass"
    cask "openscad"
    cask "steam"
    cask "syncthing-app"
    cask "tailscale-app"
    cask "utm"

    cargo "cargo-edit"

    npm "@playwright/cli"

    uv "ninja-so-fancy", source: "git+http://github.com/buntec/ninja-so-fancy"
    uv "pyrefly"
    uv "ruff"
    uv "ty"
  '';

  home.activation.rustupInstallStable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.rustup}/bin/rustup toolchain list 2>/dev/null | grep -q "^stable"; then
      run ${pkgs.rustup}/bin/rustup toolchain install stable
      run ${pkgs.rustup}/bin/rustup default stable
    fi
  '';

  home.activation.homebrewBundle =
    lib.hm.dag.entryAfter
      [
        "installPackages"
        "linkGeneration"
        "rustupInstallStable"
      ]
      ''
        if [ -x "${brew}" ]; then
          verboseEcho "Applying Homebrew bundle from ${brewfile}"
          run env -u RUSTC PATH="${bundlePath}:$PATH" "${brew}" bundle --file="${brewfile}"
        else
          echo "Homebrew not found at ${brew}; skipping Brewfile activation" >&2
        fi
      '';
}
