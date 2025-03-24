return {
  "epwalsh/obsidian.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    completion = {
      nvim_cmp = false, -- disable!
    },

    workspaces = {
      {
        name = "Life",
        path = "~/Obsidian/My Life",
      },
    },

    disable_frontmatter = true,

    -- Optional, alternatively you can customize the frontmatter data.
    -- ---@return table
    -- note_frontmatter_func = function(note)
    --   local out = {}

    --   -- `note.metadata` contains any manually added fields in the frontmatter.
    --   -- So here we just make sure those fields are kept in the frontmatter.
    --   if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
    --     for k, v in pairs(note.metadata) do
    --       out[k] = v
    --     end
    --   end

    --   return out
    -- end,
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    -- HACK: fix error, disable completion.nvim_cmp option, manually register sources
    local cmp = require("cmp")
    cmp.register_source("obsidian", require("cmp_obsidian").new())
    cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
    cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
  end,
}
