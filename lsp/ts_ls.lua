local lsp_cmd = require("utils.lsp_cmd")

--- Organize imports
---@param bufnr number?
---@return nil
local function organize_imports(bufnr)
  -- Get the current buffer if no buffer is passed
  if not bufnr then
    bufnr = vim.api.nvim_get_current_buf()
  end

  -- Params for the request
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
    title = "",
  }

  vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 500)
end

--- Create commands and keymaps
---@param client vim.lsp.Client
---@param bufnr number
---@return nil
local function create_ts_commands(client, bufnr)
  local map = vim.keymap.set

  -- Create command to organize imports
  vim.api.nvim_buf_create_user_command(bufnr, "OrganizeImports", function()
    organize_imports(bufnr)
  end, { desc = "Organize imports using tsserver" })

  map("n", "<leader>or", function()
    organize_imports(bufnr)
  end, {
    desc = "Organize imports",
    buffer = bufnr,
  })

  -- Source.* code actions only show up with context.only
  vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
    local kinds = client.server_capabilities.codeActionProvider
        and client.server_capabilities.codeActionProvider.codeActionKinds
      or {}
    local source_kinds = vim.tbl_filter(function(kind)
      return vim.startswith(kind, "source.")
    end, kinds)

    vim.lsp.buf.code_action({
      context = {
        only = source_kinds,
        diagnostics = vim.diagnostic.get(bufnr),
      },
    })
  end, { desc = "Trigger tsserver source actions" })

  map("n", "<leader>ts", ":LspTypescriptSourceAction<CR>", {
    desc = "TypeScript source actions",
  })
end

--- Typescript language server configuration
---@type vim.lsp.Config
local config = {
  init_options = {
    hostInfo = "neovim",
  },
  cmd = {
    vim.fn.expand("~/.local/share/nvim/mason/bin/typescript-language-server"),
    "--stdio",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = {
    ".git",
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
  },
  handlers = {
    -- Handle rename request for certain code actions like extracting functions / types
    ["_typescript.rename"] = function(_, result, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      vim.lsp.util.show_document({
        uri = result.textDocument.uri,
        range = {
          start = result.position,
          ["end"] = result.position,
        },
      }, client.offset_encoding)
      vim.lsp.buf.rename()
      return vim.NIL
    end,
  },
  on_attach = function(client, bufnr)
    -- Format and organize imports on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("TypescriptFormatting", { clear = true }),
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
      callback = function(args)
        organize_imports(bufnr)
        require("conform").format({
          bufnr = args.buf,
          async = false, -- block saving until formatting is done
        })
      end,
    })

    create_ts_commands(client, bufnr)

    -- Trigger diagnostics across workspace
    require("utils.lsp_diagnostics_loader").trigger_workspace_diagnostics(client, bufnr)
  end,
}

return config
