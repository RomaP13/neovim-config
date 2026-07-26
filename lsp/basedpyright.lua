local lsp_cmd = require("utils.lsp_cmd")

--- BasedPyright language server configuration
---@type vim.lsp.Config
local config = {
  cmd = lsp_cmd.find_cmd("basedpyright", "basedpyright-langserver", { "--stdio" }),
  filetypes = {
    "python",
  },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      disableOrganizeimports = true,
      disableFormatting = true,

      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",

        diagnosticSeverityOverrides = {
          reportUnusedImport = "none",
          reportUnusedExpression = "none",
        },

        exclude = {
          "**/__pycache__",
          "**/.venv",
          "**/venv",
          "**/.mypy_cache",
          "**/.pytest_cache",
          "**/dist",
          "**/build",
          "**/node_modules",
        },
      },
    },
  },
}

return config
