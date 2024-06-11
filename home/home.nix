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

  programs.readline = {
    enable = true;
    extraConfig = ''
      set editing-mode vi
    '';
  };

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
    # git-summary
    # smithy-cli
    # smithy-language-server
    # smithy4s-codegen-cli
    amber
    # ncdu # breaks often, use gdu instead for now
    any-nix-shell
    atool
    bat
    broot
    cargo
    ccls
    cmake
    cmake-format
    cmake-language-server
    coursier
    csvlens
    curl
    d2
    eza
    fd
    fx
    fzf
    gdu
    gh
    ghc
    git-gone
    gitui
    go
    gopls
    haskell-language-server
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
    lua-language-server
    manix
    marp-cli
    mdformat
    metals
    minikube
    nil
    nix-output-monitor
    nixfmt
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.live-server
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodejs
    pandoc
    postgresql
    prettierd
    python-with-packages
    racket
    restic
    ripgrep
    ruff
    ruff-lsp
    sbt
    scala-cli
    stack
    statix
    stylua
    texlab
    tig
    tldr
    tree
    treefmt
    typst
    typst-live
    typst-lsp
    typstfmt
    vale
    vifm
    visualvm
    vscode-langservers-extracted
    watchexec
    wget
    yamlfmt
    yarn
    yazi
    zoxide
  ];

  programs.git = {
    enable = true;
    userEmail = pkgs.lib.mkDefault
      "christophbunte@gmail.com"; # we might want to override this
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
    extraConfig = { init.defaultBranch = "main"; };
  };

  programs.java = { enable = true; };

  programs.zsh = { enable = true; };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.zoxide.enable = true;
}
