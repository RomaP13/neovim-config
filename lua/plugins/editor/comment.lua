return {
  "numToStr/Comment.nvim",
  lazy = false,
  config = function()
    local comment = require("Comment")
    comment.setup({
      -- ignores empty lines
      ignore = "^$",
      toggler = {
        -- Line-comment toggle keymap in NORMAL mode
        line = "<leader>/",
      },
      opleader = {
        -- Line-comment toggle keymap in VISUAL mode
        line = "<leader>/",
      }
    })
  end
}
