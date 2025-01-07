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
          requests
          scipy
        ];
      python-with-packages = pkgs.python3.withPackages python-packages;
      linters = with pkgs; [
        statix
        stylelint
        vale
      ];
      formatters = with pkgs; [
        cmake-format
        mdformat
        nixfmt-rfc-style
        nodePackages.prettier # is this really needed on top of prettierd?
        prettierd
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
        pyright
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
        clang-tools
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
        tig
      ];
      json-tools = with pkgs; [
        fx
        jless
        jq
      ];
      network-tools = with pkgs; [
        curl
        hey
        # httpie # xh is faster alternative in rust
        wget
        xh
      ];
    in
    linters
    ++ formatters
    ++ lsps
    ++ nix-tools
    ++ lang-tools
    ++ git-tools
    ++ json-tools
    ++ network-tools
    ++ (with pkgs; [
      amber # search & replace - https://github.com/dalance/amber
      ast-grep # https://github.com/ast-grep/ast-grep
      atool # archive tool - https://www.nongnu.org/atool/
      bat # better cat - https://github.com/sharkdp/bat
      broot # https://dystroy.org/broot/
      csvlens # https://github.com/YS-L/csvlens
      d2 # https://github.com/terrastruct/d2
      eza # better ls - https://github.com/eza-community/eza
      fastfetch # like neofetch
      fd # better find - https://github.com/sharkdp/fd
      fzf # https://github.com/junegunn/fzf
      gdu # ncdu breaks often, use gdu instead for now
      hyperfine # https://github.com/sharkdp/hyperfine
      just # https://github.com/casey/just
      killall
      marp-cli # https://github.com/marp-team/marp-cli
      nodePackages.live-server
      pandoc # https://github.com/jgm/pandoc
      restic # backup - https://github.com/restic/restic
      ripgrep # better grep - https://github.com/BurntSushi/ripgrep
      tldr # https://github.com/tldr-pages/tldr
      tree # https://oldmanprogrammer.net/source.php?dir=projects/tree
      watchexec # https://watchexec.github.io/
      yazi # https://github.com/sxyazi/yazi
      zoxide # smart cd - https://github.com/ajeetdsouza/zoxide
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
