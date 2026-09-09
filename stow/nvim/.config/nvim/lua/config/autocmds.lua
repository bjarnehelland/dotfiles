local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  desc = 'Highlight selection on yank',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Restore cursor to where it was the last time the file was edited (from shada).
-- pcall: the saved column may be past the end of a line that has since shrunk.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('restore_cursor'),
  desc = 'Restore cursor position from previous session',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.schedule(function()
        vim.cmd('normal! zz')
      end)
    end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('resize_splits'),
  desc = 'Equalize splits when the terminal is resized',
  command = 'wincmd =',
})

-- Don't continue comments on <CR> / o / O. Runs after the ftplugin, so its
-- formatoptions additions (e.g. lua's +=cro) are overridden.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('no_auto_comment'),
  desc = 'Disable automatic comment continuation',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Remove plugins from disk that are no longer in vim.pack.add() specs
vim.api.nvim_create_user_command('PackClean', function()
  local inactive = vim.iter(vim.pack.get())
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()
  if #inactive == 0 then
    return vim.notify('No inactive plugins to remove', vim.log.levels.INFO)
  end
  vim.pack.del(inactive)
  vim.notify('Removed: ' .. table.concat(inactive, ', '), vim.log.levels.INFO)
end, { desc = 'Remove plugins not in vim.pack.add() specs' })
