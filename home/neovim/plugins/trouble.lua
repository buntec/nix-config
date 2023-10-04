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
