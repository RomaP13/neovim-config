local M = {}

--- Retrieves the selected lines from the current buffer in visual mode
---@return string[]|nil
M.get_visual_selection = function()
  local s_start = vim.fn.getpos("'<") -- Get start position of the visual selection
  local s_end = vim.fn.getpos("'>") -- Get end position of the visual selection
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1 -- Calculate the number of selected lines
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false) -- Get lines from the buffer

  if #lines == 0 then
    return nil -- No selection made
  end

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

return M
