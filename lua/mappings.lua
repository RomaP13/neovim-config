local map = vim.keymap.set

-- Delete a word by pressing Ctrl + Backspace
map("i", "<C-BS>", "<C-w>")
map("c", "<C-BS>", "<C-w>")
map("i", "<C-H>", "<C-w>")
map("c", "<C-H>", "<C-w>")

-- Save file forcefully even when 'readonly' is set or
-- there is another reason why writing was refused.
map("n", "<C-s>", "<cmd>w!<CR>", { desc = "File Save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "File Copy whole" })

-- Remove search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Go to normal mode
map("i", "jk", "<Esc>")

-- Quick movement in insert mode
map("i", "<C-k>", "<Up>")
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")

-- Buffer navigation
map("n", "<C-a>", ":bprev<CR>", { noremap = true, silent = true })
map("n", "<C-d>", ":bnext<CR>", { noremap = true, silent = true })

-- Buffer unloading
-- TODO: Think about the better way of managing buffers
map("n", "<leader>bd", ":bd | bprev<CR>", { silent = true, desc = "Unload buffer and delete it from the buffer list" })

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move line in the visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Replace all single quotes(') with double(")
map("n", "<leader>'", "<cmd>%s/'/\"/g<CR>", { silent = true })

-- Yanking to the system clipboard
map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })

-- Pasting from the system clipboard
map("n", "<leader>p", '"+p', { desc = "Paste after cursor from clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste before cursor from clipboard" })
map("v", "<leader>p", '"+p', { desc = "Paste after cursor from clipboard" })
map("v", "<leader>P", '"+P', { desc = "Paste before cursor from clipboard" })

-- Deleting without yanking
map("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
map("v", "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Quickfix
map("n", "<C-]>", ":cnext<CR>", { silent = true })
map("n", "<C-[>", ":cprev<CR>", { silent = true })
map("n", "<leader>co", ":copen<CR>", { silent = true })
map("n", "<leader>cc", ":cclose<CR>", { silent = true })

-- Join selected paragraphs and copy them to the clipboard
map("v", "<leader>jp", ":lua require('utils.text_utils').join_paragraphs()<CR>", { noremap = true, silent = true })

-- Notes:
-- Directly calling require('utils.text_utils').join_paragraphs() caused inconsistent behavior,
-- particularly with visual selections not being handled correctly. Using <cmd>lua also led to
-- similar issues, likely due to differences in how visual mode transitions are handled.
-- To ensure reliable behavior, we use :lua to call the function in command-line mode.
