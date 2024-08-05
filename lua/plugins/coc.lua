return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      local map = vim.keymap.set

      -- Use <c-space> to trigger completion
      map("i", "<C-Space>", "coc#refresh()", {silent = true, expr = true})

      -- Diasnostics
      map("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
      map("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

      -- GoTo code navigation
      map("n", "gd", "<Plug>(coc-definition)", {silent = true})
      map("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
      map("n", "gi", "<Plug>(coc-implementation)", {silent = true})
      map("n", "gr", "<Plug>(coc-references)", {silent = true})

      -- Use K to show documentation in preview window
      function _G.show_docs()
          local cw = vim.fn.expand('<cword>')
          if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
              vim.api.nvim_command('h ' .. cw)
          elseif vim.api.nvim_eval('coc#rpc#ready()') then
              vim.fn.CocActionAsync('doHover')
          else
              vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
          end
      end
      map("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

      -- Symbol renaming
      map("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

      map("i", "<CR>", "coc#pum#visible() ? '\\<C-y>' : '\\<CR>'", {silent = true, expr = true})

      -- Add `:Format` command to format current buffer
      vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
      map("n", "<leader>fm", "<cmd>Format<CR>", {})

      -- Add `:OR` command for organize imports of the current buffer
      vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
      map("n", "<leader>or", "<cmd>OR<CR>", {})
    end,
  },
}
