require('nvim-treesitter').install({ 'lua', 'typescript', 'tsx', 'javascript', 'json', 'yaml' })

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
