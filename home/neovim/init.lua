-- local cmd = vim.cmd
-- local api = vim.api
local g = vim.g
local map = vim.keymap.set
local opt = vim.opt
local global_opt = vim.opt_global

g.mapleader = ","
g.maplocalleader = " "

-- cmd.language("en_US")

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

local indent = 2

opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = indent -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.tabstop = indent -- Number of spaces tabs count for

opt.list = true -- Show some invisible characters (tabs...)
opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers
opt.wrap = false -- Disable line wrap
opt.swapfile = false
opt.cursorline = true

map("n", "<C-j>", "<C-W><C-J>")
map("n", "<C-k>", "<C-W><C-K>")
map("n", "<C-l>", "<C-W><C-L>")
map("n", "<C-h>", "<C-W><C-H>")

map("i", "jk", "<Esc>")
map("i", "kj", "<Esc>")
map("i", "jj", "<Esc>")

local oil = require("oil")
local ts_bi = require("telescope.builtin")
local ts_ext = require("telescope").extensions
local trouble = require("trouble")
local gitsigns = require("gitsigns")
local notify = require("notify")

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>", { desc = "open init.lua" })
map("n", "<leader>-", oil.open, { desc = "Browse parent directory" })
map("n", "<leader>fa", function()
  ts_bi.find_files({ no_ignore = true, hidden = true })
end, { desc = "find all files" })
map("n", "<leader>ff", ts_bi.find_files, { desc = "find files" })
map("n", "<leader>gf", ts_bi.git_files, { desc = "find files (git)" })
map("n", "<leader>lg", ts_bi.live_grep, { desc = "live grep" })
map("n", "<leader>gs", ts_bi.grep_string, { desc = "grep string" })
map("n", "<leader>bu", ts_bi.buffers, { desc = "buffers" })
map("n", "<leader>co", ts_bi.commands, { desc = "commands" })
map("n", "<leader>di", ts_bi.diagnostics, { desc = "diagnostics" })
map("n", "<leader>ht", ts_bi.help_tags, { desc = "help tags" })
map("n", "<leader>ts", ts_bi.treesitter, { desc = "treesitter" })
map("n", "<leader>cs", function()
  ts_bi.colorscheme({ enable_preview = true })
end, { desc = "colorschemes" })
map("n", "<leader>gc", ts_bi.git_commits, { desc = "git commits" })
map("n", "<leader>gb", ts_bi.git_branches, { desc = "git branches" })
map("n", "<leader>gs", ts_bi.git_status, { desc = "git status" })
map("n", "<leader>sy", ts_bi.symbols, { desc = "emoji/symbols" })
map("n", "<leader>mc", ts_ext.metals.commands, { desc = "metals commands" })
map("n", "<leader>ho", ts_ext.hoogle.hoogle, { desc = "hoogle search" })
-- map("n", "<leader>hs", ext.ht.hoogle_signature, { desc = "hoogle signature" })
map("n", "<leader>ma", ts_ext.manix.manix, { desc = "manix search" })
map("n", "<leader>nh", gitsigns.next_hunk, { desc = "next hunk" })
map("n", "<leader>ph", gitsigns.prev_hunk, { desc = "previous hunk" })
map("n", "<leader>bl", gitsigns.toggle_current_line_blame, { desc = "blame line" })
map("n", "<leader>nd", notify.dismiss, { desc = "dismiss notifications" })
map("n", "<localleader>a", vim.lsp.buf.code_action, { desc = "lsp code action" })
map("n", "<localleader>d", ts_bi.lsp_definitions, { desc = "lsp definitions" })
-- map("n", "<localleader>d", vim.lsp.buf.definition, { desc = "lsp definition" })
map({ "n", "v" }, "<localleader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "format" })
-- map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format, { desc = "lsp format" })
map("n", "<localleader>h", vim.lsp.buf.hover, { desc = "lsp hover" })
map("n", "<localleader>m", vim.lsp.buf.rename, { desc = "lsp rename" })
map("n", "<localleader>i", ts_bi.lsp_implementations, { desc = "lsp implementation" })
--map("n", "<localleader>i", vim.lsp.buf.implementation, { desc = "lsp implementation" })
map("n", "<localleader>r", ts_bi.lsp_references, { desc = "lsp references" })
--map("n", "<localleader>r", vim.lsp.buf.references, { desc = "lsp references" })
map("n", "<localleader>s", ts_bi.lsp_document_symbols, { desc = "lsp document symbol" })
--map("n", "<localleader>s", vim.lsp.buf.document_symbol, { desc = "lsp document symbol" })
map("n", "<localleader>tt", trouble.toggle, { desc = "toggle trouble", silent = true, noremap = true })
map("n", "<localleader>tw", function()
  trouble.toggle("workspace_diagnostics")
end, { desc = "toggle workspace diagnostics" })
map("n", "<localleader>td", function()
  trouble.toggle("document_diagnostics")
end, { desc = "toggle document diagnostics" })
map("n", "<localleader>tl", function()
  trouble.toggle("loclist")
end, { desc = "toggle trouble (loclist)" })
map("n", "<localleader>tq", function()
  trouble.toggle("quickfix")
end, { desc = "toggle trouble (quickfix)" })

-- enable spell checking for text files
local spell_augroup = vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex", "gitcommit", "text" },
  callback = function()
    vim.opt.spell = true
  end,
  group = spell_augroup,
})
