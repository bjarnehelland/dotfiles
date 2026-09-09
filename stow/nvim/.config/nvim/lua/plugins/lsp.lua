-- Servers must be installed on your system:
--   brew install lua-language-server typescript
--
-- Per-server overrides go in one of two places (:h lsp-config):
--   lsp/<name>.lua        for keys nvim-lspconfig does NOT set (e.g. lua_ls settings).
--                         All lsp/ files on the runtimepath are merged, later wins,
--                         and lspconfig's come after ours — so we can add, not replace.
--   vim.lsp.config() here for keys lspconfig DOES set; these beat every lsp/ file.

-- brew's typescript is 7.x (native Go port) whose tsc has a built-in LSP;
-- lspconfig's tsgo config wants a `tsgo` binary, so point it at tsc instead.
vim.lsp.config('tsgo', { cmd = { 'tsc', '--lsp', '--stdio' } })

vim.lsp.enable({ 'lua_ls', 'tsgo' })

-- Built-in autocompletion when an LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
