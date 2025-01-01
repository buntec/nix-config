local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")

fzf.setup({
  winopts = {
    fullscreen = true,
    height = 0.95,
    width = 0.95,
    preview = {
      layout = "vertical",
      wrap = "wrap",
    },
  },
  keymap = {
    builtin = {
      true, -- inherit defaults
      ["<C-u>"] = "preview-page-up",
      ["<C-d>"] = "preview-page-down",
    },
    fzf = {
      true, -- inherit defaults
      ["ctrl-u"] = "preview-page-up",
      ["ctrl-d"] = "preview-page-down",
    },
  },
  actions = {
    files = {
      true, -- inherit defaults
      -- ["ctrl-i"] = actions.toggle_ignore,
      ["ctrl-h"] = actions.toggle_hidden,
    },
  },
  fzf_opts = {
    ["--cycle"] = true,
  },
  fzf_colors = {
    true,
    ["fg+"] = { "fg", "Normal", "underline" },
    ["bg+"] = { "bg", { "CursorLine", "Normal" } },
  },
})
