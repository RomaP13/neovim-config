local theme = require("core.theme")

local fd_excludes =
  "--hidden --follow --no-ignore --exclude .git --exclude .venv --exclude .ruff_cache --exclude __pycache__ --exclude .pytest_cache"

local rg_excludes =
  "--hidden --follow --glob '!.git' --glob '!.venv' --glob '!.ruff_cache' --glob '!__pycache__' --glob '!.pytest_cache'"

return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = function()
    local actions = require("fzf-lua").actions

    ---@type fzf-lua.Config
    local opts = {
      -- Setup
      ui_select = {},

      -- Global options
      profile = "hide", -- Enable hide profile for better resume functionality
      winopts = {
        preview = {
          layout = "vertical",
        },
      },
      keymap = {
        builtin = {
          ["<M-Esc>"] = "hide",
          ["<F1>"] = "toggle-help",
          ["<F2>"] = "toggle-fullscreen",

          -- Only valid with the 'builtin' previewer
          ["<F3>"] = "toggle-preview-wrap",
          ["<F4>"] = "toggle-preview",

          -- Rotate preview clockwise/counter-clockwise
          ["<F5>"] = "toggle-preview-ccw",
          ["<F6>"] = "toggle-preview-cw",

          -- Preview page up/down
          ["<M-j>"] = "preview-page-down",
          ["<M-k>"] = "preview-page-up",
          ["<M-n>"] = "preview-down",
          ["<M-p>"] = "preview-up",
        },
        fzf = {
          ["alt-g"] = "first",
          ["alt-b"] = "last",
        },
      },
      actions = {
        files = {
          ["enter"] = actions.file_edit_or_qf,
          ["ctrl-y"] = actions.file_edit_or_qf,
          ["alt-q"] = { fn = actions.file_sel_to_qf, prefix = "select-all" },
        },
      },

      -- Pickers
      files = {
        fd_opts = "--type f " .. fd_excludes,
      },
      colorschemes = {
        actions = {
          ["enter"] = theme.set_global_colorscheme,
        },
      },
      git = {
        files = {
          cmd = "git ls-files --cached --others --exclude-standard",
        },
      },
    }

    return opts
  end,

  keys = {
    -- Buffers and Files
    { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Fzf: Buffers" },
    { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Fzf: Find files" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Fzf: Old files" },
    {
      "<leader>fd",
      function()
        require("fzf-lua").files({
          previewer = false,
          file_icons = false,
          fd_opts = "--type d " .. fd_excludes,
          actions = {
            ["enter"] = function(selected)
              require("oil").open(selected[1])
            end,
          },
        })
      end,
      desc = "Fzf: Find directories",
    },

    -- Search
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_visual()
      end,
      mode = "x",
      desc = "Fzf: Grep visual selection",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_cword()
      end,
      mode = "n",
      desc = "Fzf: Grep current word",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep({
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 "
            .. rg_excludes
            .. " -e",
          rg_glob = true,
        })
      end,
      desc = "Fzf: Live grep",
    },
    {
      "<leader>fG",
      function()
        require("fzf-lua").live_grep({
          hidden = true,
          follow = true,
          no_ignore = false,
        })
      end,
      desc = "Fzf: Live grep (git)",
    },

    -- Git
    { "<leader>gf", "<cmd>FzfLua git_files<CR>", desc = "Fzf: Git files" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Fzf: Git status" },

    -- Misc
    { "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Fzf: Resume" },
    { "<leader>fz", "<cmd>FzfLua builtin<CR>", desc = "Fzf: Builtin commands" },
    { "<leader>fh", "<cmd>FzfLua helptags<CR>", desc = "Fzf: Help tags" },
    { "<leader>fM", "<cmd>FzfLua man_pages<CR>", desc = "Fzf: Man pages" },
    { "<leader>ch", "<cmd>FzfLua colorschemes<CR>", desc = "Fzf: Colorschemes" },
    { "<leader>fH", "<cmd>FzfLua highlights<CR>", desc = "Fzf: Highlight groups" },
    { "<leader>:", "<cmd>FzfLua command_history<CR>", desc = "Fzf: Command history" },
    { "<leader>km", "<cmd>FzfLua keymaps<CR>", desc = "Fzf: Keymaps" },
    { "<leader>sc", "<cmd>FzfLua spellcheck<CR>", desc = "Fzf: Misspelled words in buffer" },
    { "<leader>sg", "<cmd>FzfLua spell_suggest<CR>", desc = "Fzf: Spelling suggestions" },
  },
}
