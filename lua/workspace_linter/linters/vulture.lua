---@type WorkspaceLinter
return {
  name = "vulture",

  filetypes = { "python" },

  cmd = function(root)
    --- Comma-separated list of path patterns to ignore (e.g., "*settings.py,docs,*/test_*.py,venv").
    --- Patterns may contain glob wildcards (*, ?, [abc], [!abc]).
    --- A PATTERN without glob wildcards is treated as *PATTERN*.
    --- Patterns are matched against absolute paths.
    local exclude = "*settings.py,docs,*/test_*.py,venv,.venv,alembic"

    --- Comma-separated list of decorators.
    --- Functions and classes using these decorators are ignored (e.g., "@app.route,@require_*").
    --- Patterns may contain glob wildcards (*, ?, [abc], [!abc]).
    local ignore_decorators = "@app.route,@require_*,@router.*,@limiter.*,@*validator,@computed_field"

    --- Comma-separated list of names to ignore (e.g., "visit_*,do_*").
    --- Patterns may contain glob wildcards (*, ?, [abc], [!abc]).
    local ignore_names = ""

    return {
      "vulture",
      root,
      "--exclude",
      exclude,
      "--ignore-decorators",
      ignore_decorators,
      "--ignore-names",
      ignore_names,
    }
  end,

  success_codes = {
    0, -- No dead code found
    3, -- Dead code found
  },

  parse = function(output, _)
    if output == "" then
      vim.notify("vulture: No output", vim.log.levels.WARN)
      return {}
    end

    ---@type WorkspaceDiagnostic[]
    local workspace_diagnostics = {}

    local lines = vim.split(output, "\n")

    -- a.py:13: unused import 'http' (90% confidence)
    for _, line in ipairs(lines) do
      local filename, lnum, message, confidence = line:match("^(.-):(%d+): (.-) %((%d+%%) confidence%)$")

      if filename then
        table.insert(workspace_diagnostics, {
          filename = filename,

          lnum = tonumber(lnum) - 1,
          col = 0,

          severity = vim.diagnostic.severity.HINT,
          message = message:gsub("^%l", string.upper),
          code = confidence,
          source = "vulture",
        })
      end
    end

    return workspace_diagnostics
  end,
}
