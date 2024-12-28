require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    cpp = { "clang_format" },
    css = { "prettierd", "stylelint" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    python = { "ruff_format", "ruff_fix" },
    typescript = { "prettierd" },
    yaml = { "yamlfmt" },
  },
})
