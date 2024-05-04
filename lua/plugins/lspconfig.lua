return {
  {
    "williamboman/mason.nvim",
    config = function()
      local config = require("mason")
      config.setup({})
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local config = require("mason-tool-installer")
      config.setup({
        ensure_installed = {
          -- lua stuff
          "lua_ls",
          "stylua",

          -- c stuff
          "clangd",
          "clang-format",
          "codelldb",

          -- python stuff
          "python-lsp-server",
          "mypy",
          "isort",
          "black",
          "debugpy",
          "bashls",
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local config = require("mason-lspconfig")
      config.setup({})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      lspconfig.pylsp.setup({
        capabilities = capabilities,
      })
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
