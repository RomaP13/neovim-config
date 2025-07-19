return {
  "kdheepak/lazygit.nvim",
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
    { "<leader>lg", ":LazyGit<CR>", desc = "LazyGit" },
    { "<leader>lf", ":LazyGitFilter<CR>", desc = "LazyGitFilter" },
    { "<leader>lc", ":LazyGitFilterCurrentFile<CR>", desc = "LazyGitFilterCurrentFile" },
  },
}
