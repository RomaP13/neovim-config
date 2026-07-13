return {
  "Exafunction/windsurf.vim",
  enabled = true,
  event = "BufEnter",
  config = function()
    local map = vim.keymap.set

    vim.g.codeium_disable_bindings = 1

    vim.g.codeium_filetypes_disabled_by_default = true
    vim.g.codeium_filetypes = {
      lua = true,
      python = true,
      javascript = true,
      typescript = true,
      markdown = true,
    }

    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("CodeiumMarkdownControl", { clear = true }),
      callback = function()
        if vim.bo.filetype == "markdown" then
          if vim.fn.expand("%:t") ~= "README.md" then
            vim.cmd("CodeiumDisable")
          else
            vim.cmd("CodeiumEnable")
          end
        end
      end,
    })

    map("i", "<C-u>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
    map("i", "<M-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })
    map("i", "<M-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })
    map("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })

    map("n", "<leader>ct", ":CodeiumToggle<CR>", { silent = true, desc = "Toggle Codeium" })
  end,
}
