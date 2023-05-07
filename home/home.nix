{pkgs, ...}: {
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.syncthing = {
    enable = true;
    extraOptions = [];
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
      {
        plugin = nvim-dap;
        type = "lua";
        config = ''
          local dap = require("dap")
          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "Run",
              metals = {
                runType = "run",
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test File",
              metals = {
                runType = "testFile",
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = {
              theme = 'tokyonight',
              section_separators = { '', '' },
              component_separators = { '', '' },
              icons_enabled = true,
            },
            sections = {
              lualine_a = { { 'mode', upper = true } },
              lualine_b = { { 'branch', icon = '' } },
              lualine_c = { { 'filename', file_status = true }, require 'lsp-status'.status, 'g:metals_status' },
              lualine_x = { 'encoding', 'fileformat', 'filetype' },
              lualine_y = { 'progress' },
              lualine_z = { 'location' },
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = { 'filename' },
              lualine_x = { 'location' },
              lualine_y = {},
              lualine_z = {}
            },
            extensions = { 'fzf' }
          }
        '';
      }
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
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require('telescope').setup {
            defaults = {
              layout_strategy = 'vertical',
              history = {
                mappings = {
                  i = {
                    ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                    ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
                  },
                },
              }
            },
          }
        '';
      }
      telescope-file-browser-nvim
      {
        plugin = neoscroll-nvim;
        type = "lua";
        config = ''
          require('neoscroll').setup({
            easing_function = "quadratic"
          })
        '';
      }
      unicode-vim
      {
        plugin = lsp-status-nvim;
        type = "lua";
        config = ''
          require('lsp-status').register_progress()
        '';
      }
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require 'cmp'
          local lspkind = require 'lspkind'
          cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-p>'] = cmp.mapping.select_prev_item(),
              ['<C-n>'] = cmp.mapping.select_next_item(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
              { name = "nvim_lsp",               priority = 10 },
              { name = "buffer" },
              { name = "vsnip" },
              { name = "path" },
              { name = "nvim_lsp_signature_help" },
            },
            formatting = {
              format = lspkind.cmp_format({
                mode = 'symbol', -- show only symbol annotations
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
              })
            },
          })
        '';
      }
      cmp-buffer
      cmp-path
      vim-vsnip
      cmp-vsnip
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local lsp = require 'lspconfig'
          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          -- lsp.metals.setup {} -- we use nvim-metals instead
          lsp.hls.setup { capabilities = capabilities }
          lsp.bashls.setup { capabilities = capabilities }
          lsp.pylsp.setup { capabilities = capabilities }
          lsp.gopls.setup { capabilities = capabilities }
          lsp.tsserver.setup { capabilities = capabilities }
          lsp.html.setup { capabilities = capabilities }
          lsp.nil_ls.setup { capabilities = capabilities,
            settings = {
              ['nil'] = {
                formatting = {
                  command = { "nixpkgs-fmt" },
                },
              }
            }
          }

          lsp.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                  enable = false,
                },
              },
            },
          }

          lsp.texlab.setup {
            capabilities = capabilities,
            settings = {
              texlab = {
                auxDirectory = ".",
                bibtexFormatter = "texlab",
                build = {
                  args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                  executable = "latexmk",
                  forwardSearchAfter = false,
                  onSave = true
                },
                chktex = {
                  onEdit = false,
                  onOpenAndSave = true
                },
                diagnosticsDelay = 300,
                formatterLineLength = 80,
                forwardSearch = {
                  args = {}
                },
                latexFormatter = "latexindent",
                latexindent = {
                  modifyLineBreaks = true
                }
              }
            }
          }
        '';
      }
      vim-nix
      tokyonight-nvim
      {
        plugin = trouble-nvim;
        type = "lua";
        config = ''
          require("trouble").setup { }
        '';
      }
      vim-fugitive
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require('gitsigns').setup()
        '';
      }
      {
        plugin = nvim-metals;
        type = "lua";
        config = ''
          local metals_config = require("metals").bare_config()
          metals_config.init_options.statusBarProvider = "on"
          metals_config.settings = {
            serverVersion = "latest.snapshot"
          }
          metals_config.on_attach = function(client, bufnr)
            require("metals").setup_dap()
          end

          -- Autocmd that will actually be in charging of starting the whole thing
          local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
          api.nvim_create_autocmd("FileType", {
            -- NOTE: You may or may not want java included here. You will need it if you
            -- want basic Java support but it may also conflict if you are using
            -- something like nvim-jdtls which also works on a java filetype autocmd.
            pattern = { "scala", "sbt", "java" },
            callback = function()
              require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
          })
        '';
      }
      {
        plugin = null-ls-nvim;
        type = "lua";
        config = ''
          local null_ls = require("null-ls")
          null_ls.setup({
              sources = {
                  null_ls.builtins.formatting.stylua,
                  null_ls.builtins.diagnostics.eslint,
                  null_ls.builtins.formatting.black,
                  null_ls.builtins.diagnostics.flake8,
                  null_ls.builtins.completion.spell,
                  null_ls.builtins.code_actions.gitsigns,
                  null_ls.builtins.diagnostics.gitlint,
                  null_ls.builtins.code_actions.statix,
                  null_ls.builtins.formatting.alejandra,
                  null_ls.builtins.diagnostics.chktex,
                  null_ls.builtins.diagnostics.deadnix,
                  null_ls.builtins.code_actions.shellcheck,
                  null_ls.builtins.formatting.shellharden,
                  null_ls.builtins.formatting.shfmt,
                  null_ls.builtins.diagnostics.cppcheck,
                  null_ls.builtins.diagnostics.markdownlint,
              },
          })

        '';
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
      alejandra
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
    terminal = "screen-256color";
    escapeTime = 0;
    extraConfig = ''
      set -g default-command "exec ${pkgs.fish}/bin/fish"
    '';
  };

  programs.zsh = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
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

      # ls
      la = "exa -la --color=never --git --icons";
      l = "exa -l --color=never --git --icons";
    };
  };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;
}
