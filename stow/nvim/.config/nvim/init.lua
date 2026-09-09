-- Minimal native Neovim 0.12 setup: vim.pack, built-in LSP, mini.nvim.
-- Layout:
--   lua/config/   options, autocmds, keymaps (no plugins involved)
--   lua/plugins/  vim.pack.add() plus one file per plugin/feature
--   lsp/          per-server vim.lsp.config overrides, merged with nvim-lspconfig

-- Byte-compilation cache for Lua modules. Must be first: only requires that
-- happen after this call go through the cache.
vim.loader.enable()

require('config')
require('plugins')
