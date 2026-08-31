return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",

  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      --[[ highlight = {
        "DiagnosticError",
        "DiagnosticWarn",
        "DiagnosticOk",
        "DiagnosticInfo",
        "DiagnosticHint",
      }, ]]
    },
    scope = {
      enabled = false,
    },
  },
}
