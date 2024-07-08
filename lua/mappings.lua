local map = vim.keymap.set

map("n", "<C-s>", "<cmd>w<CR>", { desc = "File Save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "File Copy whole" })
map("n", "<C-u>", "<cmd>source<CR>", { desc = "Souce File" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("i", "jk", "<Esc>")

map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
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

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("x", "<leader>p", '"_dP')

-- Comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Comment Toggle" }
)

vim.api.nvim_set_keymap("v", "<C-r>", ":%s/<C-r>h//g<CR>", {})

map("n", "<leader>'", "<cmd>%s/'/\"/g<CR>", {})

map("n", "<C-q>", "<cmd>wq<CR>", {})

-- Snippets
local opts = { noremap = true, silent = true }
map("i", "<C-w>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
map("s", "<C-w>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
map("i", "<C-s>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
map("s", "<C-s>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
