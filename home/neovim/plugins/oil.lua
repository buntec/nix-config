local oil = require("oil")
oil.setup()
vim.keymap.set("n", "<leader>-", oil.open, { desc = "Browse parent directory" })
