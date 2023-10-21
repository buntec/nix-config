{ pkgs, ... }: {
  imports =
    [ ./kitty/kitty.nix ./fish/fish.nix ./tmux/tmux.nix ./neovim/neovim.nix ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  home.packages = let
    python-packages = ps:
      with ps; [
        jupyter
        numpy
        pandas
        python-lsp-ruff
        python-lsp-server
        requests
        scipy
      ];
    python-with-packages = (pkgs.python3.withPackages python-packages);
  in with pkgs; [
    amber
    any-nix-shell
    atool
    bat
    cargo
    coursier
    curl
    eza
    fd
    fzf
    gh
    ghc
    go
    httpie
    jdk
    jq
    killall
    kubernetes-helm
    lazygit
    minikube
    ncdu
    nixfmt
    nixpkgs-fmt
    nodePackages.live-server
    nodejs
    postgresql
    python-with-packages
    restic
    ripgrep
    sbt
    scala-cli
    stack
    # texlive.combined.scheme-full
    tldr
    vifm
    wget
    yarn
    yazi
    zig
    zoxide
  ];

  programs.git = {
    enable = true;
    userEmail = "christophbunte@gmail.com";
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
  };

  programs.java = { enable = true; };

  programs.zsh = { enable = true; };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;
}
