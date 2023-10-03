{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup {
            highlight = {
              enable = true,
            }
          }
        '';
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = ''
          require("oil").setup()
          vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        '';
      }
      unicode-vim
      vim-nix
      tokyonight-nvim
      vim-fugitive
      {
        plugin = lazy-nvim;
        type = "lua";
        config = (builtins.readFile ./lazy.lua);
      }
    ];

    extraPackages = with pkgs; [
      # Language servers
      ccls
      gopls
      haskell-language-server
      ltex-ls
      lua-language-server
      nil
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      pyright
      python310Packages.python-lsp-server

      # null-ls sources
      nixfmt
      black
      cppcheck
      deadnix
      gitlint
      mypy
      nodePackages.markdownlint-cli
      nodePackages.prettier
      nodePackages.eslint
      python3Packages.flake8
      shellcheck
      shellharden
      shfmt
      sqlfluff
      statix
      stylua
      vim-vint

      # DAP servers
      delve
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
