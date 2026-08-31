return {
  "ThePrimeagen/refactoring.nvim",
  lazy = false,
  dependencies = {
    "lewis6991/async.nvim",
  },

  ---@module "refactoring"
  ---@type refactor.refactor.UserConfig
  opts = {},

  keys = {
    {
      "<leader>rs",
      function()
        require("refactoring").select_refactor()
      end,
      mode = { "n", "x" },
      desc = "Refactoring: Select refactor",
    },

    {
      "<leader>rv",
      function()
        return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
      end,
      mode = "n",
      expr = true,
      desc = "Refactoring: Debug print variable",
    },
    {
      "<leader>rv",
      function()
        return require("refactoring.debug").print_var({ output_location = "below" })
      end,
      mode = "x",
      expr = true,
      desc = "Refactoring: Debug print variable",
    },

    {
      "<leader>re",
      function()
        return require("refactoring.debug").print_exp({ output_location = "below" }) .. "_"
      end,
      mode = "n",
      expr = true,
      desc = "Refactoring: Debug print expression",
    },
    {
      "<leader>re",
      function()
        return require("refactoring.debug").print_exp({ output_location = "below" })
      end,
      mode = "x",
      expr = true,
      desc = "Refactoring: Debug print expression",
    },

    {
      "<leader>rl",
      function()
        return require("refactoring.debug").print_loc({ output_location = "below" })
      end,
      mode = "n",
      expr = true,
      desc = "Refactoring: Debug print location",
    },

    {
      "<leader>rc",
      function()
        return require("refactoring.debug").cleanup({ restore_view = true })
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "Refactoring: Debug print clean",
    },
  },
}
