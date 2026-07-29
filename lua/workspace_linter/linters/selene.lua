---@type WorkspaceLinter
return {
  name = "selene",

  filetypes = { "lua", "luau" },

  cmd = function(root)
    return {
      "selene",
      "--display-style",
      "json2",
      root,
    }
  end,

  success_codes = { 0, 1 },

  parse = function(output, _)
    if output == "" then
      vim.notify("selene: No output", vim.log.levels.WARN)
      return {}
    end

    local items = {}
    for line in output:gmatch("[^\r\n]+") do
      local ok, item = pcall(vim.fn.json_decode, line)
      if ok then
        table.insert(items, item)
      end
    end

    ---@type WorkspaceDiagnostic[]
    local workspace_diagnostics = {}

    for _, item in ipairs(items) do
      if item.type == "Diagnostic" then
        table.insert(workspace_diagnostics, {
          filename = item.primary_label.filename,

          lnum = item.primary_label.span.start_line - 1,
          col = item.primary_label.span.start_column - 1,

          end_lnum = item.primary_label.span.end_line - 1,
          end_col = item.primary_label.span.end_column - 1,

          severity = item.severity == "Error" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN,
          message = item.message,
          code = item.code,
          source = "selene",
        })
      end
    end

    return workspace_diagnostics
  end,
}
