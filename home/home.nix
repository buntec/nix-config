{ pkgs, inputs, ... }: {

  imports = [
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
    inputs.kauz.homeModules.default
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  colorschemes.kauz.enable = true;

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
    fzf
    gh
    ghc
    git-gone
    # git-summary
    go
    hey
    hoogle
    httpie
    hyperfine
    jdk
    jq
    just
    killall
    kubernetes-helm
    lazygit
    librsvg
    manix
    mdformat
    metals
    minikube
    ncdu
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
    vale
    vifm
    visualvm
    watchexec
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

  programs.zoxide.enable = true;
}
