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
