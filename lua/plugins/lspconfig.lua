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
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")
      local map = vim.keymap.set

      -- Define a border style
      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" }
      }

      -- Override the default hover handler
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      vim.diagnostic.config {
        float = { border = "rounded" }
      }

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
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
      -- map("i", "<C-s>", vim.lsp.buf.signature_help, { buffer = true })
    end,
  },
}
