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

telescope.load_extension('ht')     -- haskell-tools
telescope.load_extension('manix')  -- telescope-manix
telescope.load_extension('hoogle') -- telescope_hoogle
-- note: metals registers itself automatically ??
