---@class WorkspaceDiagnostic
---@field filename string Path to the file
---@field lnum integer Line number (0-indexed)
---@field col integer Column number (0-indexed)
---@field end_lnum integer? End line number (0-indexed)
---@field end_col integer? End column number (0-indexed)
---@field severity integer Severity of the diagnostic
---@field message string Diagnostic message
---@field code string? Linter-specific rule code
---@field source string Human-readable source label
---@field user_data table Linter-specific data (e.g. fix payload), consumed by code_actions

---@class WorkspaceCodeAction
---@field title string Display title in the picker
---@field apply fun() Applied the action

---@class WorkspaceLinter
---@field name string Display name in the picker
---@field filetypes string[] Supported filetypes
---@field cmd fun(root: string): string[] Command to run the linter
---@field success_codes integer[] Exit condes considered non-failing
---@field parse fun(output: string, root: string): WorkspaceDiagnostic[] Parsed stdout into diagnostics
---@field code_actions? fun(bufnr: integer, diagnostics: WorkspaceDiagnostic[]): WorkspaceCodeAction[] Optional: derive code actions from diagnostics

--- List of registered workspace linters
---@type WorkspaceLinter[]
local M = {
  -- Lua
  require("workspace_linter.linters.selene"),

  -- Python
  require("workspace_linter.linters.ruff"),
  require("workspace_linter.linters.vulture"),
  require("workspace_linter.linters.deptry"),
}

return M
