-- TODO: Improve readbility of this file, I'm confused
-- TODO: Find a way so that telescope window can move like Ctrl-E

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      local map = vim.keymap.set

      local config = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      config.setup({
        defaults = {
          layout_config = {
            height = 0.9,
            width = 0.9,
            prompt_position = "top",
          },
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,

              -- Quit from insert mode
              ["<C-c>"] = actions.close,

              -- Delete buffer
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,

              -- Scroll the preview window
              ["<C-j>"] = actions.preview_scrolling_down,
              ["<C-k>"] = actions.preview_scrolling_up,
              ["<C-h>"] = actions.preview_scrolling_left,
              ["<C-l>"] = actions.preview_scrolling_right,
            },
            n = {
              -- Scroll the preview window
              ["<C-j>"] = actions.preview_scrolling_down,
              ["<C-k>"] = actions.preview_scrolling_up,
              ["<C-h>"] = actions.preview_scrolling_left,
              ["<C-l>"] = actions.preview_scrolling_right,
            },
          },
        },
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
        -- "live_grep_args",
      }
      for _, ext in ipairs(extensions_list) do
        config.load_extension(ext)
      end

      local function get_priority_files()
        local path = vim.fn.expand("~/.config/nvim/rg_priority.txt") -- File with prioritized paths
        local files = {}

        -- Read the file line by line
        for line in io.lines(path) do
          table.insert(files, line)
        end

        return files
      end

      -- File Pickers
      map("n", "<leader>ff", function()
        builtin.find_files({
          hidden = true,
          no_ignore = true,
          file_ignore_patterns = { ".venv/", ".git/", ".ruff_cache/", "__pycache__/", ".pytest_cache/" },
        })
      end, { silent = true })
      map("n", "<leader>gf", function()
        builtin.git_files({ show_untracked = true })
      end)
      map("n", "<leader>fw", builtin.grep_string, { silent = true })
      map("n", "<leader>fg", builtin.live_grep, { silent = true })

      -- Vim Pickers
      map("n", "<leader>fb", builtin.buffers, { silent = true })
      map("n", "<leader>fo", builtin.oldfiles, { silent = true })
      map("n", "<leader>ch", builtin.command_history, { silent = true })
      map("n", "<leader>fh", builtin.help_tags, { silent = true })
      map("n", "<leader>vm", builtin.marks, { silent = true })
      map("n", "<leader>fr", builtin.resume, { silent = true })

      -- Git Pickers
      map("n", "<leader>gc", builtin.git_commits, { silent = true })
      map("n", "<leader>gb", builtin.git_bcommits, { silent = true })
      -- TODO: Add git status

      -- Custom Pickers
      -- ...

      map(
        "n",
        "<leader>fg",
        ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
        { silent = true }
      )
      map("n", "<leader>fi", function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          search_dirs = get_priority_files(),
          additional_args = { "--sort", "path" },
        })
      end, { silent = true })

      -- Custom function to search for phrases
      _G.search_phrase = function()
        local input = vim.fn.input("Enter the phrase: ")

        if input ~= "" then
          -- Replace spaces between words with the regex pattern \s+\w*\s*
          local query = input:gsub(" ", "\\s+\\w*\\s*")
          -- Enclose the entire query in double quotes
          query = '"' .. query .. '"'

          -- Perform the search using live_grep_args with the -U flag
          config.extensions.live_grep_args.live_grep_args({
            search_dirs = get_priority_files(),
            additional_args = { "--sort", "path" },
            default_text = query .. " -U",
          })
        else
          print("No phrases entered.")
        end
      end

      vim.api.nvim_set_keymap("n", "<leader>fv", ":lua search_phrase()<CR>", { noremap = true, silent = true })

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

      config.load_extension("live_grep_args")
    end,
  },
}
