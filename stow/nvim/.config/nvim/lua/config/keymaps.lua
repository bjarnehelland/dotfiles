-- For conciseness
local opts = { noremap = true, silent = true }

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Press jk fast to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Navigate buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
