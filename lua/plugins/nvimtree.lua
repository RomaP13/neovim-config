return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local config = require("nvim-tree")
    config.setup({
      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", {}),
      vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeFocus<CR>", {}),

      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
      git = {
        ignore = false,
      },
    })
  end,
}
