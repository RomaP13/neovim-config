local function get_priority_files()
  local path = vim.fn.expand("~/.config/nvim/rg_priority.txt") -- File with prioritized paths
  local files = {}

  -- Read the file line by line
  for line in io.lines(path) do
    table.insert(files, line)
  end

  return files
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    "hide", -- Enable hide profile for better resume functionality
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
    },
    files = {
      fd_opts = [[--type f --hidden --follow 
        --exclude .git 
        --exclude .venv 
        --exclude .ruff_cache 
        --exclude __pycache__ 
        --exclude .pytest_cache]],
    },
    git = {
      files = {
        cmd = "git ls-files --cached --others --exclude-standard",
      },
    },
  },
  keys = {
    -- Buffers and Files
    { "<leader>fb", ":FzfLua buffers<CR>", desc = "Buffers", silent = true },
    { "<leader>ff", ":FzfLua files<CR>", desc = "Find files", silent = true },
    { "<leader>fo", ":FzfLua oldfiles<CR>", desc = "Old files", silent = true },

    -- Search
    { "<leader>fw", ":FzfLua grep_cword<CR>", desc = "Grep", silent = true },
    { "<leader>fg", ":FzfLua live_grep<CR>", desc = "Live grep", silent = true },

    -- Git
    { "<leader>gf", ":FzfLua git_files<CR>", desc = "Git files", silent = true },
    { "<leader>gs", ":FzfLua git_status<CR>", desc = "Git status", silent = true },

    -- Misc
    { "<leader>fr", ":FzfLua resume<CR>", desc = "Resume", silent = true },
    { "<leader>fz", ":FzfLua builtin<CR>", desc = "Builtin", silent = true },
    { "<leader>fh", ":FzfLua helptags<CR>", desc = "Help tags", silent = true },
    { "<leader>ch", ":FzfLua command_history<CR>", desc = "Command history", silent = true },
    { "<leader>km", ":FzfLua keymaps<CR>", desc = "Keymaps", silent = true },
    { "<leader>sg", ":FzfLua spell_suggest<CR>", desc = "Spell suggest", silent = true },

    -- Custom live grep with priority files
    {
      "<leader>fi",
      function()
        require("fzf-lua").live_grep({
          search_paths = get_priority_files(),
          rg_opts = [[--color=never --hidden --follow --sort=path]],
        })
      end,
      desc = "Live grep priority files",
      silent = true,
    },
  },
  config = function(_, opts)
    local actions = require("fzf-lua").actions
    opts.actions = {
      files = {
        ["enter"] = actions.file_edit_or_qf,
        ["alt-q"] = { fn = actions.file_sel_to_qf, prefix = "select-all" },
      },
    }
    require("fzf-lua").setup(opts)
  end,
}
