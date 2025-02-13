return {
  "nvimtools/none-ls.nvim",
  config = function()
    -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- lua stuff
        -- null_ls.builtins.formatting.stylua.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
        --   end,
        -- }),

        -- c stuff
        null_ls.builtins.formatting.clang_format,

        -- python stuff
        -- null_ls.builtins.formatting.isort,
        -- null_ls.builtins.formatting.black,
        -- null_ls.builtins.diagnostics.mypy.with({
        --   extra_args = function()
        --     local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
        --     return { "--python-executable", virtual .. "/bin/python3" }
        --   end,
        -- }),
      },
      -- Formatting on save
      -- on_attach = function(client, bufnr)
      --   if client.supports_method("textDocument/formatting") then
      --     vim.api.nvim_clear_autocmds({
      --       group = augroup,
      --       buffer = bufnr,
      --     })
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       group = augroup,
      --       buffer = bufnr,
      --       callback = function()
      --         vim.lsp.buf.format({ bufnr = bufnr })
      --       end,
      --     })
      --   end
      -- end,
    })

    vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
  end,
}
