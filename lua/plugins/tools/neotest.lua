return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
  },

  opts = function()
    ---@module "neotest"
    ---@type neotest.Config
    ---@diagnostic disable-next-line: missing-fields
    local opts = {
      adapters = {
        require("neotest-python")({
          runner = "pytest",
        }),
      },
    }

    return opts
  end,

  keys = {
    {
      "<leader>nt",
      function()
        require("neotest").run.run()
      end,
      desc = "Neotest: Run the nearest test",
    },
    {
      "<leader>nf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Neotest: Run all tests in the current file",
    },
  },
}
