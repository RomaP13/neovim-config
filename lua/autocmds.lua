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

-- Sort imports and format code on save for Python files
vim.api.nvim_create_autocmd("BufWritePre", {
  group    = "CocGroup",
  pattern  = "*.py",
  callback = function()
    -- Sort imports
    -- fn.CocAction("runCommand", "python.sortImports")
    fn.CocAction("runCommand", "editor.action.organizeImport")
    -- Format code
    fn.CocAction("format")
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group    = "CocGroup",
  pattern  = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    -- Sort imports
    fn.CocAction("runCommand", "editor.action.organizeImport")
    -- Format code
    fn.CocAction("format")
  end,
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
