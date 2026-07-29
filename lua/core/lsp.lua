local M = {}

local CONFIG = {
  border = "rounded",
  servers = { "lua_ls", "basedpyright", "ts_ls", "markdown_oxide" },
  filetype_to_lsp = {
    python = "basedpyright",
    lua = "lua_ls",
    typescript = "ts_ls",
    javascript = "ts_ls",
    javascriptreact = "ts_ls",
    typescriptreact = "ts_ls",
    markdown = "markdown_oxide",
  },
}

--- Initialize LSP servers
local function setup_servers()
  vim.lsp.enable(CONFIG.servers)
end

--- Restart LSP client for the current file.
--- Warns instead of restarting if the buffer has unsaved changes, since
--- `:edit` would otherwise silently discard them.
local function restart_lsp()
  local filetype = vim.bo.filetype
  local lsp = CONFIG.filetype_to_lsp[filetype]
  if not lsp then
    vim.notify("LSP client not found for filetype " .. filetype, vim.log.levels.WARN)
    return
  end

  if vim.bo.modified then
    vim.notify("Buffer has unsaved changes, save before restarting LSP", vim.log.levels.WARN)
    return
  end

  local stopped = false
  for _, client in ipairs(vim.lsp.get_clients({ name = lsp })) do
    client:stop(true)
    stopped = true
  end

  if not stopped then
    vim.notify("No running client named " .. lsp, vim.log.levels.WARN)
    return
  end

  vim.cmd("edit")
  vim.notify(lsp .. " restarted", vim.log.levels.INFO)
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

--- Toggle inlay hints for the current buffer
local function toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
  vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"), vim.log.levels.INFO)
end

--- Create user commands
local function setup_commands()
  vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
    desc = "LSP: Show status of active and configured LSP clients",
  })
  vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd(string.format("tabnew %s", vim.lsp.get_log_path()))
  end, {
    desc = "LSP: Open Nvim LSP client log",
  })
  vim.api.nvim_create_user_command("LspRestart", restart_lsp, {
    desc = "LSP: Restart LSP client for current filetype",
  })
  vim.api.nvim_create_user_command("LspToggleInlayHints", toggle_inlay_hints, {
    desc = "LSP: Toggle inlay hints for current buffer",
  })
end

--- Buffer-local keymaps bound on LspAttach
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  local hover_handler = create_hover_handler()
  local diagnostic_float_handler = create_diagnostic_float_handler()
  local workspace_linter = require("workspace_linter")

  map("n", "K", hover_handler, "Show hover documentation")

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  if client:supports_method("textDocument/references") then
    map("n", "gr", vim.lsp.buf.references, "Show references")
  end

  map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
  map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")

  if client:supports_method("textDocument/rename") then
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  end

  if client:supports_method("textDocument/inlayHint") then
    map("n", "<leader>lh", toggle_inlay_hints, "Toggle inlay hints")
  end

  map("n", "<leader>lw", workspace_linter.pick, "Pick workspace linter")
  map("n", "<leader>of", diagnostic_float_handler, "Open diagnostic float")
  map("n", "[d", diagnostic_jump(-1), "Go to previous diagnostic")
  map("n", "]d", diagnostic_jump(1), "Go to next diagnostic")

  map("n", "<leader>ca", function()
    local linter = workspace_linter.get_current_linter()
    if linter and linter.code_actions then
      local handled = workspace_linter.code_actions(linter)
      if handled then
        return
      end
    end
    vim.lsp.buf.code_action()
  end, "Code actions")
end

--- Global keymaps that don't depend on an attached LSP client
local function setup_global_keymaps()
  vim.keymap.set(
    "n",
    "<leader>vl",
    "<cmd>checkhealth vim.lsp<CR>",
    { desc = "LSP: Show status of active and configured LSP clients" }
  )
end

--- Setup LSP
function M.setup()
  setup_servers()
  setup_diagnostics()
  setup_commands()
  setup_global_keymaps()

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("CoreLspAttach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach(client, args.buf)
      end
    end,
  })
end

M.setup()

return M
