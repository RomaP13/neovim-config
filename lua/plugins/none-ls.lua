return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    local mason_null_ls = require("mason-null-ls")
    local null_ls = require("null-ls")

    local ruff = require("none-ls.formatting.ruff")
    local ruff_format = require("none-ls.formatting.ruff_format")

    mason_null_ls.setup({
      ensure_installed = {
        -- lua stuff
        "lua_language_server",
        "stylua",

        -- python stuff
        "pyright",
        "ruff",
      },
      automatic_installation = true,
    })

    -- TODO: Add formatting for other languages
    null_ls.setup({
      sources = {
        -- lua stuff
        null_ls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),

        -- python stuff
        ruff.with({
          extra_args = {
            "--extend-select",
            "I",
          },
        }),
        ruff_format,

        -- c stuff
        -- null_ls.builtins.formatting.clang_format,
      },
    })
  end,
}
