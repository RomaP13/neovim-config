return {
  "XXiaoA/atone.nvim",
  cmd = "Atone",

  ---@module "atone"
  ---@type AtoneConfig
  opts = {
    layout = {
      direction = "right",
    },
    diff_cur_node = {
      width = 0.6,
    },
    ui = {
      border = "rounded",
    },
  },

  keys = {
    {
      "<leader>u",
      "<cmd>Atone toggle<CR>",
      desc = "Toggle Untotree (Atone)",
    },
  },
}
