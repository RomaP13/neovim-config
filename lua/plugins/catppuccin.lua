return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    local config = require("catppuccin")
    config.setup({
      flavour = "macchiato",
      transparent_background = true,

      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.rosewater },
          CursorLineNr = { fg = colors.green },
          Comment = { fg = "#808A9F" },
        }
      end,

      integrations = {
        gitsigns = true,
        dap = true,
        dap_ui = true,
        nvimtree = true,
        noice = true,
        notify = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
      }

    })

    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
