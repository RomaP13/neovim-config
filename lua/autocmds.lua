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
