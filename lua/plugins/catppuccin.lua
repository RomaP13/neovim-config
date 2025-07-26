return {
  "catppuccin/nvim",
  lazy = false,
  name = "catppuccin",
  priority = 1000,
  config = function()
    local config = require("catppuccin")
    config.setup({
      flavour = "macchiato",
      transparent_background = true,

      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.rosewater },
          CursorLineNr = { fg = colors.green },
          Comment = { fg = "#808A9F" },

          -- Custom highlights for blink-cmp borders
          BlinkCmpMenuBorder = { fg = colors.blue },          -- Completion menu border
          BlinkCmpDocBorder = { fg = colors.blue },           -- Documentation border
          BlinkCmpSignatureHelpBorder = { fg = colors.blue }, -- Signature help border

          -- Custom highlights for diffview
          DiffAdd = { bg = "#A6DA95", fg = "#0E2239" },
          DiffDelete = { bg = "#ED8796", fg = "#000000" },
          DiffChange = { bg = "#EED49F", fg = "#000000" },
          DiffText = { bg = "#B9C0F8", fg = "#0E0953" },
        }
      end,

      integrations = {
        blink_cmp = true,
        diffview = true,
        fidget = true,
        fzf = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        dap = true,
        dap_ui = true,
        treesitter = true,
        ufo = true,
        telescope = {
          enabled = true,
        },
        lsp_trouble = true,
      },
    })

    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
