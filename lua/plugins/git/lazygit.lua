return {
  "kdheepak/lazygit.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },

  keys = {
    { "<leader>lg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
    { "<leader>lf", "<cmd>LazyGitFilter<CR>", desc = "LazyGitFilter" },
    { "<leader>lc", "<cmd>LazyGitFilterCurrentFile<CR>", desc = "LazyGitFilterCurrentFile" },
    { "<leader>ll", "<cmd>LazyGitLog<CR>", desc = "LazyGitLog" },
  },
}
