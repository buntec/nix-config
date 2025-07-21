{ pkgs, ... }:
{

  imports = [
    ./fish/fish.nix
    ./ghostty/ghostty.nix
    ./git/git.nix
    ./kitty/kitty.nix
    ./neovim/neovim.nix
    ./tmux/tmux.nix
    ./stylix/stylix.nix
  ];

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash.enable = true;
  programs.zsh.enable = true;

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

  programs.vscode = {
    enable = false;
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
        cmake-lint
        statix
        stylelint
        vale
      ];
      formatters = with pkgs; [
        gersemi # for cmake
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
        neocmakelsp
        gopls
        haskell-language-server
        lua-language-server
        metals
        nil
        nodePackages.bash-language-server
        nodePackages.typescript-language-server
        pyright
        vscode-langservers-extracted
      ];
      nix-tools = with pkgs; [
        any-nix-shell
        manix
        nix-output-monitor
      ];
      lang-tools = with pkgs; [
        bun
        cargo
        clang-tools
        cmake
        coursier
        ghc
        go
        haskellPackages.hoogle
        jdk
        nodejs
        pixi
        python-with-packages
        sbt
        scala-cli
        stack
        taplo
        texlab
        uv
        visualvm
        yarn
      ];
      git-tools = with pkgs; [
        gh
        git-gone
        gitu
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
        wget
        xh # faster httpie in rust
      ];
      misc-tools = with pkgs; [
        # ast-grep # https://github.com/ast-grep/ast-grep
        amber # search & replace - https://github.com/dalance/amber
        atool # archive tool - https://www.nongnu.org/atool/
        bat # better cat - https://github.com/sharkdp/bat
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
        procs # better ps
        restic # backup - https://github.com/restic/restic
        ripgrep # better grep - https://github.com/BurntSushi/ripgrep
        tldr # https://github.com/tldr-pages/tldr
        tree # https://oldmanprogrammer.net/source.php?dir=projects/tree
        typos # source code spell checker - https://github.com/crate-ci/typos
        watchexec # https://watchexec.github.io/
        yazi # https://github.com/sxyazi/yazi
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
    ++ misc-tools;

  programs.java = {
    enable = true;
  };

  # better top - https://github.com/aristocratos/btop
  programs.btop = {
    enable = true;
  };

  # better top - https://github.com/htop-dev/htop
  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  # smart cd - https://github.com/ajeetdsouza/zoxide
  programs.zoxide.enable = true;

  # file browser - https://dystroy.org/broot/
  programs.broot = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      modal = true;
      verbs = [
        {
          key = "enter";
          external = "$EDITOR +{line} {file}";
          apply_to = "text_file";
          leave_broot = false;
          set_working_dir = false;
        }
      ];
    };
  };

  # Neovim GUI - https://neovide.dev/
  programs.neovide = {
    enable = true;
    settings = { };
  };
}
