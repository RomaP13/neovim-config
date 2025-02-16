local fn = vim.fn

vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_augroup("LspFormatting", {})

-- Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
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
  return vim.b.format_on_save ~= false
end

-- Python: Format code and organize imports on save using Ruff
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  callback = function()
    if should_format() then
      -- Organize imports
      -- Format code
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
