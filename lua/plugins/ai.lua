return {
  "Exafunction/codeium.vim",
  enabled = true,
  event = "BufEnter",
  config = function()
    local map = vim.keymap.set

    vim.g.codeium_disable_bindings = 1

    map("i", "<C-u>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
    map("i", "<c-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true, silent = true })
    map("i", "<c-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true, silent = true })
    map("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true, silent = true })
  end,
}
