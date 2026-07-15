return {
  {
    "saghen/blink.cmp",
    version = "1.*",

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "normal",
      },

      cmdline = {
        completion = { menu = { auto_show = true } },
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

      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },

      keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-d>"] = { "hide" },
        ["<C-y>"] = { "select_and_accept" },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
      },

      signature = {
        enabled = true,
        window = {
          show_documentation = true,
          border = "rounded",
        },
      },

      -- TODO: add some snippets(LuaSnip I guess)
      -- Check that they don't interfere my coding.
      -- Also, find out about 'TODO' snippet. Maybe, I care to add dates for TODO.

      -- TODO: Maybe add dictionary source for markdown files
      -- Completion providers
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          path = {
            opts = {
              show_hidden_files_by_default = true,
            },
          },
        },
      },
    },
  },
}
