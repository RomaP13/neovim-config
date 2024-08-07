return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    local config = require("catppuccin")
    config.setup({
      transparent_background = true,
    })
    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
