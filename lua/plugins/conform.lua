return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
    },
    formatters = {
      stylua = {
        command = vim.fn.stdpath("data") .. "/mason/bin/stylua",
      },
      prettier = {
        command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
      },
    },
  },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer with conform",
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
      pattern = {
        "*.lua",
        "*.json",
        "*.jsonc",
        "*.yaml",
        "*.html",
        "*.css",
      },
      callback = function(args)
        require("conform").format({
          bufnr = args.buf,
          async = false, -- block saving until formatting is done
        })
      end,
    })
  end,
}
