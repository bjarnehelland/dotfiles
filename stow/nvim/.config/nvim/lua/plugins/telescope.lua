local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

-- telescope-fzf-native is a C library and must be compiled. vim.pack.add()
-- fires its 'install' event before this file runs, so build on first load if
-- the artifact is missing, and rebuild whenever vim.pack.update() touches it.
local fzf = vim.pack.get({ 'telescope-fzf-native.nvim' })[1]
local function build_fzf(path)
  if vim.fn.executable('make') == 1 then vim.system({ 'make' }, { cwd = path }):wait() end
end
if fzf and vim.uv.fs_stat(fzf.path .. '/build/libfzf.so') == nil then build_fzf(fzf.path) end
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Rebuild telescope-fzf-native after updates',
  group = vim.api.nvim_create_augroup('telescope_fzf_build', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == 'telescope-fzf-native.nvim' and ev.data.kind == 'update' then
      build_fzf(ev.data.path)
    end
  end,
})

telescope.setup({
  defaults = {
    path_display = { 'truncate', 'filename_first' },
    -- hidden = true below would otherwise surface .git internals
    file_ignore_patterns = { '^%.git/' },
    mappings = {
      i = { ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist },
      n = { ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    frecency = {
      db_safe_mode = false,
      db_validate_threshold = 0,
      show_filter_column = false,
    },
    ['ui-select'] = require('telescope.themes').get_dropdown({}),
  },
})
telescope.load_extension('fzf')
telescope.load_extension('ui-select') -- vim.ui.select (code actions, etc.) in a dropdown
telescope.load_extension('frecency')

local function project_root()
  return vim.fs.root(0, '.git') or vim.fs.root(vim.uv.cwd(), '.git') or vim.uv.cwd()
end

-- Search prefix: <leader>s + what to search for
vim.keymap.set('n', '<leader>sf', function()
  telescope.extensions.frecency.frecency({ cwd = project_root(), workspace = 'CWD', hidden = true })
end, { desc = 'Find files (frecency)' })
vim.keymap.set('n', '<leader>sF', function()
  builtin.find_files({ cwd = project_root(), hidden = true })
end, { desc = 'Find all files (incl. hidden)' })
vim.keymap.set('n', '<leader>sg', function()
  builtin.live_grep({ cwd = project_root(), hidden = true})
end, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
