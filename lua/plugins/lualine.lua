return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local config = require("lualine")

    local function show_codeium_status()
      return "AI: " .. vim.fn["codeium#GetStatusString"]()
    end

    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      else
        return "Recording @" .. reg
      end
    end

    config.setup({
      options = {
        theme = "catppuccin",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { show_codeium_status, "encoding", "fileformat", "filetype" },
        lualine_y = { "selectioncount", "searchcount", "progress" },
        lualine_z = { macro_recording, "location" },
      },
    })

    -- Remove searchcount from command line
    vim.opt.shortmess:append("S")
    -- Remove "recording @a" when recording a macro from command line
    vim.opt.shortmess:append("q")
    -- Remove the display of the partially typed commands from command line
    vim.opt.showcmd = false
  end,
}
