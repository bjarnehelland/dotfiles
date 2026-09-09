vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { prefix = '●' },
  signs = {
    priority = 200, -- above mini.diff's 199 so diagnostics win the gutter
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
      [vim.diagnostic.severity.HINT] = '󰌵 ',
    },
  },
})

vim.keymap.set('n', '<leader>d', function()
  local enabled = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(enabled)
  vim.notify('Diagnostics ' .. (enabled and 'on' or 'off'))
end, { desc = 'Toggle diagnostics' })
