local workspace_linter = require("workspace_linter")

local fn = vim.fn

local view_group = vim.api.nvim_create_augroup("ViewPersistence", { clear = true })

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

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = view_group,
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = view_group,
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! loadview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(args)
    vim.diagnostic.show(nil, args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local linter = workspace_linter.get_current_linter(args.buf)

    if not linter then
      return
    end

    workspace_linter.run(linter)
  end,
})
