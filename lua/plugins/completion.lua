return {
  "saghen/blink.cmp",

  -- use a release tag to download pre-built binaries
  version = "*",

  opts = {
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-d>"] = { "hide" },
      ["<C-y>"] = { "select_and_accept" },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },

      ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
    },

    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = "rounded",
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        show_documentation = true,
        border = "rounded",
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp"s highlight groups
      -- Useful for when your theme doesn"t support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
