{ pkgs, ... }: {

  imports =
    [ ./kitty/kitty.nix ./fish/fish.nix ./tmux/tmux.nix ./neovim/neovim.nix ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Kauz colorscheme
  kauz = {
    fish.enable = true;
    kitty.enable = true;
    neovim.enable = true;
    tmux.enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  programs.bash.enable = true;

  programs.ssh.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    # enableFishIntegration = true; # fish integration is automatic
    config = { global = { warn_timeout = "30s"; }; };
    nix-direnv.enable = true;
  };

  home.packages = let
    python-packages = ps:
      with ps; [
        jupyter
        matplotlib
        numpy
        pandas
        python-lsp-ruff
        python-lsp-server
        requests
        scipy
      ];
    python-with-packages = pkgs.python3.withPackages python-packages;
    inherit (pkgs.haskellPackages) hoogle;
    inherit (pkgs.python311Packages) mdformat;
  in with pkgs; [
    amber
    any-nix-shell
    atool
    bat
    cargo
    coursier
    curl
    d2
    eza
    fd
    fx
    fzf
    gh
    ghc
    git-gone
    git-summary
    go
    hey
    hoogle
    httpie
    hyperfine
    jdk
    jless
    jq
    just
    killall
    kubernetes-helm
    librsvg
    manix
    mdformat
    metals
    minikube
    ncdu
    nix-output-monitor
    nixfmt
    nixpkgs-fmt
    nodePackages.live-server
    nodejs
    pandoc
    postgresql
    python-with-packages
    racket
    restic
    ripgrep
    ruff
    ruff-lsp
    sbt
    scala-cli
    smithy-cli
    smithy-language-server
    smithy4s-codegen-cli
    stack
    statix
    stylua
    tldr
    tree
    typst
    typst-live
    typst-lsp
    typstfmt
    vale
    vifm
    visualvm
    watchexec
    wget
    yarn
    yazi
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

  programs.zoxide.enable = true;
}
