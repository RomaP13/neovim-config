local lsp_cmd = require("utils.lsp_cmd")

local cmd = lsp_cmd.find_cmd("markdown-oxide", "markdown-oxide")
if not cmd then
  return {}
end

---@param client vim.lsp.Client
---@param bufnr integer
---@param c string
local function command_factory(client, bufnr, c)
  return client:exec_cmd({
    title = ("Markdown-Oxide-%s"):format(c),
    command = "jump",
    arguments = { c },
  }, { bufnr = bufnr })
end

---@type vim.lsp.Config
local config = {
  cmd = cmd,
  filetypes = {
    "markdown",
  },
  root_markers = {
    ".git",
    ".obsidian",
    ".moxide.toml",
  },
  on_attach = function(client, bufnr)
    for _, c in ipairs({ "today", "tomorrow", "yesterday" }) do
      vim.api.nvim_buf_create_user_command(bufnr, "Lsp" .. ("%s"):format(c:gsub("^%l", string.upper)), function()
        command_factory(client, bufnr, c)
      end, {
        desc = ("Open %s daily note"):format(c),
      })
    end
  end,
}

return config
