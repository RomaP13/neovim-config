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
      },
      lsp = {
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 100,
          },
          view = "hover",  -- Ensure it uses hover view with borders
        },
        hover = {
          enabled = true,  -- Enable Noice's hover UI
        },
      },
      presets = {
        lsp_doc_border = true,  -- Ensures borders for hover and signature help
      },
    })

    local map = vim.keymap.set

    -- Dismiss Noice Messages
    map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Messages" })

    -- Open Noice Messages in Telescope
    -- map("n", "<leader>nt", "<cmd>NoiceTelescope<CR>", { desc = "Open Noice Messages in Telescope" })
  end
}
