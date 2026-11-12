# Credentials and editor tools

Pushes to GitHub over `https://` remotes are rewritten to SSH (`url.pushInsteadOf`), so no Git
credential helper is configured and the SSH key is used. If an earlier configuration used the
`store` helper, review and remove `~/.git-credentials`; changing the config does not remove that file.
Multipass trusts Git repositories only under `/home/christoph/host/`.

Neovim uses Pyrefly. Pyrefly, ty and Ruff come from nixpkgs on every host. To follow
upstream releases, `home/upstream-tools/upstream-tools.nix` also installs them (plus a few
npm and cargo tools) with uv, npm and cargo on every Home Manager switch, upgrading existing
installs. Those builds live in `~/.local/bin` and `~/.cargo/bin`, which precede the Nix
profile on `PATH`.
Clangd, the Java server, and the C# server are provided by Nix. Rust Analyzer uses
Rustup; install it for the selected toolchain with `rustup component add rust-analyzer`.
Treesitter includes all grammars packaged in nixpkgs. Multipass omits desktop
launchers and GNOME-only tools while retaining the shared development environment.
