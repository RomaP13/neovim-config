local fn = vim.fn

vim.api.nvim_create_augroup("bufcheck", { clear = true })
vim.api.nvim_create_augroup("LspFormatting", { clear = true })

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

-- Function to check if formatting should run
local function should_format()
  -- Explicitly disable formatting if set
  if vim.b.format_on_save == false then
    return false
  end

  -- Always allow Python formatting with Ruff
  if vim.bo.filetype == "python" then
    return true
  end

  -- Check if any attached LSP client supports formatting
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting", { bufnr = vim.api.nvim_get_current_buf() }) then
      return true
    end
  end

  return false
end

-- Python: Format and organize imports on save with Ruff
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  pattern = "*.py",
  callback = function()
    if should_format() then
      vim.cmd("RuffFormat")
    end
  end,
})

-- Other languages: Format on save with LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  pattern = "*",
  callback = function()
    -- Skip Python files
    if vim.bo.filetype == "python" then
      return
    end
    if should_format() then
      local success, err = pcall(vim.lsp.buf.format, { async = false })
      if not success then
        vim.notify("LSP formatting failed: " .. tostring(err), vim.log.levels.WARN)
      end
    end
  end,
})

-- Toggle format-on-save command
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.b.format_on_save = not vim.b.format_on_save
  vim.notify("Format on save: " .. tostring(vim.b.format_on_save), vim.log.levels.INFO)
end, {})

-- Set default format-on-save value
vim.api.nvim_create_autocmd("BufEnter", {
  group = "bufcheck",
  pattern = "*",
  callback = function()
    if vim.b.format_on_save == nil then
      vim.b.format_on_save = true
    end
  end,
})
