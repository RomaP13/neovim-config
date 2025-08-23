local function show_codeium_status()
  if vim.fn["codeium#GetStatusString"]() == "OFF" then
    return "󱚧"
  end
  return "󰚩"
end

local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  else
    return "Recording @" .. reg
  end
end

return {
  "nvim-lualine/lualine.nvim",

  init = function()
    -- Remove searchcount from command line
    vim.opt.shortmess:append("S")
    -- Remove "recording @a" when recording a macro from command line
    vim.opt.shortmess:append("q")
    -- Remove the display of the partially typed commands from command line
    vim.opt.showcmd = false
  end,

  opts = {
    options = {
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "diff" },

        -- Buffer diagnostics
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
        },
      },
      lualine_c = { "filename" },
      lualine_x = { show_codeium_status, "encoding", "fileformat", "filetype" },
      lualine_y = {
        {
          "diagnostics",
          sources = { "nvim_workspace_diagnostic" },
        },
        { "selectioncount" },
        { "searchcount" },
        { "progress" },
      },
      lualine_z = { macro_recording, "location" },
    },
  },
}
