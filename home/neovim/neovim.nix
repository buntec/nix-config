{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = let

      tokyonight = {
        plugin = pkgs.vimPlugins.tokyonight-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/tokyonight.lua;
      };

      treesitter = {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./plugins/treesitter.lua;
      };

      dressing = { plugin = pkgs.vimPlugins.dressing-nvim; };

      web-devicons = { plugin = pkgs.vimPlugins.nvim-web-devicons; };

      oil = {
        plugin = pkgs.vimPlugins.oil-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/oil.lua;
      };

      plenary = { plugin = pkgs.vimPlugins.plenary-nvim; };

      telescope = [
        {
          plugin = pkgs.vimPlugins.telescope-nvim;
          type = "lua";
          config = builtins.readFile ./plugins/telescope.lua;
        }
        { plugin = pkgs.vimPlugins.telescope-symbols-nvim; }
      ];

      lspconfig = {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./plugins/lspconfig.lua;
      };

      cmp = with pkgs.vimPlugins; [
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

      metals = {
        plugin = pkgs.vimPlugins.nvim-metals;
        type = "lua";
        config = builtins.readFile ./plugins/metals.lua;
      };

      trouble = {
        plugin = pkgs.vimPlugins.trouble-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/trouble.lua;
      };

      # TODO: uncomment when available in nixpkgs
      # lsp-progress = {
      #   plugin = pkgs.vimPlugins.lsp-progress-nvim;
      #   type = "lua";
      #   config = ''
      #     require("lsp-progress").setup()
      #   '';
      # };

      lsp-kind = {
        plugin = pkgs.vimPlugins.lspkind-nvim;
        type = "lua";
      };

      indent-blank-line = {
        plugin = pkgs.vimPlugins.indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/indent-blankline.lua;
      };

      which-key = {
        plugin = pkgs.vimPlugins.which-key-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/which-key.lua;
      };

      gitsigns = {
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        type = "lua";
        config = ''
          require("gitsigns").setup()
        '';
      };

      lualine = {
        plugin = pkgs.vimPlugins.lualine-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/lualine.lua;
      };

      surround = {
        plugin = pkgs.vimPlugins.nvim-surround;
        type = "lua";
        config = ''
          require("nvim-surround").setup({})
        '';
      };

    in pkgs.lib.lists.flatten [
      cmp
      dressing
      gitsigns
      indent-blank-line
      lsp-kind
      lspconfig
      lualine
      metals
      oil
      plenary
      surround
      telescope
      tokyonight
      treesitter
      trouble
      web-devicons
      which-key
    ];

    extraPackages = with pkgs; [
      gopls
      haskell-language-server
      lua-language-server
      nil
      nodePackages.bash-language-server
      nodePackages.typescript-language-server
      texlab
      vscode-langservers-extracted
    ];

    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
