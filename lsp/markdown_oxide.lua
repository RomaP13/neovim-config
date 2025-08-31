local lsp_cmd = require("utils.lsp_cmd")

---@param client vim.lsp.Client
---@param bufnr integer
---@param cmd string
local function command_factory(client, bufnr, cmd)
  return client:exec_cmd({
    title = ("Markdown-Oxide-%s"):format(cmd),
    command = "jump",
    arguments = { cmd },
  }, { bufnr = bufnr })
end

---@type vim.lsp.Config
local config = {
  cmd = lsp_cmd.find_cmd("markdown-oxide", "markdown-oxide"),
  filetypes = {
    "markdown",
  },
  root_markers = {
    ".git",
    ".obsidian",
    ".moxide.toml",
  },
  on_attach = function(client, bufnr)
    for _, cmd in ipairs({ "today", "tomorrow", "yesterday" }) do
      vim.api.nvim_buf_create_user_command(bufnr, "Lsp" .. ("%s"):format(cmd:gsub("^%l", string.upper)), function()
        command_factory(client, bufnr, cmd)
      end, {
        desc = ("Open %s daily note"):format(cmd),
      })
    end
  end,
}

return config
