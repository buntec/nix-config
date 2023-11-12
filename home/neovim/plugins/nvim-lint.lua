require("lint").linters_by_ft = {
  markdown = { "vale" },
  nix = { "statix" },
  tex = { "chktex" },
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
