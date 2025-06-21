vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",
})

-- Custom hover and diagnostic float for adding borders
local _border = "rounded"
local function hover(_opts)
  _opts = _opts or {}
  return vim.lsp.buf.hover(vim.tbl_deep_extend("force", _opts, {
    border = _border,
  }))
end

local function diagnostic_float(_opts)
  _opts = _opts or {}
  return vim.diagnostic.open_float(vim.tbl_deep_extend("force", _opts, {
    border = _border,
  }))
end

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

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>vl", ":checkhealth vim.lsp<CR>", {})

map("n", "K", hover, { desc = "Show hover documentation" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Show available code actions" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

map("n", "<leader>of", diagnostic_float, { desc = "Open diagnostic float" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = { border = _border } })
end, { desc = "Go to previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = { border = _border } })
end, { desc = "Go to next diagnostic" })
