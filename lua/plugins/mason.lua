return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
    keys = {
      { "<leader>im", ":Mason<CR>", desc = "Mason" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- python stuff
        "pyright",

        -- js and ts stuff
        "typescript-language-server",
        "prettier",
      },

      -- If set to true this will check each tool for updates
      auto_update = false,

      -- Automatically install / update on startup
      run_on_start = true,

      -- Set a delay (in ms) before the installation starts
      start_delay = 3000, -- 3 second delay

      -- Only attempt to install if 'debounce_hours' number of hours has
      -- elapsed since the last time Neovim was started
      debounce_hours = nil,

      integrations = {
        ["mason-lspconfig"] = false,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
      },
    },
  },
}
