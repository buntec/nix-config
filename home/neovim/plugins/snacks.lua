local snacks = require("snacks")

snacks.setup({
  -- input = { enabled = true },
  bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  indent = { enabled = true },
  quickfile = { enabled = true },
  -- notifier = { enabled = true },
  scope = {
    enabled = true,
  },
  scroll = {
    -- btmux's built-in Neovim animates scrolling itself
    enabled = not vim.g.btmux,
    animate = {
      duration = { step = 10, total = 100 },
      easing = "linear",
    },
  },
  words = { enabled = true },
  toggle = { enabled = true },
  -- statuscolumn = { enabled = true },
})
