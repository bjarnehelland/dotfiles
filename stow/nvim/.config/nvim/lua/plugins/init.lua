-- Plugins via native vim.pack, no plugin manager needed.

vim.pack.add({
  -- Syntax and editing
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.nvim',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig', -- ready-made LSP server configs
})

-- One file per plugin/feature, alphabetical; none depend on another's order.
require('plugins.clue')
require('plugins.colorscheme')
require('plugins.diagnostics')
require('plugins.files')
require('plugins.lsp')
require('plugins.mini')
require('plugins.pick')
require('plugins.treesitter')
