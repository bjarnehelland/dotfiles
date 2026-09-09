-- mini.nvim modules that need no more than setup(). Bigger ones get their own
-- file: pick.lua, clue.lua, files.lua.

-- Git
require('mini.diff').setup()
require('mini.git').setup()
vim.keymap.set('n', '<leader>go', function()
  require('mini.diff').toggle_overlay()
end, { desc = 'Toggle git diff overlay' })

-- Statusline
require('mini.statusline').setup()

-- Editing helpers
require('mini.pairs').setup()
require('mini.surround').setup()
