{ pkgs, ... }: {

  programs.neovim = with pkgs; {
    enable = true;
    package = neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = let

      treesitter = {
        plugin = vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./plugins/treesitter.lua;
      };

      dressing = { plugin = vimPlugins.dressing-nvim; };

      diffview = {
        plugin = vimPlugins.diffview-nvim;
        type = "lua";
        config = ''
          require("diffview").setup({})
        '';
      };

      web-devicons = { plugin = vimPlugins.nvim-web-devicons; };

      oil = {
        plugin = vimPlugins.oil-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/oil.lua;
      };

      plenary = { plugin = vimPlugins.plenary-nvim; };

      telescope = [
        {
          plugin = vimPlugins.telescope-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/telescope.lua;
        }
        { plugin = vimPlugins.telescope-symbols-nvim; }
      ];

      lspconfig = {
        plugin = vimPlugins.nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./plugins/lspconfig.lua;
      };

      cmp = with vimPlugins; [
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./plugins/cmp.lua;
        }
        { plugin = cmp-buffer; }
        { plugin = cmp-path; }
        { plugin = cmp-vsnip; }
        { plugin = cmp-nvim-lsp; }
        { plugin = cmp-nvim-lsp-signature-help; }
        { plugin = vim-vsnip; }
      ];

      nvim-metals = {
        plugin = vimPlugins.nvim-metals;
        type = "lua";
        config = ''
          local metalsBinary = "${metals}/bin/metals"
          ${builtins.readFile ./plugins/metals.lua}
        '';
      };

      trouble = {
        plugin = vimPlugins.trouble-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/trouble.lua;
      };

      lsp-kind = {
        plugin = vimPlugins.lspkind-nvim;
        type = "lua";
      };

      indent-blank-line = {
        plugin = vimPlugins.indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/indent-blankline.lua;
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

      telescope_hoogle = {
        plugin = vimPlugins.telescope_hoogle;
        type = "lua";
      };

      telescope-manix = {
        plugin = vimPlugins.telescope-manix;
        type = "lua";
      };

      nvim-notify = {
        plugin = vimPlugins.nvim-notify;
        type = "lua";
        config = ''
          vim.notify = require("notify")
        '';
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

      vim-tmux-nav = { plugin = vimPlugins.vim-tmux-navigator; };

    in lib.lists.flatten [
      # nvim-notify
      cmp
      conform-nvim
      diffview
      dressing
      fidget
      gitsigns
      haskell-tools
      indent-blank-line
      lsp-kind
      lspconfig
      lualine
      lush
      neogit
      nvim-lint
      nvim-metals
      oil
      plenary
      stylelint
      surround
      telescope
      telescope-manix
      telescope_hoogle
      treesitter
      trouble
      vim-tmux-nav
      web-devicons
      which-key
    ];

    extraPackages = [ ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
