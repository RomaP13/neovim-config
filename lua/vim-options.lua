vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")

-- vim.cmd("set clipboard+=unnamedplus")

vim.opt.mouse = "a"
-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 20

vim.g.have_nerd_font = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Coc extensions
vim.g.coc_global_extensions = {
  "coc-snippets",
  -- Languages
  "coc-pyright",
  "coc-sumneko-lua",
  "coc-clangd",

  -- Front-End stuff
  "coc-html",
  "coc-htmldjango",
  "coc-css",

  -- Other stuff
  "coc-json",
  "coc-docker",
}

-- Window layout for undotree
vim.g.undotree_WindowLayout = 4

-- Snippets
-- Use <C-w> for jump to next placeholder
vim.g.coc_snippet_next = '<c-w>'

-- Use <C-s> for jump to previous placeholder
vim.g.coc_snippet_prev = '<c-s>'
