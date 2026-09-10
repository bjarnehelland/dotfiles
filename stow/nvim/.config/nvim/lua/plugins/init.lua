-- Plugins via native vim.pack, no plugin manager needed.

vim.pack.add({
  -- File navigation
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/refractalize/oil-git-status.nvim',
  'https://github.com/nvim-lua/plenary.nvim', -- telescope dependency
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope-frecency.nvim',

  -- Syntax and editing
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.nvim',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig', -- ready-made LSP server configs
})

-- One file per plugin/feature, alphabetical; none depend on another's order.
require('plugins.colorscheme')
require('plugins.diagnostics')
require('plugins.lsp')
require('plugins.mini')
require('plugins.oil')
require('plugins.telescope')
require('plugins.treesitter')
