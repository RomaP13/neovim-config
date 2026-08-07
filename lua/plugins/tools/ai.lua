return {
  "monkoose/neocodeium",
  ft = {
    "sh",
    "bash",
    "zsh",
    "lua",
    "python",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    "css",
    "json",
    "jsonc",
    "yaml",
  },

  ---@module "neocodeium"
  ---@type Options
  opts = {
    enabled = true,
    manual = false,
    filetypes = {
      help = false,
      gitcommit = false,
      gitrebase = false,
      ["."] = false,
    },
    filter = function(bufnr)
      local allowed_filetypes = {
        sh = true,
        bash = true,
        zsh = true,
        lua = true,
        python = true,
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        html = true,
        css = true,
        json = true,
        jsonc = true,
        yaml = true,
      }
      return allowed_filetypes[vim.bo[bufnr].filetype] == true
    end,
  },

  ---@type LazyKeysSpec[]
  keys = {
    {
      "<C-u>",
      function()
        require("neocodeium").accept()
      end,
      mode = "i",
      desc = "NeoCodeium: Accept the current suggestion",
    },
    {
      "<M-;>",
      function()
        require("neocodeium").cycle(1)
      end,
      mode = "i",
      desc = "NeoCodeium: Cycle suggestions +1",
    },
    {
      "<M-,>",
      function()
        require("neocodeium").cycle(-1)
      end,
      mode = "i",
      desc = "NeoCodeium: Cycle suggestions -1",
    },
    {
      "<C-x>",
      function()
        require("neocodeium").clear()
      end,
      mode = "i",
      desc = "NeoCodeium: Clear the current suggestion",
    },
    {
      "<leader>ct",
      "<cmd>NeoCodeium toggle<CR>",
      mode = "n",
      desc = "NeoCodeium: Toggle NeoCodeium completion",
    },
  },
}
