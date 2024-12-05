return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    local config = require("noice")
    config.setup({
      cmdline = {
        format = {
          filter = false,
          lua = false,
          help = false
        }
      }
    })

    local map = vim.keymap.set

    -- Dismiss Noice Messages
    map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Messages" })

    -- Open Noice Messages in Telescope
    -- map("n", "<leader>nt", "<cmd>NoiceTelescope<CR>", { desc = "Open Noice Messages in Telescope" })
  end
}
