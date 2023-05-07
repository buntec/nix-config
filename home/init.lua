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

g.tokyonight_style = "storm"
cmd 'colorscheme tokyonight'

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

map('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>")
map('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>")
map('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>")
map('n', '<F12>', "<cmd>lua require'dap'.step_out()<CR>")

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
