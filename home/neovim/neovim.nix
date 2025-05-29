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

        # https://github.com/romgrk/barbar.nvim/
        barbar = {
          plugin = vimPlugins.barbar-nvim;
          type = "lua";
          config = ''
            vim.g.barbar_auto_setup = false
            require('barbar').setup({})
          '';
        };

        # https://github.com/Saghen/blink.cmp
        blink-cmp = {
          plugin = vimPlugins.blink-cmp;
          type = "lua";
          config = builtins.readFile ./plugins/blink-cmp.lua;
        };

        colorizer = {
          plugin = vimPlugins.nvim-colorizer-lua;
          type = "lua";
          config = ''
            require("colorizer").setup()
          '';
        };

        # https://github.com/stevearc/conform.nvim
        conform = {
          plugin = vimPlugins.conform-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/conform-nvim.lua;
        };

        # https://github.com/sindrets/diffview.nvim
        diffview = {
          plugin = vimPlugins.diffview-nvim;
          type = "lua";
          config = ''
            require("diffview").setup({})
          '';
        };

        # https://github.com/stevearc/dressing.nvim
        dressing = {
          plugin = vimPlugins.dressing-nvim;
          type = "lua";
          config = ''
            require("dressing").setup({})
          '';
        };

        # https://github.com/j-hui/fidget.nvim
        fidget = {
          plugin = vimPlugins.fidget-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/fidget.lua;
        };

        # https://github.com/ibhagwan/fzf-lua
        fzf-lua = {
          plugin = vimPlugins.fzf-lua;
          type = "lua";
          config = builtins.readFile ./plugins/fzf-lua.lua;
        };

        # https://github.com/lewis6991/gitsigns.nvim
        gitsigns = {
          plugin = vimPlugins.gitsigns-nvim;
          type = "lua";
          config = ''
            require("gitsigns").setup({})
          '';
        };

        # https://github.com/MagicDuck/grug-far.nvim
        grug-far = {
          plugin = vimPlugins.grug-far-nvim;
          type = "lua";
          config = ''
            require('grug-far').setup({});
          '';
        };

        # https://github.com/neovim/nvim-lspconfig
        lspconfig = {
          plugin = vimPlugins.nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/lspconfig.lua;
        };

        # https://github.com/nvim-lualine/lualine.nvim
        lualine = {
          plugin = vimPlugins.lualine-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/lualine.lua;
        };

        # https://github.com/echasnovski/mini.icons
        mini-icons = {
          plugin = vimPlugins.mini-icons;
          type = "lua";
          config = ''
            require('mini.icons').setup({})
          '';
        };

        # https://github.com/echasnovski/mini.base16
        mini-base16 = {
          plugin = vimPlugins.mini-base16;
          type = "lua";
        };

        # https://github.com/echasnovski/mini.colors
        mini-colors = {
          plugin = vimPlugins.mini-colors;
          type = "lua";
          config = ''
            require('mini.colors').setup()
          '';
        };

        # https://github.com/NeogitOrg/neogit
        neogit = {
          plugin = vimPlugins.neogit;
          type = "lua";
          config = builtins.readFile ./plugins/neogit.lua;
        };

        # https://github.com/scalameta/nvim-metals
        nvim-metals = {
          plugin = vimPlugins.nvim-metals;
          type = "lua";
          config = ''
            local metalsBinary = "${metals}/bin/metals"
            ${builtins.readFile ./plugins/metals.lua}
          '';
        };

        # https://github.com/mfussenegger/nvim-lint
        nvim-lint = {
          plugin = vimPlugins.nvim-lint;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lint.lua;
        };

        # https://github.com/stevearc/oil.nvim
        oil = {
          plugin = vimPlugins.oil-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/oil.lua;
        };

        precognition = {
          plugin = vimPlugins.precognition-nvim;
          type = "lua";
          config = ''
            require('precognition').setup({
              startVisible = false
            })
          '';
        };

        # https://github.com/nvim-lua/plenary.nvim
        plenary = {
          plugin = vimPlugins.plenary-nvim;
        };

        # https://github.com/folke/snacks.nvim
        snacks = {
          plugin = vimPlugins.snacks-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/snacks.lua;
        };

        surround = {
          plugin = vimPlugins.nvim-surround;
          type = "lua";
          config = ''
            require("nvim-surround").setup({})
          '';
        };

        # https://github.com/nvim-treesitter/nvim-treesitter
        treesitter = {
          plugin = vimPlugins.nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ./plugins/treesitter.lua;
        };

        # https://github.com/nvim-treesitter/nvim-treesitter-context
        ts-context = {
          plugin = vimPlugins.nvim-treesitter-context;
          type = "lua";
          config = ''
            require'treesitter-context'.setup({
              enable = false
            })
          '';
        };

        # https://github.com/christoomey/vim-tmux-navigator
        vim-tmux-nav = {
          plugin = vimPlugins.vim-tmux-navigator;
        };

        # https://github.com/nvim-tree/nvim-web-devicons
        web-devicons = {
          plugin = vimPlugins.nvim-web-devicons;
          type = "lua";
          config = ''
            require'nvim-web-devicons'.setup({})
          '';
        };

        # https://github.com/folke/which-key.nvim
        which-key = {
          plugin = vimPlugins.which-key-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/which-key.lua;
        };

        yazi = {
          plugin = vimPlugins.yazi-nvim;
          type = "lua";
        };

      in
      lib.lists.flatten [
        barbar
        blink-cmp
        colorizer
        conform
        diffview
        dressing
        fidget
        fzf-lua
        gitsigns
        grug-far
        lspconfig
        lualine
        mini-base16
        mini-colors
        mini-icons
        neogit
        nvim-lint
        nvim-metals
        oil
        plenary
        precognition
        snacks
        stylelint
        surround
        treesitter
        ts-context
        vim-tmux-nav
        web-devicons
        which-key
        yazi
      ];

    extraPackages = [ ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
