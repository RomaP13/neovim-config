local lsp_cmd = require("utils.lsp_cmd")

--- Pyright language server configuration
---@type vim.lsp.Config
local config = {
  cmd = lsp_cmd.find_cmd("pyright", "pyright-langserver", { "--stdio" }),
  filetypes = {
    "python",
  },
  root_markers = {
    ".git",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
  },
  settings = {
    pyright = {
      disableOrganizeimports = true,
      disableFormatting = true,
    },
    python = {
      analysis = {
        diagnosticMode = "workspace",
      },
    },
  },
  on_attach = function()
    -- Format and organize imports on save with Ruff
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("RuffFormat", { clear = true }),
      pattern = "*.py",
      callback = function()
        vim.cmd("RuffFormat")
      end,
    })
  end,
}

return config
