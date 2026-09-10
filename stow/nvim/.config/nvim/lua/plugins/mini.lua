-- mini.nvim modules; all need no more than setup().

-- Git
require('mini.diff').setup()
require('mini.git').setup()
vim.keymap.set('n', '<leader>go', function()
  require('mini.diff').toggle_overlay()
end, { desc = 'Toggle git diff overlay' })

-- Statusline, and a tabline listing open buffers
require('mini.statusline').setup()
require('mini.tabline').setup()

-- Editing helpers
require('mini.pairs').setup()
require('mini.surround').setup()
