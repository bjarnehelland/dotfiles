-- Plugin-free keymaps. Plugin keymaps live next to their plugin in lua/plugins/.

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Move between splits with Ctrl-h/j/k/l. These stay inside Neovim: Herdr panes
-- are Cmd+Alt+arrows, so each modifier owns exactly one layer.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })

-- Cycle buffers (]b / [b still work too). Shadows H/L screen-top/bottom jumps.
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })

-- Splits (<leader>s is the telescope search prefix, so horizontal is <leader>-)
vim.keymap.set('n', '<leader>v', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>-', '<cmd>split<cr>', { desc = 'Horizontal split' })

-- Save / quit / restart
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit window' })
vim.keymap.set('n', '<leader>re', '<cmd>restart<cr>', { desc = 'Restart Neovim' })

-- Keep the cursor centered when scrolling and jumping between matches
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next match (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous match (centered)' })

-- Move selected lines up/down and reindent
vim.keymap.set('x', '<C-j>', ":m '>+1<cr>gv=gv", { silent = true, desc = 'Move selection down' })
vim.keymap.set('x', '<C-k>', ":m '<-2<cr>gv=gv", { silent = true, desc = 'Move selection up' })

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

-- Copy a file reference for pasting into AI chats: "path" in normal mode,
-- "path:start:end" in visual mode, plus an optional note typed at the prompt.
local function copy_ref(visual)
  local ref = vim.fn.expand('%:.') -- relative to cwd
  if visual then
    -- '< and '> are only set after leaving visual mode; read the live selection
    local first, last = vim.fn.line('v'), vim.fn.line('.')
    if first > last then first, last = last, first end
    ref = ('%s:%d:%d'):format(ref, first, last)
  end
  local note = vim.fn.input('Prompt (optional): ')
  if note ~= '' then ref = ref .. ' ' .. note end
  vim.fn.setreg('+', ref)
  vim.notify('Copied: ' .. ref)
end
vim.keymap.set('n', '<leader>cp', function() copy_ref(false) end, { desc = 'Copy file path' })
vim.keymap.set('x', '<leader>cp', function() copy_ref(true) end, { desc = 'Copy file path with line range' })
