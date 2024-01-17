local telescope = require("telescope")

local actions = require("telescope.actions")
telescope.setup({
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        height = 0.95,
        preview_cutoff = 10,
        prompt_position = "bottom",
        width = 0.9,
      },
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.cycle_history_next,
        ["<C-k>"] = actions.cycle_history_prev,
      },
    },
  },
})

telescope.load_extension("ht") -- haskell-tools
telescope.load_extension("manix") -- telescope-manix
telescope.load_extension("hoogle") -- telescope_hoogle
-- note: metals registers itself automatically ??
