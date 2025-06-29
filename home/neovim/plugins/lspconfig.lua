local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("hls")
vim.lsp.enable("html")
vim.lsp.enable("lua_ls")
vim.lsp.enable("neocmake")
vim.lsp.enable("nil_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("taplo")
vim.lsp.enable("texlab")
vim.lsp.enable("ts_ls")

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      format = {
        enable = false, -- we prefer stylua via conform
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config("texlab", {
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forwardSearchAfter = false,
        onSave = true,
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true,
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        args = {},
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = true,
      },
    },
  },
})
