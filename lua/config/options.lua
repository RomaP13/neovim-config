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
vim.opt.updatetime = 200

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 20

-- Highlight the text line of the cursor
vim.opt.cursorline = true

-- Enable 24-bit color
vim.opt.termguicolors = true

vim.g.have_nerd_font = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Window layout for undotree
vim.g.undotree_WindowLayout = 4

vim.g.foldmethod = "manual"
vim.g.foldcolumn = 1

vim.opt.conceallevel = 0
vim.opt.backupcopy = "yes"
