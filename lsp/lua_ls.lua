local lsp_cmd = require("utils.lsp_cmd")

local cmd = lsp_cmd.find_cmd("lua_ls", "lua-language-server")
if not cmd then
  return {}
end

--- Lua language server configuration
---@type vim.lsp.Config
local config = {
  cmd = cmd,
  filetypes = {
    "lua",
  },
  root_markers = {
    ".git",
    ".luacheckrc",
    ".luarc.json",
    ".luarc.jsonc",
    ".stylua.toml",
    "stylua.toml",
  },
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      doc = {
        privateName = { "^_" },
        protectedName = { "^__" },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        await = true,
        paramName = "All",
        paramType = true,
        semicolon = "Disable",
        setType = false,
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.expand("~/.local/share/nvim/lazy/lazy.nvim/lua"),
        },
      },
    },
  },
}

return config
