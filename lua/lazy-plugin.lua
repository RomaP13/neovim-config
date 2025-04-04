local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  ui = {
    border = "rounded",
  },
  change_detection = {
    notify = false,
  },
})

vim.keymap.set("n", "<leader>lz", ":Lazy<CR>", { noremap = true, silent = true, desc = "Open Lazy.nvim" })
