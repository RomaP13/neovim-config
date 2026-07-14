return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },

  ---@module "harpoon"
  ---@type HarpoonConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {},

  keys = {
    {
      "<M-w>",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon: Toggle quick menu",
    },
    {
      "<M-e>",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon: Add file to the list",
    },
    {
      "<M-,>",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon: Select file 1",
    },
    {
      "<M-.>",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon: Select file 2",
    },
    {
      "<M-;>",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon: Select file 3",
    },
    {
      "<M-'>",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon: Select file 4",
    },
  },
}
