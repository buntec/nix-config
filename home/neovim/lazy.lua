local tokyonight = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}

local mason = {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end,
  build = ':MasonInstall stylua lua-language-server nil python-lsp-server haskell-language-server gopls html-lsp'
}

local dressing = {
  'stevearc/dressing.nvim',
  opts = {},
}

local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "scala", "python", "html", "css", "javascript", "ts" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

      highlight = {
        enable = true,
      },
    }
  end,
}

local oil = {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
  end,
}

local telescope = {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope-symbols.nvim" },
  config = function()
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
    vim.keymap.set("n", "<leader>fa", function() builtin.find_files({ no_ignore = true, hidden = true }) end)
    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>gf", builtin.git_files)
    vim.keymap.set("n", "<leader>lg", builtin.live_grep)
    vim.keymap.set("n", "<leader>gs", builtin.grep_string)
    vim.keymap.set("n", "<leader>bu", builtin.buffers)
    vim.keymap.set("n", "<leader>co", builtin.commands)
    vim.keymap.set("n", "<leader>ht", builtin.help_tags)
    vim.keymap.set("n", "<leader>ts", builtin.treesitter)
    vim.keymap.set("n", "<leader>cs", function() builtin.colorscheme({ enable_preview = true }) end)
    vim.keymap.set("n", "<leader>gc", builtin.git_commits)
    vim.keymap.set("n", "<leader>gb", builtin.git_branches)
    vim.keymap.set("n", "<leader>gs", builtin.git_status)
    vim.keymap.set("n", "<leader>sy", builtin.symbols)
    vim.keymap.set("n", "<leader>mc", telescope.extensions.metals.commands)
  end,
}

local lspconfig = {
  "neovim/nvim-lspconfig",
  config = function()
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
  end,
}

local cmp = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
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
  end,
}

local metals = {
  "scalameta/nvim-metals",
  dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/cmp-nvim-lsp" },
  config = function()
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
  end,
}

local trouble = {
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
}

local lualine = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "folke/tokyonight.nvim",
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
        lualine_c = { { "filename", file_status = true }, require("lsp-progress").progress(), "g:metals_status" },
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
}

local gitsigns = {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end,
}

local lspprogess = {
  "linrongbin16/lsp-progress.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lsp-progress").setup()
  end,
}

local vimnix = {
  "LnL7/vim-nix"
}

local lspkind = {
  "onsails/lspkind.nvim",
  lazy = true
}

require("lazy").setup({
  dressing,
  tokyonight,
  lualine,
  oil,
  mason,
  treesitter,
  telescope,
  lspconfig,
  cmp,
  metals,
  trouble,
  gitsigns,
  lspprogess,
  vimnix,
  lspkind
})
