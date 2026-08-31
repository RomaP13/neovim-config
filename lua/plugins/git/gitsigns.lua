return {
  "lewis6991/gitsigns.nvim",

  ---@module "gitsigns"
  ---@type Gitsigns.config
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    preview_config = {
      border = "rounded",
    },

    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buf = bufnr, desc = desc, silent = true })
      end

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Gitsigns: Next Hunk")
      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Gitsigns: Previous Hunk")

      map("n", "]C", function()
        gitsigns.nav_hunk("first")
      end, "Gitsigns: First Hunk")
      map("n", "[C", function()
        gitsigns.nav_hunk("last")
      end, "Gitsigns: Last Hunk")

      -- Actions
      map("n", "<leader>hs", gitsigns.stage_hunk, "Gitsigns: Stage Hunk")
      map("x", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Gitsigns: Stage Hunk")

      map("n", "<leader>hr", gitsigns.reset_hunk, "Gitsigns: Reset Hunk")
      map("x", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Gitsigns: Reset Hunk")

      map("n", "<leader>hp", gitsigns.preview_hunk, "Gitsigns: Preview Hunk")
      map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Gitsigns: Preview Hunk Inline")

      map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, "Gitsigns: Blame Line")

      map("n", "<leader>hd", gitsigns.diffthis, "Gitsigns: Diff This")
      map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end, "Gitsigns: Diff This ~")
    end,
  },
}
