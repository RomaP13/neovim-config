return {
  "stevearc/oil.nvim",

  opts = {},

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,

  config = function()
    require("oil").setup({
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
    })
    local map = vim.keymap.set
    map("n", "-", ":Oil<CR>", { desc = "Open parent directory" })
  end,
}
