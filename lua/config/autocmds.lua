local fn = vim.fn
local text_utils = require("utils.text_utils")

vim.api.nvim_create_augroup("bufcheck", { clear = true })

-- Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = "bufcheck",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = "bufcheck",
  pattern = "*",
  callback = function()
    if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
      fn.setpos(".", fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end,
})

local function should_copy_jendo()
  return vim.b.copy_jendo ~= false
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = "bufcheck",
  pattern = "Jendo.txt",
  callback = function()
    if should_copy_jendo() then
      local lines = text_utils.get_visual_selection()

      if not lines or #lines == 0 then
        vim.notify("No text selected.")
        return
      end

      local eng_text = {}
      local rus_text = {}
      local processed_lines = {}
      local is_english = false

      for _, line in ipairs(lines) do
        -- Strip leading and trailing whitespace like Python's strip()
        line = string.gsub(line, "^%s*(.-)%s*$", "%1")
        if line ~= "" then
          if is_english then
            table.insert(eng_text, line)
          else
            table.insert(rus_text, line)
          end
          is_english = not is_english
        end
      end

      -- Combine rus_text and eng_text with separator
      for _, line in ipairs(eng_text) do
        table.insert(processed_lines, line)
      end
      table.insert(processed_lines, "---")
      for _, line in ipairs(rus_text) do
        table.insert(processed_lines, line)
      end

      vim.fn.setreg("+", table.concat(processed_lines, "\n\n"))

      vim.notify("Text from novel Jendo copied to clipboard.")
    end
  end,
})

vim.api.nvim_create_user_command("ToggleCopyJendo", function()
  vim.b.copy_jendo = not vim.b.copy_jendo
  vim.notify("Copy Jendo:", vim.b.copy_jendo)
end, {})

-- Set default value
vim.api.nvim_create_autocmd("BufEnter", {
  group = "bufcheck",
  pattern = "Jendo.txt",
  callback = function()
    if vim.b.copy_jendo == nil then
      vim.b.copy_jendo = true
    end
  end,
})
