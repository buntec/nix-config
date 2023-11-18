{ pkgs, ... }: {
  imports = [
    ./colorscheme/colorscheme.nix
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # set the colorscheme for nvim, tmux, kitty and fish
  colorscheme = {
    enable = true;
    name = "tokyonight-storm";
  };

  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  programs.bash.enable = true;

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
    eza
    fd
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
    jq
    killall
    kubernetes-helm
    lazygit
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
