return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")

    notify.setup({})
    vim.notify = notify

    local map = vim.keymap.set
    map("n", "<leader>nd", notify.dismiss, { silent = true })
  end,
}
