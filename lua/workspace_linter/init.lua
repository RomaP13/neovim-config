local M = {}

--- Currently active linters per filetype, set via M.pick()
---@type table<string, WorkspaceLinter>
M.active_linters = {}

--- Last diagnostic results by linter name, keyed by bufnr.
--- Used to clear stale diagnostics before applying a fresh run.
---@type table<string, table<integer, vim.Diagnostic[]>>
M.last_results = {}

--- Get the current buffer's filetype
---@return string filetype
M.get_current_filetype = function()
  return vim.bo.filetype
end

--- Get the active linter for a buffer, if one has been selected via M.pick()
---@param bufnr integer? Buffer handle, defaults to current bufer (0)
---@return WorkspaceLinter? linter
M.get_current_linter = function(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype
  return M.active_linters[ft]
end

--- Get all supported linters for a filetype
---@param filetype string
---@return WorkspaceLinter[] linters
M.get_linters_by_filetype = function(filetype)
  local workspace_linters = require("workspace_linter.linters")

  local linters = {}
  for _, linter in ipairs(workspace_linters) do
    if vim.tbl_contains(linter.filetypes, filetype) then
      table.insert(linters, linter)
    end
  end

  return linters
end

--- Get or create the diagnostic namespace for a linter
---@param linter WorkspaceLinter
---@return integer namespace
M.namespace = function(linter)
  return vim.api.nvim_create_namespace("workspace:" .. linter.name)
end

--- Get diagnostics for a buffer
---@param bufnr integer
---@param linter WorkspaceLinter
---@return vim.Diagnostic[] diagnostics
M.get_diagnostics = function(bufnr, linter)
  return vim.diagnostic.get(bufnr, { namespace = M.namespace(linter) })
end

--- Group workspace diagnostics by the buffer they belong to
---@param items WorkspaceDiagnostic[] Diagnostics returned by linter.parse()
---@return table<integer, WorkspaceDiagnostic[]> diagnostics_by_buf
M.diagnostics_by_buffer = function(items)
  ---@type table<integer, WorkspaceDiagnostic[]>
  local diagnostics_by_buf = {}

  for _, item in ipairs(items) do
    local bufnr = vim.fn.bufadd(item.filename)
    if bufnr ~= -1 and vim.api.nvim_buf_is_valid(bufnr) then
      diagnostics_by_buf[bufnr] = diagnostics_by_buf[bufnr] or {}
      table.insert(diagnostics_by_buf[bufnr], item)
    else
      vim.notify("workspace_linter: Invalid buffer: " .. item.filename, vim.log.levels.WARN)
    end
  end

  return diagnostics_by_buf
end

--- Run a linter asynchronously over the workspace root and populate
--- vim.diagnostic for every affected buffer. Clears any diagnostic
--- this linter previously set before applying the new results.
--- Should be called from an autocommand to update diagnostics
--- when the current buffer changes.
---@param linter WorkspaceLinter
M.run = function(linter)
  local folders = vim.lsp.buf.list_workspace_folders()
  local root = folders[1]
  if not root then
    root = vim.fn.getcwd()
    vim.notify(
      "workspace_linter: No LSP workspace folder found, falling back to cwd (" .. root .. ")",
      vim.log.levels.WARN
    )
  end

  local cmd = linter.cmd(root)
  if #cmd == 0 then
    vim.notify("workspace_linter: No cmd", vim.log.levels.WARN)
    return
  end

  local fidget_ok, progress = pcall(require, "fidget.progress")
  local handle = fidget_ok
      and progress.handle.create({
        title = linter.name,
        message = "running...",
        lsp_client = { name = linter.name },
      })
    or nil

  local ok, err = pcall(
    vim.system,
    linter.cmd(root),
    { text = true },
    vim.schedule_wrap(function(result)
      if handle then
        handle.message = "done"
        handle:finish()
      end

      local success = vim.tbl_contains(linter.success_codes, result.code)
      if not success then
        vim.notify(
          string.format("%s: exited %d: %s", linter.name, result.code, result.stderr or ""),
          vim.log.levels.ERROR
        )
        return
      end

      local namespace = M.namespace(linter)
      local workspace_diagnostics = linter.parse(result.stdout, root)
      local diagnostics_by_buf = M.diagnostics_by_buffer(workspace_diagnostics)

      M.last_results[linter.name] = M.last_results[linter.name] or {}
      local last = M.last_results[linter.name]
      for bufnr in pairs(last) do
        vim.diagnostic.reset(namespace, bufnr)
      end

      M.last_results[linter.name] = diagnostics_by_buf
      for bufnr, diagnostics in pairs(diagnostics_by_buf) do
        vim.diagnostic.set(namespace, bufnr, diagnostics, {})
      end
    end)
  )

  if not ok then
    vim.notify(linter.name .. ": failed to start (" .. tostring(err) .. ")", vim.log.levels.ERROR)
  end
end

--- Prompt the user to pick a linter for the current
--- buffer's filetype, then set it active and run it once immediately.
M.pick = function()
  local ft = M.get_current_filetype()
  local linters = M.get_linters_by_filetype(ft)
  if #linters == 0 then
    vim.notify("workspace_linter: No linters found for " .. ft, vim.log.levels.WARN)
    return
  end

  vim.ui.select(linters, {
    prompt = "Select linter",
    format_item = function(linter)
      return linter.name
    end,
  }, function(linter)
    if linter then
      M.active_linters[vim.bo.filetype] = linter
      M.run(linter)
    end
  end)
end

--- List available code actions derived from a linter's current
--- diagnostics on the given buffer.
---@param linter WorkspaceLinter
---@param bufnr integer? Buffer to act on, defaults to current buffer (0)
---@return boolean handled True if a code-action menu was shown; false otherwise
M.code_actions = function(linter, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local diagnostics = M.get_diagnostics(bufnr, linter)

  if #diagnostics == 0 then
    vim.notify("workspace_linter: No diagnostics")
    return false
  end

  local actions = linter.code_actions(bufnr, diagnostics)

  if #actions == 0 then
    vim.notify("workspace_linter: No code actions")
    return false
  end

  vim.ui.select(actions, {
    prompt = "Code Actions",
    format_item = function(item)
      return item.title
    end,
  }, function(action)
    if action then
      action.apply()
    end
  end)

  return true
end

return M
