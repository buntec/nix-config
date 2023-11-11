{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = let

      # TODO: replace with nixpkgs version when available
      lsp-progress = {
        plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "lsp-progress.nvim";
          version = "2023-10-21";
          src = pkgs.fetchFromGitHub {
            owner = "linrongbin16";
            repo = "lsp-progress.nvim";
            rev = "df7a3d0d865d584552ab571295e73868e736e60f";
            sha256 = "sha256-+bp8t+CPFQD6iUENc7ktHxIkMpJdQabA9Ouzk5GV2IM=";
          };
          meta.homepage = "https://github.com/linrongbin16/lsp-progress.nvim/";
        };
        type = "lua";
        config = ''
          require("lsp-progress").setup {};
        '';
      };

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
        config = ''
          local metalsBinary = "${pkgs.metals}/bin/metals"
          ${builtins.readFile ./plugins/metals.lua}
        '';
      };

      trouble = {
        plugin = pkgs.vimPlugins.trouble-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/trouble.lua;
      };

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

      nvim-lint = {
        plugin = pkgs.vimPlugins.nvim-lint;
        type = "lua";
        config = builtins.readFile ./plugins/nvim-lint.lua;
      };

      conform-nvim = {
        plugin = pkgs.vimPlugins.conform-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/conform-nvim.lua;
      };

      haskell-tools = {
        plugin = pkgs.vimPlugins.haskell-tools-nvim;
        type = "lua";
        config = builtins.readFile ./plugins/haskell-tools.lua;
      };

      telescope_hoogle = {
        plugin = pkgs.vimPlugins.telescope_hoogle;
        type = "lua";
      };

      telescope-manix = {
        plugin = pkgs.vimPlugins.telescope-manix;
        type = "lua";
      };

      nvim-notify = {
        plugin = pkgs.vimPlugins.nvim-notify;
        type = "lua";
        config = ''
          vim.notify = require("notify")
        '';
      };

    in pkgs.lib.lists.flatten [
      cmp
      conform-nvim
      dressing
      gitsigns
      haskell-tools
      indent-blank-line
      lsp-kind
      lsp-progress
      lspconfig
      lualine
      metals
      nvim-lint
      nvim-notify
      oil
      plenary
      surround
      telescope
      telescope-manix
      telescope_hoogle
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
