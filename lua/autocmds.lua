local fn = vim.fn
local text_utils = require("utils.text_utils")

vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_augroup("LspFormatting", {})

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

-- Define a function to check if formatting should run
local function should_format()
  -- Explicitly disable formatting if set
  if vim.b.format_on_save == false then
    return false
  end

  -- Always format Python with Ruff
  if vim.bo.filetype == "python" then
    return true
  end

  -- Check if any attached LSP client supports formatting
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting") then
      return true
    end
  end

  return false
end

-- Python: Format code and organize imports on save using Ruff
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  pattern = "*.py",
  callback = function()
    if should_format() then
      vim.cmd("RuffFormat")
    end
  end,
})

-- Other languages: Format only if the LSP client supports it
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  pattern = "*",
  callback = function()
    if should_format() then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- Add commands to toggle formatting
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.b.format_on_save = not vim.b.format_on_save
  print("Format on save:", vim.b.format_on_save)
end, {})

-- Set default value
vim.api.nvim_create_autocmd("BufEnter", {
  group = "bufcheck",
  pattern = "*",
  callback = function()
    if vim.b.format_on_save == nil then
      vim.b.format_on_save = true
    end
  end,
})

local function should_copy_jendo()
  return vim.b.copy_jendo ~= false
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = "LspFormatting",
  pattern = "Jendo.txt",
  callback = function()
    if should_copy_jendo() then
      local lines = text_utils.get_visual_selection()

      local eng_text = {}
      local rus_text = {}
      local processed_lines = {}

      local is_english = false

      for i, line in ipairs(lines) do
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

      print("Text from novel Jendo copied to clipboard.")
    end
  end,
})

vim.api.nvim_create_user_command("ToggleCopyJendo", function()
  vim.b.copy_jendo = not vim.b.copy_jendo
  print("Copy Jendo:", vim.b.copy_jendo)
end, {})

-- Set default value
vim.api.nvim_create_autocmd("BufEnter", {
  group = "bufcheck",
  pattern = "Jendo.txt",
  callback = function()
    if vim.b.copy_jendo == nil then
      vim.b.copy_jendo = false
    end
  end,
})
