-------------------- HELPERS -------------------------------
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local api = vim.api
local fn = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g = vim.g     -- a table to access global variables
local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

------------------------ PLUGINS ---------------------------
require('lsp-status').register_progress()


----------------- NEOSCROLL ----------------------------------
require('neoscroll').setup({
  easing_function = "quadratic"
})

------------------------ COLORSCHEME ----------------------
g.tokyonight_style = "storm"
cmd 'colorscheme tokyonight' -- Put your favorite colorscheme here

------------------------ OPTIONS --------------------------
g.mapleader = ','
g.maplocalleader = ' '
local indent = 2

opt('b', 'expandtab', true)                      -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)                   -- Size of an indent
opt('b', 'smartindent', true)                    -- Insert indents automatically
opt('b', 'tabstop', indent)                      -- Number of spaces tabs count for
opt('o', 'completeopt', 'menu,menuone,noselect') -- Completion options
opt('o', 'hidden', true)                         -- Enable modified buffers in background
opt('o', 'ignorecase', true)                     -- Ignore case
opt('o', 'joinspaces', false)                    -- No double spaces with join after a dot
opt('o', 'scrolloff', 4)                         -- Lines of context
opt('o', 'shiftround', true)                     -- Round indent
opt('o', 'sidescrolloff', 8)                     -- Columns of context
opt('o', 'smartcase', true)                      -- Don't ignore case with capitals
opt('o', 'splitbelow', true)                     -- Put new windows below current
opt('o', 'splitright', true)                     -- Put new windows right of current
opt('o', 'termguicolors', true)                  -- True color support
opt('o', 'wildmode', 'list:longest')             -- Command-line completion mode
opt('w', 'list', true)                           -- Show some invisible characters (tabs...)
opt('w', 'number', true)                         -- Print line number
opt('w', 'relativenumber', true)                 -- Relative line numbers
opt('w', 'wrap', false)                          -- Disable line wrap

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {
  --ensure_installed = "all",
  --ignore_install = { "phpdoc" },
  highlight = {
    enable = true,
    --disable = { "fish" }
  }
}

-------------------- NVIM-CMP ------------------------------
local cmp = require 'cmp'
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
})

-------------------- LSP -----------------------------------
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

vim.keymap.set('n', '<localleader>a', vim.lsp.buf.code_action)
vim.keymap.set('n', '<localleader>d', vim.lsp.buf.definition)
vim.keymap.set('n', '<localleader>f', vim.lsp.buf.format)
vim.keymap.set('v', '<localleader>f', vim.lsp.buf.format)

vim.keymap.set('n', '<localleader>i', vim.lsp.buf.implementation)
vim.keymap.set('n', '<localleader>h', vim.lsp.buf.hover)
vim.keymap.set('n', '<localleader>m', vim.lsp.buf.rename)
vim.keymap.set('n', '<localleader>r', vim.lsp.buf.references)
vim.keymap.set('n', '<localleader>s', vim.lsp.buf.document_symbol)

vim.keymap.set("n", "<localleader>tt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<localleader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<localleader>td", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<localleader>tl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<localleader>tq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })

------------------ NVIM-METALS --------------------
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

------------------- TELESCOPE ---------------------------------
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "target", "node_modules", "parser.c", "%.min.js" },
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
vim.keymap.set('n', '<leader>ff', function() tb.find_files({ no_ignore = true }) end)
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
vim.keymap.set("n", "<leader>mc", require("telescope").extensions.metals.commands)
-- vim.keymap.set("n", "-", require("telescope").extensions.file_browser.file_browser)
vim.keymap.set("n", "-",
  function()
    require("telescope").extensions.file_browser.file_browser({
      path = '%:p:h',
      select_buffer = true,
      respect_gitignore = true,
      collapse_dirs = true,
      hide_parent_dir = true,
    })
  end)




------------------- GITSIGNS ----------------------------------
require('gitsigns').setup()

------------------ LUALINE ------------------------------------
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

------------------ DAP -------------------------------------
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

map('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>")
map('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>")
map('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>")
map('n', '<F12>', "<cmd>lua require'dap'.step_out()<CR>")
--map('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
--map('n', '<leader>dr', "<cmd>lua require'dap'.repl.open()<CR>")
--map('n', '<leader>dr', "<cmd>lua require'dap'.repl.open()<CR>")
--map('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<CR>")

--------------- OTHER KEY MAPPINGS --------------------------
map('n', '<leader>cf', '<cmd>edit $MYVIMRC<CR>')

map('n', '<C-j>', '<C-W><C-J>')
map('n', '<C-k>', '<C-W><C-K>')
map('n', '<C-l>', '<C-W><C-L>')
map('n', '<C-h>', '<C-W><C-H>')

map('i', 'jk', '<Esc>')
map('i', 'kj', '<Esc>')
map('i', 'jj', '<Esc>')

cmd 'language en_US'
--cmd 'setlocal spell spelllang=en_us'
cmd 'set clipboard+=unnamedplus'
vim.opt_global.shortmess:remove("F") -- recommended for nvim-metals
