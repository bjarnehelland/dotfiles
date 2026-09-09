local pick = require('mini.pick')
pick.setup({
  source = {
    -- Truncate long paths from the left so the filename stays visible
    show = function(buf_id, items, query)
      local state = pick.get_picker_state()
      local width = state and vim.api.nvim_win_get_width(state.windows.main) or vim.o.columns
      width = width - 3
      local shown = vim.tbl_map(function(item)
        local text = type(item) == 'string' and item or (item.text or item.path or '')
        if vim.fn.strdisplaywidth(text) > width then
          text = '…' .. text:sub(#text - width + 2)
        end
        return text
      end, items)
      pick.default_show(buf_id, shown, query)
    end,
  },
})

vim.keymap.set('n', '<leader>f', '<cmd>Pick files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', '<cmd>Pick grep_live<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>b', '<cmd>Pick buffers<cr>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>h', '<cmd>Pick help<cr>', { desc = 'Help tags' })
