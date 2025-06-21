local M = {}

local loaded_clients = {}

--- Get all workspace files with ts/ts extensions
---@return table Array of absolute fiel paths
local function get_workspace_files()
  local cmd = {
    "fd",
    "--type",
    "f",
    "--extension",
    "ts",
    "--extension",
    "tsx",
    "--extension",
    "js",
    "--extension",
    "jsx",
    "--exclude",
    "node_modules",
    ".",
  }

  local files = vim.fn.systemlist(cmd)
  local result = {}
  for _, f in ipairs(files) do
    if vim.fn.filereadable(f) == 1 then
      table.insert(result, vim.fn.fnamemodify(f, ":p"))
    end
  end
  return result
end

--- Trigger workspace diagnostics by opening all relevant files with LSP client
---@param client table LSP client object
---@param bufnr number Buffer number of the current file
---@return nil
M.trigger_workspace_diagnostics = function(client, bufnr)
  -- Skip if client already processed
  if loaded_clients[client.id] then
    return
  end
  loaded_clients[client.id] = true

  -- Check if client supports textDocument/didOpen
  if not vim.tbl_get(client.server_capabilities, "textDocumentSync", "openClose") then
    return
  end

  local workspace_files = get_workspace_files()
  local current_file = vim.api.nvim_buf_get_name(bufnr)

  -- Iterate through all workspace files
  for _, path in ipairs(workspace_files) do
    -- Skip current file
    if path == current_file then
      goto continue
    end

    -- Check if file type is supported by client
    local filetype = vim.filetype.match({ filename = path })
    if not filetype or not vim.tbl_contains(client.config.filetypes, filetype) then
      goto continue
    end

    -- Read file content
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
      goto continue
    end

    -- Notify LSP client about opened document
    client.notify("textDocument/didOpen", {
      textDocument = {
        uri = vim.uri_from_fname(path),
        languageId = filetype,
        version = 0,
        text = table.concat(lines, "\n"),
      },
    })

    ::continue::
  end
end

return M
