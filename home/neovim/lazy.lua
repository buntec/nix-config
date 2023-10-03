require("lazy").setup({
  "nvim-telescope/telescope-symbols.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").load_extension("ui-select")
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          history = {
            mappings = {
              i = {
                ["<C-Down>"] = require("telescope.actions").cycle_history_next,
                ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
              },
            },
          },
        },
      })
      local tb = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fa", function()
        tb.find_files({ no_ignore = true, hidden = true })
      end)
      vim.keymap.set("n", "<leader>ff", tb.find_files)
      vim.keymap.set("n", "<leader>gf", tb.git_files)
      vim.keymap.set("n", "<leader>lg", tb.live_grep)
      vim.keymap.set("n", "<leader>gs", tb.grep_string)
      vim.keymap.set("n", "<leader>bu", tb.buffers)
      vim.keymap.set("n", "<leader>co", tb.commands)
      vim.keymap.set("n", "<leader>ht", tb.help_tags)
      vim.keymap.set("n", "<leader>ts", tb.treesitter)
      vim.keymap.set("n", "<leader>cs", function()
        tb.colorscheme({ enable_preview = true })
      end)
      vim.keymap.set("n", "<leader>gc", tb.git_commits)
      vim.keymap.set("n", "<leader>gb", tb.git_branches)
      vim.keymap.set("n", "<leader>gs", tb.git_status)
      vim.keymap.set("n", "<leader>sy", tb.symbols)
      vim.keymap.set("n", "<leader>mc", require("telescope").extensions.metals.commands)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- lsp.metals.setup {} -- we use nvim-metals instead
      lsp.smithy_ls.setup({
        cmd = {
          "${pkgs.coursier}/bin/cs",
          "launch",
          "com.disneystreaming.smithy:smithy-language-server:latest.stable",
          "--",
          "0",
        },
      })
      lsp.hls.setup({ capabilities = capabilities })
      lsp.bashls.setup({ capabilities = capabilities })
      lsp.pylsp.setup({ capabilities = capabilities })
      lsp.gopls.setup({ capabilities = capabilities })
      lsp.tsserver.setup({ capabilities = capabilities })
      lsp.html.setup({ capabilities = capabilities })
      lsp.nil_ls.setup({
        capabilities = capabilities,
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })

      lsp.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            format = {
              enable = false,
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

      lsp.texlab.setup({
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
    end,
  },
  "nvim-lua/plenary.nvim",
  "onsails/lspkind.nvim",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  {
    "hrsh7th/nvim-cmp",
    config = function()
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
          { name = "nvim_lsp", priority = 10 },
          { name = "buffer" },
          { name = "vsnip" },
          { name = "path" },
          { name = "nvim_lsp_signature_help" },
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          }),
        },
      })
    end,
  },
  {
    "scalameta/nvim-metals",
    config = function()
      local metals_config = require("metals").bare_config()

      metals_config.init_options.statusBarProvider = "on"

      metals_config.settings = {
        serverVersion = "latest.snapshot",
      }

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end

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
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
      vim.keymap.set("n", "<localleader>tt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
      vim.keymap.set(
        "n",
        "<localleader>tw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      vim.keymap.set(
        "n",
        "<localleader>td",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      vim.keymap.set("n", "<localleader>tl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
      vim.keymap.set("n", "<localleader>tq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  "nvim-tree/nvim-web-devicons",
  {
    -- integrate with lualine
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
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
          lualine_c = { { "filename", file_status = true }, require("lsp-status").status, "g:metals_status" },
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
    end,
  },
  {
    "linrongbin16/lsp-progress.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lsp-progress").setup()
    end,
  },
})
