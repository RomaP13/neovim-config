return {
  {
    "williamboman/mason.nvim",
    config = function()
      local config = require("mason")
      config.setup({})
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
      local map = vim.keymap.set

      local _border = "rounded"

      -- Add the border on hover and on signature help popup window
      local handlers = {
          ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = _border }),
          ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = _border }),
      }

      vim.diagnostic.config{
        float={ border=_border }
      }

      -- vim.api.nvim_create_autocmd("CursorHoldI", {
      --   pattern = "*",
      --   callback = function()
      --     vim.lsp.buf.signature_help()
      --   end,
      -- })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        handlers = handlers,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
      -- lspconfig.pylsp.setup({
      --   settings = {
      --     pylsp = {
      --       plugins = {
      --         -- formatter options
      --         black = { enabled = true },
      --         autopep8 = { enabled = false },
      --         yapf = { enabled = false },
      --         -- linter options
      --         pylint = { enabled = true, executable = "pylint" },
      --         pyflakes = { enabled = false },
      --         pycodestyle = { enabled = false },
      --         -- type checker
      --         pylsp_mypy = { enabled = true },
      --         -- auto-completion options
      --         jedi_completion = { fuzzy = true },
      --         -- import sorting
      --         pyls_isort = { enabled = true },
      --       },
      --     },
      --   },
      --   capabilities = capabilities,
      -- })
      -- lspconfig.bashls.setup({
      --   capabilities = capabilities,
      -- })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        handlers = handlers,
        filetypes = { "python" },
        settings = {
          python = {
            pythonPath = vim.fn.systemlist("poetry env info --path")[1] .. "/bin/python",
          }
        }
      })
      lspconfig.ruff.setup({
        capabilities = capabilities,
        filetypes = { "python" },
      })

      map("n", "K", vim.lsp.buf.hover, {})
      map("n", "gd", vim.lsp.buf.definition, {})
      map("n", "gr", vim.lsp.buf.references, {})
      map("n", "gi", vim.lsp.buf.implementation, {})
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      map("n", "<leader>rn", vim.lsp.buf.rename, {})
      map("n", "<leader>fm", vim.lsp.buf.format, {})
      map("n", "<leader>of", vim.diagnostic.open_float, {})
      map("n", "[d", vim.diagnostic.goto_prev, {})
      map("n", "]d", vim.diagnostic.goto_next, {})
      map("i", "<C-b>", vim.lsp.buf.signature_help, {buffer=true})
    end,
  },
}
