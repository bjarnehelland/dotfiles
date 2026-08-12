-- Minimal native Neovim 0.12 setup
-- Run with: NVIM_APPNAME=nvim_native nvim

-- Byte-compilation cache for Lua modules. Must be first: only requires that
-- happen after this call go through the cache.
vim.loader.enable()

-- ── Options ──────────────────────────────────────────────────────
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.undofile = true
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menuone,noselect,fuzzy,popup'
vim.o.winborder = 'rounded'

vim.o.scrolloff = 8
vim.o.confirm = true
vim.o.inccommand = 'split'
vim.o.list = true
vim.o.listchars = 'tab:  ,trail:·,nbsp:␣'

-- ── Plugins (native vim.pack, no plugin manager needed) ──────────
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

-- ── Colorscheme ──────────────────────────────────────────────────
-- catppuccin ships with Neovim (:h catppuccin), mocha when background=dark and
-- latte when light. It has no options, so transparency means clearing the
-- background off the canvas groups by hand; contrast groups (Pmenu, Visual,
-- CursorLine, StatusLine) keep theirs or they'd become unreadable.
-- Re-applied on ColorScheme so it survives a `:colorscheme catppuccin` reload.
--
-- mini.nvim's own groups all link to standard ones, so they come along for free
-- — except mini.statusline's mode block, whose defaults link to whatever is at
-- hand (Cursor, DiffAdd, IncSearch). Point those at real palette accents.
local accents = {
  -- mocha / latte, matching the hexes the bundled colorscheme uses
  dark = { text = '#181825', Normal = '#89b4fa', Insert = '#a6e3a1', Visual = '#cba6f7', Replace = '#f38ba8', Command = '#fab387', Other = '#94e2d5' },
  light = { text = '#eff1f5', Normal = '#1e66f5', Insert = '#40a02b', Visual = '#8839ef', Replace = '#d20f39', Command = '#fe640b', Other = '#179299' },
}

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'catppuccin',
  callback = function()
    for _, group in ipairs({ 'Normal', 'NormalNC', 'NormalFloat', 'SignColumn', 'EndOfBuffer' }) do
      vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', vim.api.nvim_get_hl(0, { name = group }), { bg = 'NONE', ctermbg = 'NONE' }))
    end
    local palette = accents[vim.o.background]
    for _, mode in ipairs({ 'Normal', 'Insert', 'Visual', 'Replace', 'Command', 'Other' }) do
      vim.api.nvim_set_hl(0, 'MiniStatuslineMode' .. mode, { fg = palette.text, bg = palette[mode], bold = true })
    end
  end,
})
vim.cmd.colorscheme('catppuccin')

-- ── Treesitter ───────────────────────────────────────────────────
require('nvim-treesitter').install({ 'lua', 'typescript', 'tsx', 'javascript', 'json', 'yaml' })
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- ── LSP ──────────────────────────────────────────────────────────
-- Servers must be installed on your system:
--   brew install lua-language-server typescript
-- brew's typescript is 7.x (native Go port) whose tsc has a built-in LSP;
-- point lspconfig's tsgo config at it.
vim.lsp.config('tsgo', { cmd = { 'tsc', '--lsp', '--stdio' } })
-- Teach lua_ls about the Neovim runtime (vim global, API completion)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, '${3rd}/luv/library' },
      },
    },
  },
})
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

-- ── Picker ───────────────────────────────────────────────────────
local pick = require('mini.pick')
pick.setup({
  source = {
    -- Truncate long paths from the left so the filename stays visible
    show = function(buf_id, items, query)
      local state = pick.get_picker_state()
      local width = state and vim.api.nvim_win_get_width(state.windows.main) or vim.o.columns
      width = width - 3
      local shown = vim.tbl_map(function(item)
        local text = type(item) == 'string' and item or (item.text or item.path or '')
        if vim.fn.strdisplaywidth(text) > width then
          text = '…' .. text:sub(#text - width + 2)
        end
        return text
      end, items)
      pick.default_show(buf_id, shown, query)
    end,
  },
})
vim.keymap.set('n', '<leader>f', '<cmd>Pick files<cr>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', '<cmd>Pick grep_live<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>b', '<cmd>Pick buffers<cr>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>h', '<cmd>Pick help<cr>', { desc = 'Help tags' })

-- ── Keymap hints ─────────────────────────────────────────────────
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = { delay = 300, config = { width = 'auto' } },
})

-- ── Git, statusline, editing helpers ─────────────────────────────
require('mini.diff').setup()
require('mini.git').setup()
require('mini.statusline').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
vim.keymap.set('n', '<leader>go', function()
  require('mini.diff').toggle_overlay()
end, { desc = 'Toggle git diff overlay' })

-- ── Misc keymaps ─────────────────────────────────────────────────
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Move between splits with Ctrl-h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })

-- Close buffer without collapsing the window layout
vim.keymap.set('n', '<leader>x', function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    return vim.notify('Unsaved changes (use :w, or :bd! to discard)', vim.log.levels.WARN)
  end
  local fallback
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= buf and vim.fn.buflisted(b) == 1 then fallback = b end
  end
  local alt = vim.fn.bufnr('#')
  if alt > 0 and alt ~= buf and vim.fn.buflisted(alt) == 1 then fallback = alt end
  fallback = fallback or vim.api.nvim_create_buf(true, false)
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_buf(win, fallback)
  end
  vim.api.nvim_buf_delete(buf, {})
end, { desc = 'Close buffer (keep window)' })
-- File explorer: open at current file, toggle closed if already open
require('mini.files').setup({
  mappings = { go_in_plus = '<CR>' }, -- Enter opens file/dir ('l' still works)
})
vim.keymap.set('n', '<leader>e', function()
  local mf = require('mini.files')
  if mf.close() then return end
  local path = vim.api.nvim_buf_get_name(0)
  mf.open(vim.uv.fs_stat(path) and path or nil)
end, { desc = 'File explorer' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
})
