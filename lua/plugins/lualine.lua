return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local config = require("lualine")
    config.setup({
      options = {
        theme = "catppuccin",
      },
    })
  end,
}
