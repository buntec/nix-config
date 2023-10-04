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
        config = ''
          require("tokyonight").setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            light_style = "day",    -- The theme is used when the background is set to light
            transparent = false,    -- Enable this to disable setting the background color
            terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
            styles = {
              -- Style to be applied to different syntax groups
              -- Value is any valid attr-list value for `:help nvim_set_hl`
              comments = { italic = true },
              keywords = { italic = true },
              functions = {},
              variables = {},
              -- Background styles. Can be "dark", "transparent" or "normal"
              sidebars = "dark",              -- style for sidebars, see below
              floats = "dark",                -- style for floating windows
            },
            sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
            day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
            hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
            dim_inactive = false,             -- dims inactive windows
            lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold
          })
          vim.cmd.colorscheme("tokyonight")
        '';
      };

      treesitter = {
        plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup {
            highlight = {
              enable = true,
            }
          }
        '';
      };

      dressing = { plugin = pkgs.vimPlugins.dressing-nvim; };

      web-devicons = { plugin = pkgs.vimPlugins.nvim-web-devicons; };

      oil = {
        plugin = pkgs.vimPlugins.oil-nvim;
        type = "lua";
        config = ''
          local oil = require("oil")
          oil.setup()
          vim.keymap.set("n", "<leader>-", oil.open, { desc = "Browse parent directory" })
        '';
      };

      plenary = { plugin = pkgs.vimPlugins.plenary-nvim; };

      telescope = [
        {
          plugin = pkgs.vimPlugins.telescope-nvim;
          type = "lua";
          config = ''
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            telescope.setup({
              defaults = {
                layout_strategy = "vertical",
                history = {
                  mappings = {
                    i = {
                      ["<C-Down>"] = actions.cycle_history_next,
                      ["<C-Up>"] = actions.cycle_history_prev,
                    },
                  },
                },
              },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>fa", function() builtin.find_files({ no_ignore = true, hidden = true }) end,
              { desc = "find all files" })
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "find files" })
            vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "find files (git)" })
            vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "live grep" })
            vim.keymap.set("n", "<leader>gs", builtin.grep_string, { desc = "grep string" })
            vim.keymap.set("n", "<leader>bu", builtin.buffers, { desc = "buffers" })
            vim.keymap.set("n", "<leader>co", builtin.commands, { desc = "commands" })
            vim.keymap.set("n", "<leader>ht", builtin.help_tags, { desc = "help tags" })
            vim.keymap.set("n", "<leader>ts", builtin.treesitter, { desc = "treesitter" })
            vim.keymap.set("n", "<leader>cs", function() builtin.colorscheme({ enable_preview = true }) end,
              { desc = "colorschemes" })
            vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "git commits" })
            vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "git branches" })
            vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "git status" })
            vim.keymap.set("n", "<leader>sy", builtin.symbols, { desc = "emoji/symbols" })
            vim.keymap.set("n", "<leader>mc", telescope.extensions.metals.commands, { desc = "metals commands" })
          '';
        }
        { plugin = pkgs.vimPlugins.telescope-symbols-nvim; }
      ];

      lspconfig = {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        type = "lua";
        config = ''
          local lsp_config = require("lspconfig")
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config,
            { capabilities = capabilities, })

          lsp_config.smithy_ls.setup({
            cmd = { "cs", "launch", "com.disneystreaming.smithy:smithy-language-server:latest.stable", "--", "0", }, })

          lsp_config.hls.setup {}

          lsp_config.bashls.setup {}

          lsp_config.pylsp.setup {}

          lsp_config.gopls.setup {}

          lsp_config.tsserver.setup {}

          lsp_config.html.setup {}

          lsp_config.nil_ls.setup({
            settings = {
              ["nil"] = {
                formatting = {
                  command = { "nixfmt" },
                },
              },
            },
          })

          lsp_config.lua_ls.setup({
            settings = {
              Lua = {
                format = {
                  enable = true,
                },
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { "vim" },
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
          })

          lsp_config.texlab.setup({
            capabilities = capabilities,
            settings = {
              texlab = {
                auxDirectory = ".",
                bibtexFormatter = "texlab",
                build = {
                  args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                  executable = "latexmk",
                  forwardSearchAfter = false,
                  onSave = true,
                },
                chktex = {
                  onEdit = false,
                  onOpenAndSave = true,
                },
                diagnosticsDelay = 300,
                formatterLineLength = 80,
                forwardSearch = {
                  args = {},
                },
                latexFormatter = "latexindent",
                latexindent = {
                  modifyLineBreaks = true,
                },
              },
            },
          })
        '';
      };

      cmp = with pkgs.vimPlugins; [
        {
          plugin = nvim-cmp;
          type = "lua";
          config = ''
            local cmp = require("cmp")
            local lspkind = require("lspkind")
            cmp.setup({
              snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                  vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
                  mode = "symbol",       -- show only symbol annotations
                  maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                  ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                }),
              },
            })
          '';
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
          local metals_config = require("metals").bare_config()

          metals_config.init_options.statusBarProvider = "on"

          metals_config.settings = {
            serverVersion = "latest.snapshot",
          }

          -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
          metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

          -- Autocmd that will actually be in charging of starting the whole thing
          local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
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
      };

      trouble = {
        plugin = pkgs.vimPlugins.trouble-nvim;
        type = "lua";
        config = ''
          require("trouble").setup({})
          vim.keymap.set("n", "<localleader>tt", "<cmd>TroubleToggle<cr>",
            { desc = "toggle trouble", silent = true, noremap = true })
          vim.keymap.set(
            "n",
            "<localleader>tw",
            "<cmd>TroubleToggle workspace_diagnostics<cr>",
            { silent = true, noremap = true, desc = "toggle workspace diagnostics" }
          )
          vim.keymap.set(
            "n",
            "<localleader>td",
            "<cmd>TroubleToggle document_diagnostics<cr>",
            { silent = true, noremap = true, desc = "toggle document diagnostics" }
          )
          vim.keymap.set("n", "<localleader>tl", "<cmd>TroubleToggle loclist<cr>",
            { silent = true, noremap = true, desc = "toggle trouble (loclist)" })
          vim.keymap.set("n", "<localleader>tq", "<cmd>TroubleToggle quickfix<cr>",
            { silent = true, noremap = true, desc = "toggle trouble (quickfix)" })
        '';
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
        config = ''
          require("indent_blankline").setup {
              -- for example, context is off by default, use this to turn it on
              show_current_context = true,
              show_current_context_start = true,
          }
        '';
      };

      which-key = {
        plugin = pkgs.vimPlugins.which-key-nvim;
        type = "lua";
        config = ''
          vim.o.timeout = true
          vim.o.timeoutlen = 300
        '';
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
        config = ''
          require("lualine").setup({
            options = {
              theme = "tokyonight",
              section_separators = { "", "" },
              component_separators = { "", "" },
              icons_enabled = true,
            },
            sections = {
              lualine_a = { { "mode", upper = true } },
              lualine_b = { { "branch", icon = "" } },
              lualine_c = { { "filename", file_status = true }, "g:metals_status" },
              lualine_x = { "encoding", "fileformat", "filetype" },
              lualine_y = { "progress" },
              lualine_z = { "location" },
            },
            inactive_sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = { "filename" },
              lualine_x = { "location" },
              lualine_y = {},
              lualine_z = {},
            },
            extensions = { "fzf" },
          })
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
      telescope
      tokyonight
      treesitter
      trouble
      web-devicons
      which-key
    ];

    extraPackages = with pkgs; [
      nil
      lua-language-server
      gopls
      haskell-language-server
      vscode-langservers-extracted
    ];

    extraLuaConfig = (builtins.readFile ./init.lua);
  };
}
