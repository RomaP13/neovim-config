local map = vim.keymap.set

return {
  {
    "williamboman/mason.nvim",
    config = function()
      local mason = require("mason")
      mason.setup({
        ui = {
          border = "rounded",
        },
      })
      map("n", "<leader>im", ":Mason<CR>", { silent = true })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({})
    end,
  },
  {
    -- TODO: add blink.cmp as a dependency.
    -- I think I should care about it. It can lead to some problems. Also, check other plugins for the same problem.
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      -- Define a border style
      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- Override the default hover handler
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.custom_open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- Assign the custom function
      vim.lsp.util.open_floating_preview = vim.lsp.util.custom_open_floating_preview

      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = true,
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath("config")
                and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        filetypes = { "python" },
        settings = {
          pyright = {
            disableOrganizeimports = true,
            disableFormatting = true,
          },
          python = {
            -- FIX: fix poetry support
            pythonPath = ".venv/bin/python" .. "/bin/python",
            analysis = {
              diagnosticMode = "workspace",
            },
          },
        },
        on_init = function(client)
          print("Pyright LSP initialized for client ID: " .. client.id)
        end,
      })

      -- FIX: Fix duplicate pyright clients (TEMPORARY FIX)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("prevent_duplicate_pyright", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "pyright" then
            if client.config.settings.python.analysis.diagnosticMode ~= "workspace" then
              vim.lsp.stop_client(client.id)
              print("Stopped duplicate pyright client ID: " .. client.id)
            end
          end
        end,
        desc = "Prevent duplicate pyright LSP clients",
      })

      lspconfig.html.setup({
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      })

      -- TODO: Remove???
      -- Disable Ruff's hover in favor of Pyright
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end,
        desc = "LSP: Disable hover capability from Ruff",
      })

      map("n", "K", vim.lsp.buf.hover, {})
      map("n", "gd", vim.lsp.buf.definition, {})
      map("n", "gr", vim.lsp.buf.references, {})
      map("n", "gi", vim.lsp.buf.implementation, {})
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      map("n", "<leader>rn", vim.lsp.buf.rename, {})
      map("n", "<leader>fm", vim.lsp.buf.format, {})

      -- Diagnostic
      map("n", "<leader>of", vim.diagnostic.open_float, {})
      map("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Go to previous [D]iagnostic message" })
      map("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Go to next [D]iagnostic message" })
    end,
  },
}
