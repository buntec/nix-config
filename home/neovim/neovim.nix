{pkgs, ...}: {
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
          vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
          vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
          vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
          vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)

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
          local tb = require('telescope.builtin')
          vim.keymap.set('n', '<leader>fa', function() tb.find_files({ no_ignore = true, hidden = true }) end)
          vim.keymap.set('n', '<leader>ff', tb.find_files)
          vim.keymap.set('n', '<leader>gf', tb.git_files)
          vim.keymap.set('n', '<leader>lg', tb.live_grep)
          vim.keymap.set('n', '<leader>gs', tb.grep_string)
          vim.keymap.set('n', '<leader>bu', tb.buffers)
          vim.keymap.set('n', '<leader>co', tb.commands)
          vim.keymap.set('n', '<leader>ht', tb.help_tags)
          vim.keymap.set('n', '<leader>ts', tb.treesitter)
          vim.keymap.set('n', '<leader>cs', function() tb.colorscheme({ enable_preview = true }) end)
          vim.keymap.set('n', '<leader>gc', tb.git_commits)
          vim.keymap.set('n', '<leader>gb', tb.git_branches)
          vim.keymap.set('n', '<leader>gs', tb.git_status)
          vim.keymap.set('n', '<leader>sy', tb.symbols)
          vim.keymap.set("n", "<leader>mc", require("telescope").extensions.metals.commands)
        '';
      }
      telescope-symbols-nvim
      # {
      #   plugin = telescope-file-browser-nvim;
      #   type = "lua";
      #   config = ''
      #     vim.keymap.set("n", "-",
      #       function()
      #         require("telescope").extensions.file_browser.file_browser({
      #           path = '%:p:h',
      #           select_buffer = true,
      #           respect_gitignore = true,
      #           collapse_dirs = true,
      #           hide_parent_dir = true,
      #         })
      #       end)
      #   '';
      # }
      {
        plugin = oil-nvim;
        type = "lua";
        config = ''
          require("oil").setup()
          vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        '';
      }
      {
        plugin = telescope-ui-select-nvim;
        type = "lua";
        config = ''
          require("telescope").load_extension("ui-select")
        '';
      }
      # {
      #   plugin = todo-comments-nvim;
      #   type = "lua";
      #   config = ''
      #     require("todo-comments").setup()
      #     vim.keymap.set("n", "<localleader>to", "<cmd>TodoTelescope<cr>", { silent = true, noremap = true })
      #   '';
      # }
      # {
      #   plugin = neoscroll-nvim;
      #   type = "lua";
      #   config = ''
      #     require('neoscroll').setup({
      #       easing_function = "quadratic"
      #     })
      #   '';
      # }
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
          lsp.smithy_ls.setup {
            cmd = { '${pkgs.coursier}/bin/cs', 'launch', 'com.disneystreaming.smithy:smithy-language-server:latest.stable', '--', '0' }
          }
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
                  command = { "alejandra" },
                },
              }
            }
          }

          lsp.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                format = {
                  enable = false,
                },
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
          vim.keymap.set("n", "<localleader>tt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
          vim.keymap.set("n", "<localleader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
          vim.keymap.set("n", "<localleader>td", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
          vim.keymap.set("n", "<localleader>tl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
          vim.keymap.set("n", "<localleader>tq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
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
}
