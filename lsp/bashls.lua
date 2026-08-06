local lsp_cmd = require("utils.lsp_cmd")

local cmd = lsp_cmd.find_cmd("bash-language-server", "bash-language-server", { "start" })
if not cmd then
  return {}
end

--- Lua language server configuration
---@type vim.lsp.Config
local config = {
  cmd = cmd,
  filetypes = {
    "bash",
    "csh",
    "ksh",
    "sh",
    "zsh",
  },
}

return config
