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
    for _, group in ipairs({ 'Normal', 'NormalNC', 'NormalFloat', 'FloatBorder', 'FloatTitle', 'SignColumn', 'EndOfBuffer' }) do
      -- Resolve links first: NormalFloat & friends are `link = Pmenu`, and
      -- nvim_set_hl ignores every other attribute when `link` is present.
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      hl.bg, hl.ctermbg = nil, nil
      vim.api.nvim_set_hl(0, group, hl)
    end
    local palette = accents[vim.o.background]
    for _, mode in ipairs({ 'Normal', 'Insert', 'Visual', 'Replace', 'Command', 'Other' }) do
      vim.api.nvim_set_hl(0, 'MiniStatuslineMode' .. mode, { fg = palette.text, bg = palette[mode], bold = true })
    end
  end,
})
vim.cmd.colorscheme('catppuccin')
