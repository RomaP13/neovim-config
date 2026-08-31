vim.g.mapleader = " "

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.undofile = true

-- Searches ignore case
vim.opt.ignorecase = true
-- If search contains uppercase, search becomes case-sensitive
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
vim.opt.cursorline = false

-- Enable 24-bit color
vim.opt.termguicolors = true

vim.g.have_nerd_font = true

-- Use Oil for file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.conceallevel = 0
vim.opt.backupcopy = "yes"

vim.opt.winborder = "rounded"

vim.o.termsync = false
