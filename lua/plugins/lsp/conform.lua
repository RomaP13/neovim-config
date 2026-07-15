return {
  "stevearc/conform.nvim",
  event = "BufWritePre",

  init = function()
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

  ---@module "conform"
  ---@type conform.setupOpts
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
        condition = function(_, ctx)
          local ignored_files = {
            ["lazy-lock.json"] = true,
          }
          if ignored_files[vim.fs.basename(ctx.filename)] ~= nil then
            return false -- Don't format this file
          end

          return true
        end,
      },
    },
  },

  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Conform: Format buffer",
    },
    {
      "<leader>fs",
      function()
        vim.b.skip_next_format = true
        vim.cmd.write()
      end,
      desc = "Conform: Save buffer without formatting",
    },
  },
}
