-- File explorer
require('mini.files').setup({
  mappings = { go_in_plus = '<CR>' }, -- Enter opens file/dir ('l' still works)
})

-- Open at current file, toggle closed if already open
vim.keymap.set('n', '<leader>e', function()
  local mf = require('mini.files')
  if mf.close() then return end
  local path = vim.api.nvim_buf_get_name(0)
  mf.open(vim.uv.fs_stat(path) and path or nil)
end, { desc = 'File explorer' })

-- Same, but rooted at the project: nearest .git above the current file, else cwd
vim.keymap.set('n', '<leader>E', function()
  local mf = require('mini.files')
  if mf.close() then return end
  mf.open(vim.fs.root(0, '.git') or vim.uv.cwd())
end, { desc = 'File explorer (project root)' })
