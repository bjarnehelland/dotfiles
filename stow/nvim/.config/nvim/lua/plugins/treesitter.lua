-- No-op for parsers already on disk, so this is cheap on every startup.
require('nvim-treesitter').install({
  -- editing
  'lua', 'luadoc', 'luap', 'vim', 'vimdoc', 'query',
  'typescript', 'tsx', 'javascript', 'jsdoc',
  'json', 'json5', 'yaml', 'toml',
  'html', 'css',
  'markdown', 'markdown_inline',
  'bash', 'dockerfile',
  -- git
  'diff', 'gitcommit',
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Treesitter highlighting and indentation',
  group = vim.api.nvim_create_augroup('treesitter_filetype', { clear = true }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    -- Experimental per nvim-treesitter README, but better than the legacy
    -- indent scripts for tsx/jsx. Drop this line to fall back to those.
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Rebuild parsers when the plugin itself is updated via vim.pack.update();
-- parser ABI is tied to the plugin version, so a bare update leaves them stale.
-- (vim.pack.add() only fires 'install' events, and fresh installs are covered
-- by the install() call above, so registering this after add() is fine.)
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Rebuild treesitter parsers after nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('treesitter_pack_update', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      -- Updates can happen while the plugin is unloaded, so :TSUpdate may not exist yet
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})
