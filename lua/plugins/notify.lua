return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  tag = "v3.12.0",
  config = function()
    local config = require("noice")
    config.setup({})
  end
}
