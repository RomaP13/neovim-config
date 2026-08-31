return {
  -- marekh19/meowsoot.nvim
  -- https://github.com/WTFox/luna.nvim
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,

  ---@module "gruvbox"
  ---@type GruvboxConfig
  opts = {
    overrides = {
      Pmenu = { bg = "none" },
    },
    transparent_mode = true,
  },
}
