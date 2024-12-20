{ pkgs, ... }:
{

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins =
      let
        treesitter = {
          plugin = vimPlugins.nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ./plugins/treesitter.lua;
        };

        fzf-lua = {
          plugin = vimPlugins.fzf-lua;
          type = "lua";
          config = builtins.readFile ./plugins/fzf-lua.lua;
        };

        diffview = {
          plugin = vimPlugins.diffview-nvim;
          type = "lua";
          config = ''
            require("diffview").setup({})
          '';
        };

        web-devicons = {
          plugin = vimPlugins.nvim-web-devicons;
        };

        oil = {
          plugin = vimPlugins.oil-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/oil.lua;
        };

        plenary = {
          plugin = vimPlugins.plenary-nvim;
        };

        lspconfig = {
          plugin = vimPlugins.nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/lspconfig.lua;
        };

        snacks = {
          plugin = vimPlugins.snacks-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/snacks.lua;
        };

        blink-cmp = {
          plugin = vimPlugins.blink-cmp;
          type = "lua";
          config = builtins.readFile ./plugins/blink-cmp.lua;
        };

        nvim-metals = {
          plugin = vimPlugins.nvim-metals;
          type = "lua";
          config = ''
            local metalsBinary = "${metals}/bin/metals"
            ${builtins.readFile ./plugins/metals.lua}
          '';
        };

        lsp-kind = {
          plugin = vimPlugins.lspkind-nvim;
          type = "lua";
        };

        which-key = {
          plugin = vimPlugins.which-key-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/which-key.lua;
        };

        gitsigns = {
          plugin = vimPlugins.gitsigns-nvim;
          type = "lua";
          config = ''
            require("gitsigns").setup()
          '';
        };

        lualine = {
          plugin = vimPlugins.lualine-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/lualine.lua;
        };

        surround = {
          plugin = vimPlugins.nvim-surround;
          type = "lua";
          config = ''
            require("nvim-surround").setup({})
          '';
        };

        nvim-lint = {
          plugin = vimPlugins.nvim-lint;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lint.lua;
        };

        conform-nvim = {
          plugin = vimPlugins.conform-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/conform-nvim.lua;
        };

        haskell-tools = {
          plugin = vimPlugins.haskell-tools-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/haskell-tools.lua;
        };

        fidget = {
          plugin = vimPlugins.fidget-nvim;
          type = "lua";
          config = ''
            require("fidget").setup {}
          '';
        };

        lush = {
          plugin = vimPlugins.lush-nvim;
          type = "lua";
        };

        neogit = {
          plugin = vimPlugins.neogit;
          type = "lua";
          config = ''
            local neogit = require('neogit')
            neogit.setup {}
          '';
        };

        vim-tmux-nav = {
          plugin = vimPlugins.vim-tmux-navigator;
        };

        markdown-preview = {
          plugin = vimPlugins.markdown-preview-nvim;
          type = "lua";
          config = "";
        };

        ts-context = {
          plugin = vimPlugins.nvim-treesitter-context;
          type = "lua";
          config = ''
            require'treesitter-context'.setup{
              enable = false
            }
          '';
        };

      in
      lib.lists.flatten [
        blink-cmp
        conform-nvim
        diffview
        fidget
        fzf-lua
        gitsigns
        haskell-tools
        lsp-kind
        lspconfig
        lualine
        lush
        markdown-preview
        neogit
        nvim-lint
        nvim-metals
        oil
        plenary
        snacks
        stylelint
        surround
        treesitter
        ts-context
        vim-tmux-nav
        web-devicons
        which-key
      ];

    extraPackages = [ ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
