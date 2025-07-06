local lsp_cmd = require("utils.lsp_cmd")

--- Lua language server configuration
---@type vim.lsp.Config
local config = {
  cmd = {
    vim.fn.expand("~/.local/share/nvim/mason/bin/lua-language-server"),
  },
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
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      format = {
        enable = false,
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
