return {
  "j-hui/fidget.nvim",
  opts = {
    -- Options related to notification subsystem
    notification = {
      override_vim_notify = true, -- Automatically override vim.notify() with Fidget

      -- Options related to the notification window and buffer
      window = {
        normal_hl = "Comment", -- Base highlight group in the notification window
        winblend = 0, -- Background color opacity in the notification window
        border = "rounded", -- Border around the notification window
        align = "top", -- How to align the notification window
      },
    },
  },
}
