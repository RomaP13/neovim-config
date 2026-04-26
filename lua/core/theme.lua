local M = {}

local THEME_FILE = vim.fn.stdpath("data") .. "/colorscheme"

--- Sets, saves, and applies the global colorscheme and Lualine theme.
--- Intended to be used as an fzf-lua action.
---@param selected table A table (from fzf-lua) where `selected[1]` is the colorscheme name string.
function M.set_global_colorscheme(selected)
  local colorscheme_name = selected[1]

  if not colorscheme_name then
    vim.notify("Error: No colorscheme selected.", vim.log.levels.ERROR)
    return
  end

  vim.cmd.colorscheme(colorscheme_name)
  pcall(function()
    require("lualine").setup({ options = { theme = colorscheme_name } })
  end)

  local file = io.open(THEME_FILE, "w")
  if file then
    file:write(colorscheme_name)
    file:close()
  end

  vim.notify("Colorscheme set to " .. colorscheme_name, vim.log.levels.INFO)
end

--- Loads and applies the colorscheme saved in the THEME_FILE.
--- Intended to be run on startup.
function M.load_saved_colorscheme()
  local file = io.open(THEME_FILE, "r")
  if file then
    local colorscheme_name = file:read("*l")
    file:close()

    if colorscheme_name and colorscheme_name ~= "" then
      -- Apply theme only if one was saved
      vim.cmd.colorscheme(colorscheme_name)
      pcall(function()
        require("lualine").setup({ options = { theme = colorscheme_name } })
      end)
    end
  end
end

return M
