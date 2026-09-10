-- File explorer: edit a directory like a buffer, :w applies the changes.
require('oil').setup({
  skip_confirm_for_simple_edits = true,
  win_options = { signcolumn = 'yes:2' }, -- room for oil-git-status signs
  view_options = { show_hidden = true },
  watch_for_changes = true,
  keymaps = { ['q'] = 'actions.close' },
})
require('oil-git-status').setup({ show_ignored = false })

-- Open at the current file's directory (`-` goes up, <CR> opens, q closes)
vim.keymap.set('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'File explorer' })

-- Same, but rooted at the project: nearest .git above the current file, else cwd
vim.keymap.set('n', '<leader>E', function()
  require('oil').open(vim.fs.root(0, '.git') or vim.uv.cwd())
end, { desc = 'File explorer (project root)' })
