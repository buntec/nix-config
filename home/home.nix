{ pkgs, ... }: {

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.syncthing = {
    enable = true;
    extraOptions = [ ];
  };

  home.packages = with pkgs; [
    amber
    any-nix-shell
    atool
    cargo
    coursier
    curl
    exa
    fd
    fzf
    gh
    ghc
    go
    httpie
    jq
    killall
    nixpkgs-fmt
    nodePackages.live-server
    nodejs
    python3
    restic
    ripgrep
    sbt
    scala-cli
    stack
    texlive.combined.scheme-full
    tldr
    tmux
    vifm
    wget
    yarn
  ];

  programs.git = {
    enable = true;
    userEmail = "christophbunte@gmail.com";
    userName = "Christoph Bunte";
    diff-so-fancy.enable = true;
  };

  programs.java = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font"; #"FiraCode Nerd Font";
    font.size = pkgs.lib.mkDefault 14; # might want to override in machine-specific module
    darwinLaunchOptions = [
      "--single-instance"
    ];
    extraConfig = builtins.readFile ./kitty.conf;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      trim-nvim
      nvim-dap
      lualine-nvim
      nvim-treesitter.withAllGrammars
      telescope-nvim
      telescope-file-browser-nvim
      neoscroll-nvim
      unicode-vim
      lsp-status-nvim
      lspkind-nvim
      nvim-cmp
      cmp-buffer
      cmp-path
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      nvim-lspconfig
      yankring
      vim-nix
      tokyonight-nvim
      trouble-nvim
      vim-fugitive
      gitsigns-nvim
      nvim-metals
    ];

    extraPackages = with pkgs; [
      # Language servers
      pyright
      ccls
      gopls
      ltex-ls
      lua-language-server
      haskell-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.typescript-language-server
      python310Packages.python-lsp-server
      nil

      # null-ls sources
      alejandra
      asmfmt
      black
      cppcheck
      deadnix
      editorconfig-checker
      gofumpt
      gitlint
      mypy
      nodePackages.alex
      nodePackages.prettier
      nodePackages.markdownlint-cli
      python3Packages.flake8
      shellcheck
      shellharden
      shfmt
      statix
      stylua
      vim-vint

      # DAP servers
      delve
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    sensibleOnTop = true;
    clock24 = true;
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      set -sg escape-time 0
      set -g default-command "exec ${pkgs.fish}/bin/fish"
    '';
  };

  programs.zsh = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      { name = "pure"; src = pkgs.fishPlugins.pure.src; }
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "50eba266b0d8a952c7230fca1114cbc9fbbdfbd4";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];

    interactiveShellInit = ''
      fish_vi_key_bindings
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      # git
      gs = "git status";
      gd = "git diff";
      gf = "git fetch";
      gl = "git log";

      # vim
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";

      # tmux
      t = "tmux";
      ta = "t a -t";
      tls = "t ls";
      tn = "t new -t";
      tkill = "t kill-session -t";

      #nix
      # nixre = "darwin-rebuild switch";
      nixgc = "nix-collect-garbage -d";
      # nixcfg = "vi $HOME/dotfiles/nix/darwin-configuration.nix";
      nixq = "nix-env -qa";
      nixupgrade = "nix-channel --update; nix-env -iA nixpkgs.nix";
      nixup = "nix-env -u";
      nixversion = "nix eval nixpkgs.lib.version";
      nixdaemon = "sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist && launchctl start org.nixos.nix-daemon";

      # ls
      la = "exa -la --color=never --git --icons";
      l = "exa -l --color=never --git --icons";
    };
  };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

}

