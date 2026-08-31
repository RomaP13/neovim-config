return {
  "stevearc/conform.nvim",
  event = "BufWritePre",

  init = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
      callback = function(args)
        if vim.b[args.buf].skip_format then
          vim.b[args.buf].skip_format = false
          return
        end

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
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },

      lua = { "stylua" },

      python = { "ruff_format", "ruff_organize_imports" },

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
      shfmt = {
        prepend_args = { "-i", "2", "-bn", "-ci", "-sr" },
      },
      prettier = {
        condition = function(_, ctx)
          local ignored_files = {
            ["lazy-lock.json"] = true,
          }
          if ignored_files[vim.fs.basename(ctx.filename)] then
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
        vim.b.skip_format = true
        vim.cmd.write()
      end,
      desc = "Conform: Save buffer without formatting",
    },
  },
}
