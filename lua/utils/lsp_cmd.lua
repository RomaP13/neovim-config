local M = {}

--- Check if a command/executable exists and is accessible
---@param cmd string The command to check
---@return boolean exists Whether the command exists
local function cmd_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

--- Find LSP server command in common locations
---@param server_name string Name of the LSP server (for error messages)
---@param binary_name string The binary name to search for
---@param args string[]? Additional arguments for the command (optional)
---@param priority_paths string[]? Additional paths to try first (optional)
---@return string[]? cmd The command array if found, nil if not found
function M.find_cmd(server_name, binary_name, args, priority_paths)
  local paths = {}

  -- Add priority paths first if provided
  if priority_paths then
    vim.list_extend(paths, priority_paths)
  end

  -- Add common locations
  vim.list_extend(paths, {
    -- Mason installation path
    "~/.local/share/nvim/mason/bin/" .. binary_name,

    -- Common system installation paths
    "/usr/local/bin/" .. binary_name,
    "/usr/bin/" .. binary_name,

    -- Try in $PATH
    binary_name,
  })

  -- Try each path
  for _, path in ipairs(paths) do
    local expanded_path = vim.fn.expand(path)
    if cmd_exists(expanded_path) then
      local cmd = { expanded_path }
      if args then
        vim.list_extend(cmd, args)
      end
      return cmd
    end
  end

  -- If we get here, no command was found
  vim.notify(
    string.format(
      "LSP server '%s' not found. Tried paths:\n%s",
      server_name,
      "  • " .. table.concat(paths, "\n  • ")
    ),
    vim.log.levels.ERROR
  )

  return nil
end

return M
