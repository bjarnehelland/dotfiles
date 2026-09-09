-- Plugins via native vim.pack, no plugin manager needed.

-- Rebuild treesitter parsers when the plugin itself changes; parser ABI is
-- tied to the plugin version, so a bare update leaves them stale.
-- Must be registered *before* vim.pack.add(), which fires PackChanged inline.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      -- Updates can happen while the plugin is unloaded, so :TSUpdate may not exist yet
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

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
