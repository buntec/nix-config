require("conform").setup({
  formatters_by_ft = {
    --markdown = { "mdformat" }, -- mdformat doesn't play nice with e.g., pandoc markdown
    css = { { "prettierd", "prettier" }, "stylelint" },
    cpp = { "clang_format" },
    html = { { "prettierd", "prettier" } },
    javascript = { { "prettierd", "prettier" } },
    json = { "jq" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
    typescript = { { "prettierd", "prettier" } },
    yaml = { "yamlfmt" },
  },
})
