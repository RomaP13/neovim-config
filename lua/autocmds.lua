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

vim.api.nvim_create_user_command("RuffCheck", function()
  vim.fn.jobstart("ruff check .", {
    stdout_buffered = true,
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        print(line) -- Print Ruff's output in Neovim
      end
    end,
  })
end, {})

vim.api.nvim_create_user_command("RuffDiagnostics", function()
  local output = {}

  vim.fn.jobstart("ruff check --output-format=json .", {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end
      for _, line in ipairs(data) do
        table.insert(output, line)
      end
    end,
    on_exit = function()
      if #output == 0 then
        print("Ruff: No output received.")
        return
      end

      local json_str = table.concat(output, "")
      local success, items = pcall(vim.fn.json_decode, json_str)

      if not success then
        print("Error decoding Ruff JSON output: " .. json_str)
        return
      end

      local namespace = vim.api.nvim_create_namespace("ruff")
      local diagnostics_by_buf = {}

      for _, item in ipairs(items) do
        local bufnr = vim.fn.bufnr(item.filename, true) -- Open the file in the background if needed

        if bufnr and bufnr ~= -1 then
          diagnostics_by_buf[bufnr] = diagnostics_by_buf[bufnr] or {}

          table.insert(diagnostics_by_buf[bufnr], {
            bufnr = bufnr,
            lnum = item.location.row - 1,
            col = item.location.column - 1,
            severity = vim.diagnostic.severity.WARN,
            message = item.message,
            source = "ruff",
          })
        end
      end

      -- Clear previous Ruff diagnostics for all buffers
      vim.diagnostic.reset(namespace)

      -- Set new diagnostics for each buffer
      for bufnr, diagnostics in pairs(diagnostics_by_buf) do
        vim.diagnostic.set(namespace, bufnr, diagnostics, {})
      end

      print("Ruff diagnostics updated.")
    end,
  })
end, {})
