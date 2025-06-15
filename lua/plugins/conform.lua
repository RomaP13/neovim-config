return {
  "stevearc/conform.nvim",
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
}
