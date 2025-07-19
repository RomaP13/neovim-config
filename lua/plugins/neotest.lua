return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    -- "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python"
  },
  keys = {
    { "<leader>nt", ":lua require('neotest').run.run()<CR>", desc = "Run nearest test", silent = true },
    { "<leader>nf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", desc = "Run tests in current file", silent = true },
  },
  config = function()
    local config = require("neotest")
    config.setup({
      adapters = {
        require("neotest-python")
      },
    })
  end
}
