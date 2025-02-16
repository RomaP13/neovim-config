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
      local action_state = require("telescope.actions.state")
      local builtin = require("telescope.builtin")

      config.setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
        },
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
      map("n", "<leader>gc", builtin.git_commits, { silent = true })

      map(
        "n",
        "<leader>nt",
        ":lua require('telescope').extensions.notify.notify()<CR>",
        { silent = true, desc = "Open Messages in Telescope" }
      )
      map(
        "n",
        "<leader>fg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { silent = true }
      )

      -- TODO: find a way to make this work
      -- map("n", "<leader>fg", function() config.extensions.live_grep_args.live_grep_args({vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "YOUR_ARGUMENT" }}) end)

      -- TODO: define this function somewhere else???
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
          end,
        }, {
          sort_lastused = true,
          sort_mru = true,
          theme = "dropdown",
        })
      end, { silent = true })

      -- TODO: remove global variable and make it local. Think about a better way to do this
      -- Function to jump to the current file in git_status
      _G.git_status_jump_to_current = function(opts)
        opts = opts or {}
        local buf_path = vim.api.nvim_buf_get_name(0)

        opts.on_complete = {
          function(self)
            local selection_idx
            for i, entry in ipairs(self.finder.results) do
              if buf_path == entry.path then
                selection_idx = i
                break
              end
            end
            self:set_selection(self:get_row(selection_idx))
          end,
        }

        require("telescope.builtin").git_status(opts)
      end

      -- Corrected keymap
      vim.api.nvim_set_keymap(
        "n",
        "<leader>gs",
        ":lua git_status_jump_to_current()<CR>",
        { noremap = true, silent = true }
      )
    end,
  },
}
