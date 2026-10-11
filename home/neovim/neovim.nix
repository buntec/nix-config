{ pkgs, ... }:
{

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;

    plugins =
      let
        aerial = {
          plugin = vimPlugins.aerial-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/aerial.lua;
        };

        # https://github.com/stevearc/conform.nvim
        conform = {
          plugin = vimPlugins.conform-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/conform-nvim.lua;
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
            require("gitsigns").setup({
              current_line_blame = true,
            })
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
            -- Stand in for nvim-web-devicons (lualine, fzf-lua, aerial, grug-far)
            MiniIcons.mock_nvim_web_devicons()
          '';
        };

        # https://github.com/mfussenegger/nvim-lint
        nvim-lint = {
          plugin = vimPlugins.nvim-lint;
          type = "lua";
          config = builtins.readFile ./plugins/nvim-lint.lua;
        };

        # https://github.com/tris203/precognition.nvim
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

        # https://github.com/folke/which-key.nvim
        which-key = {
          plugin = vimPlugins.which-key-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/which-key.lua;
        };

        text-case = {
          plugin = vimPlugins.text-case-nvim;
          type = "lua";
        };

      in
      lib.lists.flatten [
        aerial
        conform
        fzf-lua
        gitsigns
        grug-far
        lspconfig
        lualine
        mini-icons
        nvim-lint
        plenary
        precognition
        snacks
        surround
        text-case
        treesitter
        ts-context
        which-key
      ];

    extraPackages = [ ];

    initLua = builtins.readFile ./init.lua;
  };
}
