local report_path

---@type WorkspaceLinter
return {
  name = "deptry",

  filetypes = { "python" },

  cmd = function(root)
    report_path = vim.fn.tempname() .. "deptry.json"
    return {
      "deptry",
      root,
      "--json-output",
      report_path,
    }
  end,

  success_codes = {
    0, -- Issues are found
    1, -- No issues are found
  },

  parse = function(_, root)
    if not report_path or vim.fn.filereadable(report_path) == 0 then
      vim.notify("deptry: No report file found", vim.log.levels.WARN)
      return {}
    end

    local content = table.concat(vim.fn.readfile(report_path), "\n")
    os.remove(report_path)
    report_path = nil

    if content == "" then
      return {}
    end

    local ok, items = pcall(vim.fn.json_decode, content)
    if not ok then
      vim.notify("deptry: Failed to decode JSON", vim.log.levels.WARN)
      return {}
    end

    ---@type WorkspaceDiagnostic[]
    local workspace_diagnostics = {}

    for _, item in ipairs(items) do
      local file = item.location.file
      if not vim.startswith(file, "/") then
        file = root .. "/" .. file
      end

      local raw_line = item.location.line
      local raw_column = item.location.column

      table.insert(workspace_diagnostics, {
        filename = file,

        -- DEP002 (unused dep) has no line/column — anchor it to line 1
        lnum = (raw_line ~= vim.NIL and raw_line or 1) - 1,
        col = (raw_column ~= vim.NIL and raw_column or 0),

        severity = vim.diagnostic.severity.WARN,
        message = item.error.message,
        code = item.error.code,
        source = "deptry",
      })
    end

    return workspace_diagnostics
  end,
}
