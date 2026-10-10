-- btmux's built-in Neovim shows progress and messages itself
if not vim.g.btmux then
  require("fidget").setup({
    notification = {
      window = {
        winblend = 0, -- background opacity
      },
    },
  })
end
