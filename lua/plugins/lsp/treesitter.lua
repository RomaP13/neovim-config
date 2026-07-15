return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local nvim_treesitter = require("nvim-treesitter")
    nvim_treesitter.setup({
      -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Auto-install
    nvim_treesitter.install({
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

      -- Markdown and documentation
      "markdown",
      "markdown_inline",
      "json",
      "yaml",

      -- Web development
      "css",
      "html",

      -- Other stuff
      "dockerfile",
      "make",
      "query",
    })

    -- Enable Treesitter features using native Neovim autocommands
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua",
        "vim",
        "sh",
        "c",
        "python",
        "javascript",
        "typescript",
        "markdown",
        "json",
        "css",
        "html",
        "dockerfile",
      },
      callback = function()
        -- Highlighting provided by core Neovim
        pcall(vim.treesitter.start)

        -- Folds provided by core Neovim
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"

        -- Indentation provided by nvim-treesitter module
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Set up custom filetype mappings and language registers
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
