-- Plugins via native vim.pack, no plugin manager needed.

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig', -- ready-made LSP server configs
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  -- The whole mini.nvim collection: 46 modules, all require-on-demand (the repo
  -- ships no plugin/ dir), so unused ones cost nothing at startup. Using
  -- mini.pick, mini.clue, mini.files, mini.diff, mini.git, mini.statusline,
  -- mini.pairs, mini.surround — plus its colors/ (miniwinter, minicyan, ...).
  -- Pinned to `stable`; `main` is where breaking changes land.
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },
})

require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.diagnostics')
require('plugins.mini')
require('plugins.pick')
require('plugins.clue')
require('plugins.files')
