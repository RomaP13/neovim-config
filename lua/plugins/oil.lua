return {
  "stevearc/oil.nvim",

  opts = {},

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,

  config = function()
    local detail = false
    require("oil").setup({
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      watch_for_changes = true,
      keymaps = {
        ["gd"] = {
          -- TODO: Find a way to show a better detail view, cause it's really ugly
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, _)
          local allowed_files = { ".gitignore", ".dockerignore", ".env", ".config" }
          for _, allowed in ipairs(allowed_files) do
            if name == allowed then
              return false -- Don't hide this file
            end
          end

          -- Default behavior: hide files starting with "."
          return name:match("^%.") ~= nil
        end,
      },
      git = {},
    })
    local map = vim.keymap.set
    map("n", "-", ":Oil --float<CR>", { desc = "Open parent directory" })
  end,
}
