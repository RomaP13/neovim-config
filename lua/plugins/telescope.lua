return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      local map = vim.keymap.set

      local config = require("telescope")
      local builtin = require("telescope.builtin")

      config.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- load extensions
      local extensions_list = {
        "ui-select",
        "undo",
        "live_grep_args",
      }
      for _, ext in ipairs(extensions_list) do
        config.load_extension(ext)
      end

      map("n", "<leader>ff", builtin.find_files, {})
      map("n", "<leader>fg", builtin.live_grep, {})
      map("n", "<leader>fb", builtin.buffers, {})
      map("n", "<leader>fh", builtin.help_tags, {})
      map("n", "<leader>fw", builtin.grep_string, {})
      map("n", "<leader>fr", builtin.resume, {})
      map("n", "<leader>gt", builtin.git_status, {})
      map("n", "<leader>gc", builtin.git_commits, {})

      map("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "Undo history" })
      map("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
    end,
  },
}
