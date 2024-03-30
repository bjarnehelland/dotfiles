-- Lazy install bootstrap snippet
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable release
    lazyrepo,
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.cmd([[command! -nargs=0 GoToCommand :Telescope commands]])
vim.cmd([[command! -nargs=0 GoToFile :Telescope find_files]])
vim.cmd([[command! -nargs=0 Grep :Telescope live_grep]])

require("lazy").setup({
  {
    import = "plugins",
  },
  -- {
  --   install = {
  --     colorscheme = { "catppuccin-mocha" },
  --   },
  --   checker = {
  --     enabled = true,
  --     notify = false,
  --   },
  --   change_detection = {
  --     notify = false,
  --   },
  -- },
})
