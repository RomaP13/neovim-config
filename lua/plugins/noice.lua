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
      presets = {
        long_message_to_split = true,
        lsp_doc_border = true,  -- Ensures borders for hover and signature help
      },
      lsp = {
        signature = {
          enabled = false,
          auto_open = {
            enabled = false,
            trigger = false, -- Automatically show signature help when typing a trigger character
            luasnip = false, -- Enable with luasnip
          },
        },
        hover = {
          enabled = false,
        }
      },
    })

    local map = vim.keymap.set

    -- Dismiss Noice Messages
    map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Messages" })
  end
}
