local cmd = vim.cmd
local api = vim.api
local g = vim.g
local map = vim.keymap.set
local opt = vim.opt
local global_opt = vim.opt_global

g.mapleader = ","
g.maplocalleader = " "

g.tokyonight_style = "storm"
cmd.colorscheme("tokyonight")

cmd.language("en_US")

local indent = 2

global_opt.shortmess:remove("F") -- recommended for nvim-metals
global_opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
global_opt.hidden = true -- Enable modified buffers in background
global_opt.ignorecase = true -- Ignore case
global_opt.joinspaces = false -- No double spaces with join after a dot
global_opt.scrolloff = 4 -- Lines of context
global_opt.shiftround = true -- Round indent
global_opt.sidescrolloff = 8 -- Columns of context
global_opt.smartcase = true -- Don't ignore case with capitals
global_opt.splitbelow = true -- Put new windows below current
global_opt.splitright = true -- Put new windows right of current
global_opt.termguicolors = true -- True color support
global_opt.wildmode = "list:longest" -- Command-line completion mode
global_opt.clipboard = "unnamedplus"

opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = indent -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.tabstop = indent -- Number of spaces tabs count for

opt.list = true -- Show some invisible characters (tabs...)
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.wrap = false -- Disable line wrap

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>")

map("n", "<C-j>", "<C-W><C-J>")
map("n", "<C-k>", "<C-W><C-K>")
map("n", "<C-l>", "<C-W><C-L>")
map("n", "<C-h>", "<C-W><C-H>")

map("i", "jk", "<Esc>")
map("i", "kj", "<Esc>")
map("i", "jj", "<Esc>")

map("n", "<localleader>a", vim.lsp.buf.code_action)
map("n", "<localleader>d", vim.lsp.buf.definition)
map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format)
map("n", "<localleader>i", vim.lsp.buf.implementation)
map("n", "<localleader>h", vim.lsp.buf.hover)
map("n", "<localleader>m", vim.lsp.buf.rename)
map("n", "<localleader>r", vim.lsp.buf.references)
map("n", "<localleader>s", vim.lsp.buf.document_symbol)
