return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local config = require("lualine")
    config.setup({
      options = {
        theme = "catppuccin",
      },
      -- TODO: find a way to fix this or just replace it with another statusline plugin
      -- This secion fixes macros issue, but this causing missing borders for signature help
      -- sections = {
      --   lualine_x = {
      --     {
      --       require("noice").api.statusline.mode.get,
      --       cond = require("noice").api.statusline.mode.has,
      --       color = { fg = "#ff9e64" },
      --     }
      --   },
      -- },
    })
  end,
}
