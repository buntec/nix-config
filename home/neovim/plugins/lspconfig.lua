local lsp_config = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

lsp_config.util.default_config =
  vim.tbl_extend("force", lsp_config.util.default_config, { capabilities = capabilities })

-- lsp_config.metals.setup {} -- NOTE: scala metals is managed by nvim-metals
lsp_config.bashls.setup({})
lsp_config.clangd.setup({})

-- lsp_config.cmake.setup({})
lsp_config.neocmake.setup({})

lsp_config.gopls.setup({})
lsp_config.hls.setup({})
lsp_config.html.setup({})
lsp_config.pyright.setup({})
lsp_config.smithy_ls.setup({})
lsp_config.taplo.setup({})
lsp_config.ts_ls.setup({})

lsp_config.nil_ls.setup({
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

lsp_config.lua_ls.setup({
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

lsp_config.texlab.setup({
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
