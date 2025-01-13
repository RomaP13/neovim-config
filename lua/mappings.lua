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

-- Function to retrieve the selected lines from the current buffer in visual mode
local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")                                          -- Get start position of the visual selection
  local s_end = vim.fn.getpos("'>")                                            -- Get end position of the visual selection
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1                          -- Calculate the number of selected lines
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false) -- Get lines from the buffer

  -- Trim the first line from the start column of the visual selection
  lines[1] = string.sub(lines[1], s_start[3], -1)

  if n_lines == 1 then
    -- If the selection is on one line, trim the selected text within that line
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    -- If the selection spans multiple lines, trim the last line up to the end column
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end

  return lines
end


-- Function to join paragraphs and copy them to the clipboard
function JoinParagraphs()
  local lines = get_visual_selection()

  local processed_lines = {}
  local paragraph = {}

  for i, line in ipairs(lines) do
    -- Strip leading and trailing whitespace like Python's strip()
    line = string.gsub(line, "^%s*(.-)%s*$", "%1")
    if line ~= "" then
      table.insert(paragraph, line)
    else
      -- If we encounter an empty line, it marks the end of a paragraph
      if #paragraph ~= 0 then
        table.insert(processed_lines, table.concat(paragraph, " "))
        paragraph = {}
      end
    end
  end

  -- After the loop, check if there's any remaining paragraph
  -- that needs to be processed
  if #paragraph ~= 0 then
    table.insert(processed_lines, table.concat(paragraph, " "))
  end

  -- Copy the processed lines to the system clipboard
  vim.fn.setreg("+", table.concat(processed_lines, "\n"))

  -- Notify the user that the text has been copied
  print("Modified selection copied to the system clipboard.")
end

-- Create a mapping to call the function in visual mode
vim.api.nvim_set_keymap("v", "<leader>jp", ":lua JoinParagraphs()<CR>", { noremap = true, silent = true })
