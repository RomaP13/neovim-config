return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      local map = vim.keymap.set

      local config = require("telescope")
      local builtin = require("telescope.builtin")
      local action_state = require("telescope.actions.state")

      config.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        pickers = {
          colorscheme = {
            enable_preview = true
          }
        }
      })

      -- load extensions
      local extensions_list = {
        "ui-select",
        "live_grep_args",
      }
      for _, ext in ipairs(extensions_list) do
        config.load_extension(ext)
      end

      map("n", "<leader>ff", builtin.find_files, { silent = true })
      map("n", "<leader>fg", builtin.live_grep, { silent = true })
      map("n", "<leader>fh", builtin.help_tags, { silent = true })
      map("n", "<leader>fw", builtin.grep_string, { silent = true })
      map("n", "<leader>fr", builtin.resume, { silent = true })
      map("n", "<leader>gt", builtin.git_status, { silent = true })
      map("n", "<leader>gc", builtin.git_commits, { silent = true })

      map("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true })

      -- Open buffers with Telescope. Press Ctrl-r to delete buffer from the list
      map("n", "<leader>fb", function()
        builtin.buffers({
          initial_mode = "insert",
          attach_mappings = function(prompt_bufnr, mapp)
            local delete_buf = function()
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              current_picker:delete_selection(function(selection)
                vim.api.nvim_buf_delete(selection.bufnr, { force = true })
              end)
            end

            mapp("i", "<C-r>", delete_buf)

            return true
          end
        }, {
          sort_lastused = true,
          sort_mru = true,
          theme = "dropdown"
        })
      end, { silent = true })
    end,
  },
}
