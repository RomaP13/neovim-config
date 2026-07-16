local map = vim.keymap.set

----------------------------------------------------------------------------------------------------
-- General
----------------------------------------------------------------------------------------------------

map("n", "<C-s>", "<cmd>w!<CR>", { desc = "Save file" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

----------------------------------------------------------------------------------------------------
-- Macros
----------------------------------------------------------------------------------------------------

map("n", "<leader>q", "q", { desc = "Record macro" })
map("n", "q", "<Nop>")

----------------------------------------------------------------------------------------------------
-- Selection & Clipboard
----------------------------------------------------------------------------------------------------

map("n", "<leader>va", "ggVG", { desc = "Select entire file" })

map("n", "<leader>ya", function()
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.") -- Get path relative to CWD
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") -- Get all lines in the current buffer
  local full_copy = ("%s:\n%s"):format(filepath, content) -- Sets the system clipboard
  vim.fn.setreg("+", full_copy) -- Sets the system clipboard
  vim.notify("Copied: " .. filepath, vim.log.levels.INFO)
end, { desc = "Copy file path and contents" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to the system clipboard" })

map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste after cursor from system clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before cursor from system clipboard" })

map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

----------------------------------------------------------------------------------------------------
-- Insert mode
----------------------------------------------------------------------------------------------------

-- Quick movement in insert mode
map("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-k>", "<Up>", { desc = "Move cursor up" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right" })

----------------------------------------------------------------------------------------------------
-- Buffers
----------------------------------------------------------------------------------------------------

-- Buffer navigation
map("n", "<leader>bp", "<cmd>bprev<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Buffer unloading
map("n", "<leader>bd", "<cmd>bd | bprev<CR>", { desc = "Delete current buffer" })

----------------------------------------------------------------------------------------------------
-- Windows
----------------------------------------------------------------------------------------------------

map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })

----------------------------------------------------------------------------------------------------
-- Visual mode
----------------------------------------------------------------------------------------------------

map("v", "J", "<cmd>m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", "<cmd>m '<-2<CR>gv=gv", { desc = "Move selection up" })

----------------------------------------------------------------------------------------------------
-- Search & Replace
----------------------------------------------------------------------------------------------------

map("n", "<leader>'", "<cmd>%s/'/\"/g<CR>", { desc = "Replace all single quotes with double quotes" })

----------------------------------------------------------------------------------------------------
-- Quickfix
----------------------------------------------------------------------------------------------------

map("n", "<M-]>", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "<M-[>", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })

map("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
