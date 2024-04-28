require("conform").setup({
  formatters_by_ft = {
    cpp = { "clang_format" },
    css = { { "prettierd", "prettier" }, "stylelint" },
    html = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { { "prettierd", "prettier" } },
    python = { "ruff_format", "ruff_fix" },
    typescript = { { "prettierd", "prettier" } },
    yaml = { "yamlfmt" },
  },
})
