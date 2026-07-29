local lsp_cmd = require("utils.lsp_cmd")

local cmd = lsp_cmd.find_cmd("basedpyright", "basedpyright-langserver", { "--stdio" })
if not cmd then
  return {}
end

--- BasedPyright language server configuration
---@type vim.lsp.Config
local config = {
  cmd = cmd,
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

      analysis = {
        diagnosticMode = "workspace",

        inlayHints = {
          genericTypes = true,
        },

        -- These options can also be configured in config.
        -- It's recommended to override them in project.
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

        typeCheckingMode = "basic", -- It's recommended to use "strict"
      },
    },
  },
}

return config
