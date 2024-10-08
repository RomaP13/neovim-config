return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local config = require("lualine")
    config.setup({
      options = {
        theme = "catppuccin",
      },
      sections = {
        lualine_x = {
          {
            require("noice").api.statusline.mode.get,
            cond = require("noice").api.statusline.mode.has,
            color = { fg = "#ff9e64" },
          }
        },
      },
    })
  end,
}
