return {
  "sindrets/diffview.nvim",
  config = function()
    local config = require("diffview")
    local map = vim.keymap.set

    map("n", "<leader>dff", ":DiffviewFileHistory %<CR>", { silent = true })
    map("n", "<leader>dfx", ":DiffviewClose<CR>", { silent = true })
  end,
}
