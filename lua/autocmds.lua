local fn = vim.fn

vim.api.nvim_create_augroup("bufcheck", { clear = true })

-- Reload config file on change
vim.api.nvim_create_autocmd("BufWritePost", {
  group   = "bufcheck",
  pattern = vim.env.MYVIMRC,
  command = "silent source %"
})

-- Highlight yanks
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = "bufcheck",
  pattern  = "*",
  callback = function() vim.highlight.on_yank { timeout = 500 } end
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group    = "bufcheck",
  pattern  = "*",
  callback = function()
    if fn.line("'\"") > 0 and fn.line("'\"") <= fn.line("$") then
      fn.setpos(".", fn.getpos("'\""))
      vim.cmd("silent! foldopen")
    end
  end
})

-- Define a function to check if formatting should run
local function should_format()
  return vim.b.format_on_save ~= false
end

-- Python: Sort imports and format code on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group    = "CocGroup",
--   pattern  = "*.py",
--   callback = function()
--     if should_format() then
--       -- Sort imports
--       fn.CocAction("runCommand", "editor.action.organizeImport")
--       -- Format code
--       fn.CocAction("format")
--     end
--   end,
-- })

-- JavaScript/TypeScript: Sort imports and format code on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group    = "CocGroup",
--   pattern  = { "*.js", "*.jsx", "*.ts", "*.tsx" },
--   callback = function()
--     if should_format() then
--       -- Sort imports
--       fn.CocAction("runCommand", "editor.action.organizeImport")
--       -- Format code
--       fn.CocAction("format")
--     end
--   end,
-- })

-- Add commands to toggle formatting
vim.api.nvim_create_user_command("ToggleFormatOnSave", function()
  vim.b.format_on_save = not vim.b.format_on_save
  print("Format on save:", vim.b.format_on_save)
end, {})

-- Set default value
vim.api.nvim_create_autocmd("BufEnter", {
  group    = "bufcheck",
  pattern  = "*",
  callback = function()
    if vim.b.format_on_save == nil then
      vim.b.format_on_save = true
    end
  end,
})
