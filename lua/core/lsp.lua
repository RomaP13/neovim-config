local M = {}

local CONFIG = {
  border = "rounded",
  servers = { "lua_ls", "pyright", "ts_ls" },
  filetype_to_lsp = {
    python = "pyright",
    lua = "lua_ls",
    typescript = "ts_ls",
    javascript = "ts_ls",
    javascriptreact = "ts_ls",
    typescriptreact = "ts_ls",
  },
}

--- Initialize LSP servers
---@return nil
local function setup_servers()
  vim.lsp.enable(CONFIG.servers)
end

--- Restart LSP client for the current file
---@return nil
local function restart_lsp()
  local filetype = vim.bo.filetype
  local lsp = CONFIG.filetype_to_lsp[filetype]
  if not lsp then
    vim.notify("LSP client not found for filetype " .. filetype, vim.log.levels.WARN)
    return
  end

  -- Stop and restart LSP client
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == lsp then
      client:stop(true)
    end
  end
  vim.cmd("edit")
  vim.notify("LSP client " .. lsp .. " was stopped", vim.log.levels.INFO)
end

--- Enhanced hover with borders
---@return function
local function create_hover_handler()
  return function(opts)
    opts = opts or {}
    return vim.lsp.buf.hover(vim.tbl_deep_extend("force", opts, {
      border = CONFIG.border,
    }))
  end
end

--- Enhanced diagnostic float with borders
---@return function
local function create_diagnostic_float_handler()
  return function(opts)
    opts = opts or {}
    return vim.diagnostic.open_float(vim.tbl_deep_extend("force", opts, {
      border = CONFIG.border,
    }))
  end
end

--- Diagnostic configuration
---@return nil
local function setup_diagnostics()
  vim.diagnostic.config({
    underline = true,
    virtual_text = {
      prefix = function(diagnostic)
        if diagnostic.user_data and diagnostic.user_data.has_fix then
          return "💡"
        end
        return "■"
      end,
    },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

--- Diagnostic navigation helpers
---@param direction number
---@return function
local function diagnostic_jump(direction)
  return function()
    vim.diagnostic.jump({
      count = direction,
      float = { border = CONFIG.border },
    })
  end
end

--- Create user commands
---@return nil
local function setup_commands()
  vim.api.nvim_create_user_command("LspRestart", restart_lsp, {
    desc = "Restart LSP client for current filetype",
  })
end

--- Setup keymaps
---@return nil
local function setup_keymaps()
  local map = vim.keymap.set
  local hover_handler = create_hover_handler()
  local diagnostic_float_handler = create_diagnostic_float_handler()

  -- LSP health check
  map("n", "<leader>vl", ":checkhealth vim.lsp<CR>", {
    desc = "Check LSP health",
  })

  -- Documentation and navigation
  map("n", "K", hover_handler, {
    desc = "Show hover documentation",
  })
  map("n", "gd", vim.lsp.buf.definition, {
    desc = "Go to definition",
  })
  map("n", "gr", vim.lsp.buf.references, {
    desc = "Show references",
  })
  map("n", "gi", vim.lsp.buf.implementation, {
    desc = "Go to implementation",
  })

  -- Code actions and refactoring
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Show available code actions",
  })
  map("n", "<leader>rn", vim.lsp.buf.rename, {
    desc = "Rename symbol",
  })

  -- Diagnostics
  map("n", "<leader>of", diagnostic_float_handler, {
    desc = "Open diagnostic float",
  })
  map("n", "[d", diagnostic_jump(-1), {
    desc = "Go to previous diagnostic",
  })
  map("n", "]d", diagnostic_jump(1), {
    desc = "Go to next diagnostic",
  })
end

--- Setup LSP
---@return nil
function M.setup()
  setup_servers()
  setup_diagnostics()
  setup_commands()
  setup_keymaps()
end

M.setup()

return M
