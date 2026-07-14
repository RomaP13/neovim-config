return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    styles = {
      comments = { italic = true },
      keywords = { bold = true },
      floats = "transparent",
    },
    on_highlights = function(hl)
      hl.TroubleNormal = { bg = "None" }
      hl.RenderMarkdownCode = { bg = "NONE" }
    end,
  },
}
