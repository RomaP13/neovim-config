local text_utils = require("utils.text_utils")
local map = vim.keymap.set

-- Delete a word by pressing Ctrl + Backspace
map("i", "<C-BS>", "<C-w>")
map("c", "<C-BS>", "<C-w>")
map("i", "<C-H>", "<C-w>")
map("c", "<C-H>", "<C-w>")

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "File Copy whole" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("i", "jk", "<Esc>")

map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")

map("n", "<C-a>", ":bprev<CR>", { noremap = true, silent = true })
map("n", "<C-d>", ":bnext<CR>", { noremap = true, silent = true })

map("i", "<C-k>", "<Up>")

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Move line in the visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.api.nvim_set_keymap("v", "<C-r>", ":%s/<C-r>h//g<CR>", {})

map("n", "<leader>'", "<cmd>%s/'/\"/g<CR>", {})

map("n", "<C-q>", "<cmd>q<CR>", {})

-- Yanking
map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

map("n", "<leader>p", '"+p', { desc = "Paste after cursor from clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste before cursor from clipboard" })
map("v", "<leader>p", '"+p', { desc = "Paste after cursor from clipboard" })
map("v", "<leader>P", '"+P', { desc = "Paste before cursor from clipboard" })


map("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
map("v", "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Join selected paragraphs and copy them to the clipboard
map("v", "<leader>jp", text_utils.join_paragraphs, { noremap = true, silent = true })
