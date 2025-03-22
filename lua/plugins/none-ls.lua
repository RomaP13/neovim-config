return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    local mason_null_ls = require("mason-null-ls")
    local null_ls = require("null-ls")

    mason_null_ls.setup({
      ensure_installed = {
        -- lua stuff
        "lua_language_server",
        "stylua",

        -- python stuff
        "pyright",
        "ruff",

        -- javascript and typescript stuff
        "typescript-language-server",
        "prettier",

        -- c stuff
        "clangd",

        -- TODO: Find out about write-good linter
      },
      automatic_installation = true,
    })

    -- TODO: Add stuff:
    -- hadolint - for dockerfile
    null_ls.setup({
      sources = {
        -- lua stuff
        null_ls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),

        null_ls.builtins.formatting.prettier.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "css",
            "scss",
            "less",
            "html",
            "json",
            "jsonc",
            "yaml",
            -- "markdown",
            -- "markdown.mdx",
            "graphql",
            "handlebars",
          },
        }),

        null_ls.builtins.code_actions.gitsigns,

        -- c stuff
        -- null_ls.builtins.formatting.clang_format,
      },
    })
  end,
}
