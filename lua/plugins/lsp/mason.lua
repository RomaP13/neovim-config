return {
  {
    "mason-org/mason.nvim",

    ---@module "mason"
    ---@type MasonSettings
    opts = {
      firewall = {
        enabled = true,
      },
      ui = {
        backdrop = 100,
      },
    },
    keys = {
      { "<leader>im", "<cmd>Mason<CR>", desc = "Open Mason" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },

    ---@module "mason-tool-installer"
    ---@type MasonToolInstallerSettings
    opts = {
      ensure_installed = {
        -- bash stuff
        "bash-language-server", -- LSP
        "shellcheck", -- Linter
        "shfmt", -- Formatter

        -- lua stuff
        "lua-language-server", -- LSP
        "selene", -- Linter
        "stylua", -- Formatter

        -- python stuff
        "basedpyright", -- LSP
        "ruff", -- Linter and Formatter
        "vulture", -- Linter

        -- js and ts stuff
        "typescript-language-server", -- LSP
        "prettier", -- Formatter

        -- markdown stuff
        "markdown-oxide", -- LSP
      },

      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 24,

      integrations = {
        ["mason-lspconfig"] = false,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
      },
    },
  },
}
