local map = vim.keymap.set
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", {})
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", {})

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
