local is_file_detail_view = false

return {
  "stevearc/oil.nvim",

  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  ---@module "oil"
  ---@type oil.setupOpts
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    watch_for_changes = true,

    keymaps = {
      ["gd"] = {
        callback = function()
          local oil = require("oil")
          is_file_detail_view = not is_file_detail_view
          oil.set_columns(is_file_detail_view and { "icon", "permissions", "size", "mtime" } or { "icon" })
        end,
        mode = "n",
        desc = "Toggle file detail view",
      },
      ["gf"] = {
        callback = function()
          require("fzf-lua").files({
            cwd = require("oil").get_current_dir(),
          })
        end,
        mode = "n",
        desc = "Find files in the current directory",
      },
    },

    view_options = {
      show_hidden = false,
      is_hidden_file = function(name, _)
        local visible_hidden_files = {
          [".gitignore"] = true,
          [".dockerignore"] = true,
          [".env"] = true,
          [".env.example"] = true,
          [".prettierrc"] = true,
          [".config"] = true,
          [".local"] = true,
          [".bashrc"] = true,
          [".zshrc"] = true,
        }
        if visible_hidden_files[name] ~= nil then
          return false -- Don't hide this file
        end

        -- Default behavior: hide files starting with "."
        return name:match("^%.") ~= nil
      end,
    },
  },

  keys = {
    {
      "-",
      "<cmd>Oil<CR>",
      desc = "Oil: Open parent directory",
    },
    {
      "_",
      "<cmd>Oil --float<CR>",
      desc = "Oil: Open parent directory in a floating window",
    },
  },
}
