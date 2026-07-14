return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "fei6409/log-highlight.nvim",
  },
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
        "jsonc",
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

    vim.treesitter.language.register("bash", "dotenv")

    -- Filetype detection
    vim.filetype.add({
      extension = {
        mdx = "mdx",
        log = "log",
        conf = "conf",
        env = "dotenv",
      },
      filename = {
        [".env"] = "dotenv",
        ["env"] = "dotenv",
        ["tsconfig.json"] = "jsonc",
      },
      pattern = {
        -- INFO: Match filenames like - ".env.example", ".env.local" and so on
        ["%.env%.[%w_.-]+"] = "dotenv",
      },
    })
  end,
}
