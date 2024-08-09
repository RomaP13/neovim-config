return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup()

    local map = vim.keymap.set
    map("n", "<leader>hp", gitsigns.preview_hunk, {})
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, {})
  end
}
