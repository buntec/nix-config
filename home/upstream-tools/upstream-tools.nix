# Tools installed with uv, npm and cargo to follow upstream releases ahead of nixpkgs.
# They land in ~/.local/bin and ~/.cargo/bin, which precede the Nix profile on PATH.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  uvTools = [
    "pyrefly"
    "ruff"
    "ty"
  ];
  npmPackages = [ "@playwright/cli" ];
  cargoCrates = [ "cargo-edit" ];

  npmPrefix = "${config.home.homeDirectory}/.local";
  toolPath = lib.makeBinPath [
    pkgs.nodejs
    pkgs.rustup
    pkgs.uv
  ];
  # uv warns if its tool bin dir is missing from the (minimal) activation PATH
  uvPath = "${toolPath}:${config.home.homeDirectory}/.local/bin";
  # Activation runs with a minimal PATH, so cargo needs a linker: Apple's on macOS, Nix's elsewhere.
  cargoPath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${toolPath}:/usr/bin"
    else
      "${toolPath}:${pkgs.stdenv.cc}/bin";
in
{
  home.file.".npmrc".text = ''
    prefix=${npmPrefix}
  '';

  home.activation.rustupInstallStable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.rustup}/bin/rustup toolchain list 2>/dev/null | grep -q "^stable"; then
      run ${pkgs.rustup}/bin/rustup toolchain install stable
      run ${pkgs.rustup}/bin/rustup default stable
    fi
  '';

  # Install missing tools and upgrade existing ones on every switch.
  # Failures (e.g. when offline) only warn so that activation can finish.
  home.activation.upstreamTools =
    lib.hm.dag.entryAfter
      [
        "installPackages"
        "linkGeneration"
        "rustupInstallStable"
      ]
      ''
        verboseEcho "Installing and upgrading uv, npm and cargo tools"
        for tool in ${lib.escapeShellArgs uvTools}; do
          run env PATH="${uvPath}:$PATH" uv tool install --upgrade "$tool" \
            || echo "Failed to install or upgrade uv tool $tool; continuing" >&2
        done
        run env PATH="${toolPath}:$PATH" npm install --global ${lib.escapeShellArgs npmPackages} \
          || echo "Failed to install or upgrade npm packages; continuing" >&2
        run env -u RUSTC PATH="${cargoPath}:$PATH" cargo install --locked ${lib.escapeShellArgs cargoCrates} \
          || echo "Failed to install or upgrade cargo crates; continuing" >&2
      '';
}
