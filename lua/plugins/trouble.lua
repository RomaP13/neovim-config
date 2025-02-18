return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    {
      "<leader>aa",
      ":Trouble diagnostics toggle<CR>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>ab",
      ":Trouble diagnostics toggle filter.buf=0<CR>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      ":Trouble symbols toggle focus=false<CR>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader><CR>",
      ":Trouble lsp toggle focus=false win.position=right<CR>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>td",
      "<:Trouble todo<CR>",
      desc = "TODOs (Trouble)",
    },
  },
}
