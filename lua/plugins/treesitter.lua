return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {
        -- Lua stuff
        "lua",
        "luadoc",

        -- Vim stuff
        "vim",
        "vimdoc",

        -- Programming languages
        "bash",
        "c",
        "python",
        "javascript",
        "typescript",

        -- Makrup and documentation
        "markdown",
        "markdown_inline",
        "json",
        "yaml",

        -- Web development
        "css",
        "html",
        "htmldjango",

        -- Other stuff
        "dockerfile",
        "make",
        "query",
      },

      highlight = {
        enable = true,
        use_languagetree = true,
      },

      indent = {
        enable = true,
      },
    })
  end,
}
