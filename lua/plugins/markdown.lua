return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    overrides = {
      buftype = {
        nofile = {
          render_modes = false, -- Disable all rendering in nofile buffers (LSP hovers)
          padding = { highlight = "NormalFloat" }, -- Fallback to transparent float if needed
          sign = { enabled = false }, -- Disable signs in hovers
        },
      },
    },
  },
}
