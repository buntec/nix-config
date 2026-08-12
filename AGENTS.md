# Repository Guidelines

## Project Structure & Module Organization

This repository is a Nix flake for NixOS, nix-darwin, and Home Manager.

- `flake.nix` defines inputs, host inventories, configurations, checks, and runnable rebuild apps.
- `system/` contains machine and platform modules. Host files follow `configuration-<host>.nix`; shared modules live in subdirectories such as `system/disko/` and `system/gnome/`.
- `home/` contains Home Manager entry points (`home-<host>.nix`) and feature modules such as `home/neovim/`, `home/fish/`, and `home/tmux/`.
- `extras/` stores bootstrap support files; `wallpapers/` stores visual assets.
- `.github/workflows/ci.yml` runs flake validation on Linux and macOS.

Keep host-specific settings in the matching host module and reusable behavior in a focused feature module.

## Build, Test, and Development Commands

- `nix flake show`: inspect available `-light` and `-dark` configurations and apps.
- `nix flake check --impure`: evaluate and build configured checks; this matches CI.
- `just format` or `nix fmt`: format all supported Nix and Lua files.
- `just nixos-switch [light|dark]`: build and activate the current NixOS host.
- `just nix-darwin-switch [light|dark]`: build and activate the current macOS system configuration.
- `just hm-switch [light|dark]`: build and activate Home Manager for the current host.

Run activation commands only on their intended platform. Use `just --list` to discover bootstrap and maintenance recipes.

## Coding Style & Naming Conventions

Use two-space indentation for Nix and Lua. Formatting is managed by treefmt with `nixfmt` and StyLua; Lua lines target 120 columns. Do not manually reformat `system/hardware-configuration.nix`, which is excluded from nixfmt.

Name host modules consistently with existing patterns. Prefer small composable Nix modules, explicit attribute sets, and established helpers in `flake.nix` over duplicated host logic.

## Testing Guidelines

There is no separate unit-test suite. Treat successful evaluation, formatting, and configuration builds as the test boundary. Before submitting changes, run:

```bash
nix fmt
nix flake check --impure
```

For host-specific changes, also run the relevant switch command when that platform is available.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase subjects such as `add typst, tinymist` and `simplify flake and fix deprecation warnings`. Keep commits focused and avoid mixing unrelated hosts or features.

Pull requests should identify affected hosts, summarize behavioral changes, and report commands run. Call out required manual steps, generated hardware changes, or platform-specific limitations. Include screenshots only for visible desktop, terminal, or theme changes.
