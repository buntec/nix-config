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
global_opt.timeout = true
global_opt.timeoutlen = 500 -- deafult is 1000

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
local gitsigns = require("gitsigns")
local fzf = require("fzf-lua")
local conform = require("conform")
local tscontext = require("treesitter-context")

-- stylua: ignore start

map("n", "<leader>cf", "<cmd>edit $MYVIMRC<CR>", { desc = "open init.lua" })

map("n", "<leader>-", oil.open, { desc = "browse parent directory" })

map("n", "<leader>ctx", tscontext.toggle, { desc = "toggle treesitter context" })

map("n", "<leader>ff", fzf.files, { desc = "find files" })

map("n", "<leader>gf", fzf.git_files, { desc = "find files (git)" })

map("n", "<leader>fh", fzf.oldfiles, { desc = "opened files history" })

map("n", "<leader>lg", function() fzf.live_grep({ }) end, { desc = "live grep" })

map("n", "<leader>rg", function() fzf.live_grep({ resume = true }) end, { desc = "resume live grep" })

map("n", "<leader>fs", fzf.grep_cword, { desc = "grep word under cursor" })

map("n", "<leader>sh", fzf.search_history, { desc = "search history" })

map("n", "<leader>re", fzf.resume, { desc = "resume last command/query" })

map("n", "<leader>bu", fzf.buffers, { desc = "buffers" })

map("n", "<leader>co", fzf.commands, { desc = "commands" })

map("n", "<leader>dd", fzf.diagnostics_document, { desc = "document diagnostics" })

map("n", "<leader>dw", fzf.diagnostics_workspace, { desc = "workspace diagnostics" })

map("n", "<leader>ht", fzf.help_tags, { desc = "help tags" })

map("n", "<leader>ts", fzf.treesitter, { desc = "current buffer treesitter symbols" })

map("n", "<leader>cs", fzf.colorschemes, { desc = "colorschemes" })

-- Git

map("n", "<leader>gc", fzf.git_commits, { desc = "git commits" })

map("n", "<leader>gl", fzf.git_bcommits, { desc = "git commit log (buffer)" })

map("n", "<leader>gb", fzf.git_branches, { desc = "git branches" })

map("n", "<leader>gs", fzf.git_status, { desc = "git status" })

map("n", "<leader>hn", function() gitsigns.nav_hunk("next") end, { desc = "jump to next hunk in current buffer" })

map("n", "<leader>hp", function() gitsigns.nav_hunk("prev") end, { desc = "jump to previous hunk in current buffer" })

map("n", "<leader>hv", gitsigns.preview_hunk, { desc = "preview hunk" })

map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })

map("n", "<leader>hrx", gitsigns.reset_hunk, { desc = "reset hunk" })

map("n", "<leader>brx", gitsigns.reset_buffer, { desc = "reset buffer" })

map("n", "<leader>lb", gitsigns.toggle_current_line_blame, { desc = "blame line" })

map("n", "<leader>ng", "<cmd>Neogit<cr>", { desc = "open Neogit" })

map("n", "<leader>dv", "<cmd>DiffviewOpen<cr>", { desc = "open Diffview" })

map("n", "<leader>cdv", "<cmd>DiffviewClose<cr>", { desc = "close Diffview" })

-- LSP

map("n", "<localleader>a", vim.lsp.buf.code_action, { desc = "lsp code action" })

map("n", "<localleader>h", vim.lsp.buf.hover, { desc = "lsp hover" })

map("n", "<localleader>m", vim.lsp.buf.rename, { desc = "lsp rename" })

map("n", "<localleader>d", vim.lsp.buf.definition, { desc = "lsp definition" })

-- typically there should only be one definition, and we don't want to open fzf in that case
-- we therefore map this to `k` for those rare cases where it makes sense and use `d` for the far more common scenario
map("n", "<localleader>k", fzf.lsp_definitions, { desc = "lsp definitions" })

map("n", "<localleader>i", fzf.lsp_implementations, { desc = "lsp implementation" })
--map("n", "<localleader>i", vim.lsp.buf.implementation, { desc = "lsp implementation" })

map("n", "<localleader>r", fzf.lsp_references, { desc = "lsp references" })
--map("n", "<localleader>r", vim.lsp.buf.references, { desc = "lsp references" })

map("n", "<localleader>s", fzf.lsp_document_symbols, { desc = "lsp document symbols" })
--map("n", "<localleader>s", vim.lsp.buf.document_symbol, { desc = "lsp document symbol" })

map("n", "<leader>ca", fzf.lsp_code_actions, { desc = "lsp code actions" })

map({ "n", "v" }, "<localleader>f", function() conform.format({ async = true }) end, { desc = "format buffer (async)" })
-- map({ "n", "v" }, "<localleader>f", vim.lsp.buf.format, { desc = "lsp format" }) -- we prefer Conform


-- barbar

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
map('n', '<A-.>', '<Cmd>BufferNext<CR>')

-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>')

-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<A-0>', '<Cmd>BufferLast<CR>')

-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>')

-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned

-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>')

-- Wipeout buffer
--                 :BufferWipeout

-- Close commands

--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight

-- Magic buffer-picking mode
--map('n', '<C-p>',   '<Cmd>BufferPick<CR>')
--map('n', '<C-s-p>', '<Cmd>BufferPickDelete<CR>')

---- Sort automatically by...
--map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>')
--map('n', '<Space>bn', '<Cmd>BufferOrderByName<CR>')
--map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>')
--map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>')
--map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>')

-- stylua: ignore end

-- highlight trailing whitespace
vim.fn.matchadd("ErrorMsg", [[\s\+$]])

-- enable spell checking for text files
local spell_augroup = vim.api.nvim_create_augroup("spell", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex", "gitcommit", "text" },
  callback = function()
    vim.opt.spell = true
  end,
  group = spell_augroup,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    -- In many languages the comment semantic highlight will overwrite useful treesitter highlights like @text.todo inside comments.
    vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
    -- Clangd only sends comment tokens for `#if 0` sections so it doesn't have the problem above.
    vim.api.nvim_set_hl(0, "@lsp.type.comment.cpp", { link = "@comment", default = true })
  end,
})
