return {
  {
    "honza/vim-snippets"
  },
  {
    "mlaursen/vim-react-snippets"
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      local map = vim.keymap.set

      -- Use <C-space> to trigger completion
      map("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true })
      -- Use <C-r> to trigger snippets
      map("i", "<C-r>", "<Plug>(coc-snippets-expand-jump)")

      -- Diasnostics
      map("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
      map("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

      -- GoTo code navigation
      map("n", "gd", "<Plug>(coc-definition)", { silent = true })
      map("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      map("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      map("n", "gr", "<Plug>(coc-references)", { silent = true })

      -- Use K to show documentation in preview window
      function _G.show_docs()
        local cw = vim.fn.expand('<cword>')
        if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
          vim.api.nvim_command('h ' .. cw)
        elseif vim.api.nvim_eval('coc#rpc#ready()') then
          vim.fn.CocActionAsync('doHover')
        else
          vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
        end
      end

      -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
      vim.api.nvim_create_augroup("CocGroup", {})
      vim.api.nvim_create_autocmd("CursorHold", {
        group = "CocGroup",
        command = "silent call CocActionAsync('highlight')",
        desc = "Highlight symbol under cursor on CursorHold"
      })

      -- Remap <C-f> and <C-b> to scroll float windows/popups
      ---@diagnostic disable-next-line: redefined-local
      local opts = { silent = true, nowait = true, expr = true }
      map("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      map("n", "<C-g>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
      map("i", "<C-f>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
      map("i", "<C-g>",
        'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
      map("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
      map("v", "<C-g>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

      map("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

      -- Symbol renaming
      map("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

      map("i", "<CR>", "coc#pum#visible() ? '\\<C-y>' : '\\<CR>'", { silent = true, expr = true })

      -- Formatting selected code
      map("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
      map("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
      map("n", "<leader>fm", "<cmd>Format<CR>", {})

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
      map("n", "<leader>or", "<cmd>OR<CR>", {})

      -- Show all diagnostics
      map("n", "<leader>a", ":<C-u>CocList --normal diagnostics<cr>", { silent = true, nowait = true })

      -- Restart server
      map("n", "<leader>cr", ":CocRestart<CR>", { silent = true })
    end,
  },
}
