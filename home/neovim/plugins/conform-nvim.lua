require("conform").setup({
  default_format_opts = {
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    cmake = { "gersemi" },
    cpp = { "clang_format" },
    css = { "prettierd", "stylelint" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    json = { "jq" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    python = { "ruff_format", "ruff_organize_imports" },
    typescript = { "prettierd" },
    yaml = { "yamlfmt" },
    xml = { "xmllint" },
  },
})
