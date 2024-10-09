{ pkgs, ... }:
{

  imports = [
    ./kitty/kitty.nix
    ./fish/fish.nix
    ./tmux/tmux.nix
    ./neovim/neovim.nix
  ];

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
    config = {
      global = {
        warn_timeout = "30s";
      };
    };
    nix-direnv.enable = true;
  };

  home.packages =
    let
      python-packages =
        ps: with ps; [
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
      linters = with pkgs; [
        statix
        vale
      ];
      formatters = with pkgs; [
        cmake-format
        nixfmt-rfc-style
        nodePackages.prettier
        prettierd
        python311Packages.mdformat
        ruff
        stylua
        treefmt
        yamlfmt
      ];
      lsps = with pkgs; [
        ccls
        cmake-language-server
        gopls
        haskell-language-server
        lua-language-server
        metals
        nil
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        ruff-lsp
        vscode-langservers-extracted
      ];
      nix-tools = with pkgs; [
        any-nix-shell
        manix
        nix-output-monitor
      ];
      lang-tools = with pkgs; [
        cargo
        cmake
        coursier
        ghc
        go
        haskellPackages.hoogle
        jdk
        nodejs
        python-with-packages
        racket
        sbt
        scala-cli
        stack
        taplo
        texlab
        visualvm
        yarn
      ];
      git-tools = with pkgs; [
        gh
        git-gone
        gitui
        lazygit
      ];
    in
    linters
    ++ formatters
    ++ lsps
    ++ nix-tools
    ++ lang-tools
    ++ git-tools
    ++ (with pkgs; [
      amber
      atool
      bat
      broot
      csvlens
      curl
      d2
      eza
      fd
      fx
      fzf
      gdu # ncdu breaks often, use gdu instead for now
      hey
      httpie
      hyperfine
      jless
      jq
      just
      killall
      marp-cli
      nodePackages.live-server
      pandoc
      restic
      ripgrep
      tig
      tldr
      tree
      vifm
      watchexec
      wget
      yazi
      zoxide
    ]);

  programs.git = {
    enable = true;
    userEmail = pkgs.lib.mkDefault "christophbunte@gmail.com"; # we might want to override this
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.java = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.zoxide.enable = true;
}
