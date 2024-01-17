require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
    javascript = { "prettier" },
    --markdown = { "mdformat" }, -- mdformat doesn't play nice with e.g., pandoc markdown
  },
})
