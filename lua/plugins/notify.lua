return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local config = require("noice")
    config.setup({})
  end
}
