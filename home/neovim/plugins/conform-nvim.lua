require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    --markdown = { "mdformat" }, -- mdformat doesn't play nice with e.g., pandoc markdown
  },
})
