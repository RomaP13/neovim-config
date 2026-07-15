return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Trouble",

  ---@module "trouble"
  ---@type trouble.Config
  opts = {},

  keys = {
    {
      "<leader>aa",
      "<cmd>Trouble diagnostics toggle<CR>",
      desc = "Trouble: Diagnostics",
    },
    {
      "<leader>ab",
      "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Trouble: Buffer Diagnostics",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<CR>",
      desc = "Trouble: Symbols",
    },
    {
      "<leader><CR>",
      "<cmd>Trouble lsp toggle focus=false win.position=bottom<CR>",
      desc = "Trouble: LSP Definitions / references / ...",
    },
    {
      "<leader>td",
      "<cmd>Trouble todo toggle focus=true<CR>",
      desc = "Trouble: TODOs",
    },
  },
}
