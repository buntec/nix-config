{ lib, pkgs, ... }:
{
  home.sessionPath = [
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.activation.rustupInstallStable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.rustup/toolchains" ] || [ -z "$(ls -A "$HOME/.rustup/toolchains" 2>/dev/null)" ]; then
      run ${pkgs.rustup}/bin/rustup toolchain install stable
      run ${pkgs.rustup}/bin/rustup default stable
    fi
  '';

  home.activation.imperativePackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    install_bun_global() {
      local pkg=$1
      local bin=''${2:-$1}
      if ! ${pkgs.bun}/bin/bun pm ls -g 2>/dev/null | grep -q "\"$pkg\""; then
        echo "Installing bun global: $pkg"
        ${pkgs.bun}/bin/bun install -g "$pkg"
      fi
    }

    install_cargo_package() {
      local crate=$1
      local bin=''${2:-$1}
      if ! command -v "$bin" &>/dev/null; then
        echo "Installing cargo package: $crate"
        ${pkgs.rustup}/bin/cargo install "$crate"
      fi
    }

    install_uv_tool() {
      local pkg=$1
      local bin=''${2:-$1}
      if ! command -v "$bin" &>/dev/null; then
        echo "Installing uv tool: $pkg"
        ${pkgs.uv}/bin/uv tool install "$pkg"
      fi
    }

    # bun global packages
    # install_bun_global "typescript-language-server"
    # install_bun_global "@anthropic-ai/claude-code" "claude"
    install_bun_global "@playwright/cli@latest"

    # cargo packages
    install_cargo_package "cargo-edit" "cargo-add"

    # uv tools
    install_uv_tool "ruff"
    # install_uv_tool "posting"
  '';
}
