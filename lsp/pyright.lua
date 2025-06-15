return {
  cmd = {
    vim.fn.expand("~/.local/share/nvim/mason/bin/pyright-langserver"),
    "--stdio",
  },
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
}
