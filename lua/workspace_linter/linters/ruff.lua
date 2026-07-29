--- Apply a single Ruff fix's edits to a buffer, then save it
---@param bufnr integer Buffer to apply the fix to
---@param fix table Ruff "fix" object: { message: string?, edits: ... }
local function apply_fix(bufnr, fix)
  if not fix or not fix.edits or #fix.edits == 0 then
    vim.notify("ruff: No valid edits in fix.", vim.log.levels.WARN)
    return
  end

  if not vim.api.nvim_buf_is_valid(bufnr) then
    vim.notify("ruff: Invalid buffer: " .. tostring(bufnr), vim.log.levels.ERROR)
    return
  end

  -- Apply the fix
  for i = #fix.edits, 1, -1 do
    local edit = fix.edits[i]
    local start_row = edit.location.row - 1
    local start_col = edit.location.column - 1
    local end_row = edit.end_location.row - 1
    local end_col = edit.end_location.column - 1
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, vim.split(edit.content, "\n"))
  end

  -- Save the buffer
  local success, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd("write")
  end)
  if not success then
    vim.notify("ruff: Failed to save buffer: " .. tostring(err), vim.log.levels.ERROR)
  end
end

---@type WorkspaceLinter
return {
  name = "ruff",

  filetypes = { "python" },

  cmd = function(root)
    return {
      "ruff",
      "check",
      root,
      "--output-format",
      "json",
    }
  end,

  success_codes = { 0, 1 },

  parse = function(output, _)
    if output == "" then
      vim.notify("ruff: No output", vim.log.levels.WARN)
      return {}
    end

    local ok, items = pcall(vim.fn.json_decode, output)
    if not ok then
      vim.notify("ruff: Failed to decode JSON", vim.log.levels.WARN)
      return {}
    end

    ---@type WorkspaceDiagnostic[]
    local workspace_diagnostics = {}

    for _, item in ipairs(items) do
      table.insert(workspace_diagnostics, {
        filename = item.filename,

        lnum = item.location.row - 1,
        col = item.location.column - 1,

        end_lnum = item.end_location.row - 1,
        end_col = item.end_location.column - 1,

        severity = vim.diagnostic.severity.WARN,
        message = item.message,
        code = item.code,
        source = "ruff",

        user_data = { fix = item.fix, has_fix = item.fix ~= vim.NIL },
      })
    end

    return workspace_diagnostics
  end,

  code_actions = function(bufnr, diagnostics)
    local actions = {}

    for _, diagnostic in ipairs(diagnostics) do
      local fix = diagnostic.user_data.fix

      if fix and fix ~= vim.NIL then
        table.insert(actions, {
          title = fix.message or diagnostic.message,
          apply = function()
            apply_fix(bufnr, fix)
          end,
        })
      end
    end

    return actions
  end,
}
